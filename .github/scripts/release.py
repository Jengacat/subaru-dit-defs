#!/usr/bin/env python3
"""Release builder for this repository (run by .github/workflows/release.yml; also works locally).

    python3 .github/scripts/release.py version [VERSION]    which version to release, as GitHub Actions outputs
    python3 .github/scripts/release.py build VERSION OUT     the four zips and OUT/notes.md

version: with no VERSION, the newest dated heading in CHANGELOG.md ("## v0.9.1-beta (2026-12-01)"; "Unreleased" and
undated headings never release). Prints version=... and release=true, or release=false when that tag already exists.

build: one zip per ECU family, each with everything an owner of those cars needs, in this repository's folder layout
(so the READMEs' links still work), plus a START_HERE.md. Only files tracked by git are packed, so nothing local can
leak into a zip. notes.md is the zip table followed by the version's CHANGELOG section.

    FA20DIT     2014-2021 WRX and WRX S4, 2015-2018 Forester XT / tS, 2015-2017 Legacy / Outback, Levorg 2.0
    FB16DIT     2014-2020 Levorg 1.6
    FA24-Early  2019-2021 Ascent and Legacy / Outback XT (SH72544R)
    RH850       2022+ WRX, 2023+ Ascent and Legacy / Outback XT
"""
import fnmatch
import os
import re
import subprocess
import sys
import zipfile

REPO = 'Jengacat/subaru-dit-defs'
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
HEADING = re.compile(r'^## (v\d+\.\d+\.\d+[\w.-]*) \((\d{4}-\d{2}-\d{2})\)\s*$', re.M)

COMMON = ['README.md', 'CHANGELOG.md', 'LICENSE', 'definitions/README.md', 'definitions/romraider/README.md',
          'definitions/ecuflash/README.md', 'logger/README.md', 'tools/README.md', 'tools/checksum.py',
          'tools/checksum.ps1', 'docs/README.md', 'docs/ROM_IDS.md', 'docs/guide/*', 'docs/images/*']
SH = ['tools/logpatch/README.md', 'tools/logpatch/make_logpatch.py', 'tools/logpatch/make_logpatch.ps1',
      'definitions/ecuflash/*/read_subaruhitachish72544.xml', 'extras/README.md']
RR_FA20 = ['definitions/romraider/FA20DIT_RomRaider.xml', 'definitions/romraider/FA20DIT_RomRaider_Checksum.xml',
           'definitions/romraider/checksum/FA20Sum16.java', 'definitions/romraider/checksum/com/*/FA20Sum16.class']

BUNDLES = {
    'FA20DIT': {
        'cars': '2014–2021 WRX and WRX S4, 2015–2018 Forester XT and tS, 2015–2017 Legacy and Outback, Levorg 2.0',
        'prefix': 'FA20DIT',
        'files': COMMON + SH + RR_FA20 + [
            'definitions/ecuflash/*/FA20DIT_*', 'logger/FA20DIT_Logger*.xml', 'logger/DIT_Logger_SUBUDS.xml',
            'extras/can/README.md', 'extras/can/FA20DIT_CAN*'],
        'romraider': '`definitions/romraider/FA20DIT_RomRaider.xml` (or `FA20DIT_RomRaider_Checksum.xml` with its '
                     '`checksum/` folder, RomRaider 1.1.1 or later)',
        'ecuflash': '`FA20DIT_BASE_EcuFlash.xml` (Metric: `FA20DIT_BASE_METRIC_EcuFlash.xml`) plus '
                    '`FA20DIT_<calibration ID>_EcuFlash.xml`, from `definitions/ecuflash/Imperial/` or `Metric/`',
        'logger': '`logger/FA20DIT_Logger.xml`; `FA20DIT_Logger_LogPatch.xml` on a ROM with the logging patch; '
                  '`DIT_Logger_SUBUDS.xml` with a SUBUDS RomRaider build',
    },
    'FB16DIT': {
        'cars': '2014–2020 Levorg 1.6',
        'prefix': 'FB16DIT',
        'files': COMMON + SH + [
            'definitions/romraider/FB16DIT_RomRaider.xml', 'definitions/romraider/FB16DIT_RomRaider_Checksum.xml',
            'definitions/romraider/checksum/FA20Sum16.java', 'definitions/romraider/checksum/com/*/FA20Sum16.class',
            'definitions/ecuflash/*/FB16DIT_*', 'logger/FA20DIT_Logger*.xml', 'logger/DIT_Logger_SUBUDS.xml',
            'extras/can/README.md', 'extras/can/FA20DIT_CAN*'],
        'romraider': '`definitions/romraider/FB16DIT_RomRaider.xml` (or `FB16DIT_RomRaider_Checksum.xml` with its '
                     '`checksum/` folder, RomRaider 1.1.1 or later)',
        'ecuflash': '`FB16DIT_BASE_EcuFlash.xml` (Metric: `FB16DIT_BASE_METRIC_EcuFlash.xml`) plus '
                    '`FB16DIT_<calibration ID>_EcuFlash.xml`, from `definitions/ecuflash/Imperial/` or `Metric/`',
        'logger': '`logger/FA20DIT_Logger.xml` (it covers the 1.6 too); `FA20DIT_Logger_LogPatch.xml` on a ROM with '
                  'the logging patch; `DIT_Logger_SUBUDS.xml` with a SUBUDS RomRaider build',
    },
    'FA24-Early': {
        'cars': '2019–2021 Ascent and Legacy / Outback XT (FA24DIT on the SH72544R ECU)',
        'prefix': 'FA24_Early',
        'files': COMMON + SH + RR_FA20 + [
            'definitions/ecuflash/*/FA20DIT_BASE_*', 'definitions/ecuflash/*/FA24_Early_*',
            'logger/FA24_Early_Logger*.xml', 'logger/DIT_Logger_SUBUDS.xml', 'extras/can/FA24_Early_CAN*'],
        'romraider': '`definitions/romraider/FA20DIT_RomRaider.xml` (these ROMs are in the FA20DIT file; or '
                     '`FA20DIT_RomRaider_Checksum.xml` with its `checksum/` folder, RomRaider 1.1.1 or later)',
        'ecuflash': 'both base files, `FA20DIT_BASE_EcuFlash.xml` **and** `FA24_Early_BASE_EcuFlash.xml` (Metric: '
                    'the `_METRIC` ones), plus `FA24_Early_<calibration ID>_EcuFlash.xml`, from '
                    '`definitions/ecuflash/Imperial/` or `Metric/`',
        'logger': 'Ascent: `logger/FA24_Early_Logger.xml`, `FA24_Early_Logger_LogPatch.xml` on a ROM with the logging '
                  'patch, or `DIT_Logger_SUBUDS.xml` with a SUBUDS RomRaider build. Legacy / Outback XT: its ECU has no '
                  'SSM, so only RomRaider\'s OBD protocol logs it for now',
    },
    'RH850': {
        'cars': '2022+ WRX, 2023+ Ascent and Legacy / Outback XT (FA24DIT on the Renesas RH850 ECU)',
        'prefix': 'FA24DIT',
        'files': COMMON + [
            'definitions/romraider/FA24DIT_RomRaider.xml', 'definitions/romraider/FA24DIT_RomRaider_Checksum.xml',
            'definitions/romraider/checksum/RH850Sum16.java', 'definitions/romraider/checksum/com/*/RH850Sum16.class',
            'definitions/ecuflash/*/FA24DIT_*', 'logger/DIT_Logger_SUBUDS.xml', 'tools/ef_view.py', 'tools/ef_view.ps1',
            'docs/WRX_2022plus.md', 'extras/README.md', 'extras/can/FA24DIT_CAN*'],
        'romraider': '`definitions/romraider/FA24DIT_RomRaider.xml` (or `FA24DIT_RomRaider_Checksum.xml` with its '
                     '`checksum/` folder, RomRaider 1.1.1 or later)',
        'ecuflash': '`FA24DIT_BASE_EcuFlash.xml` (Metric: `FA24DIT_BASE_METRIC_EcuFlash.xml`) plus '
                    '`FA24DIT_<calibration ID>_EcuFlash.xml`: made for FastECU; EcuFlash itself only opens a 3 MB '
                    'copy made with `tools/ef_view.py` (see `docs/WRX_2022plus.md`)',
        'logger': '`logger/DIT_Logger_SUBUDS.xml` with a SUBUDS RomRaider build, module ECU-RH850',
    },
}

START = """# subaru-dit-defs {version}: {name}

For the {cars}. This download has only the files for these cars; the full repository is at
https://github.com/Jengacat/subaru-dit-defs.

**Status: beta.** Nothing has been validated on a running engine or flashed to a car yet. Keep a stock read of your
ECU, and read "Known issues" in README.md first.

1. Find your ROM's calibration ID in README.md (ROM lists). A ROM that isn't listed is not supported.
2. **RomRaider:** add {romraider} in the Definition Manager.
3. **EcuFlash / FastECU:** copy {ecuflash} into one folder under your EcuFlash metadata folder.
4. **Before every flash**, fix and check the checksum: `python3 tools/checksum.py fix edited.bin fixed.bin`, then
   `python3 tools/checksum.py verify fixed.bin` (Windows without Python: `tools/checksum.ps1`, same arguments).
5. **Logging:** {logger}. Details in `logger/README.md`.

ROMs in this download: {count}. The tuning guide is in `docs/guide/README.md`.
"""


def git(*a):
    return subprocess.run(['git', '-C', ROOT] + list(a), check=True, capture_output=True, text=True).stdout


def changelog():
    return open(os.path.join(ROOT, 'CHANGELOG.md'), encoding='utf-8').read()


def section(version):
    text = changelog()
    m = re.search(r'^## ' + re.escape(version) + r' \(.*$', text, re.M)
    if not m:
        sys.exit('CHANGELOG.md has no dated heading for %s' % version)
    rest = text[m.end():]
    n = re.search(r'^## ', rest, re.M)
    return rest[:n.start() if n else len(rest)].strip()


def cmd_version(wanted):
    found = [m.group(1) for m in HEADING.finditer(changelog())]
    version = wanted or (found[0] if found else '')
    if not version:
        print('release=false')
        return
    if version not in found:
        sys.exit('CHANGELOG.md has no dated heading for %s' % version)
    tags = git('tag', '--list', version).split()
    print('version=%s' % version)
    print('release=%s' % ('false' if version in tags else 'true'))


def cmd_build(version, out):
    os.makedirs(out, exist_ok=True)
    files = git('ls-files').split('\n')[:-1]
    rows = []
    for name, b in BUNDLES.items():
        pick = []
        for pat in b['files']:
            hit = [f for f in files if fnmatch.fnmatch(f, pat)]
            if not hit:
                sys.exit('%s: nothing matches %s' % (name, pat))
            pick += [f for f in hit if f not in pick]
        ids = sorted({m.group(1) for f in pick
                      for m in [re.match(r'definitions/ecuflash/Imperial/' + b['prefix'] + r'_(L[A-Za-z0-9]{7})_', f)]
                      if m})
        pick += [f for f in ('tools/logpatch/specs/logpatch_%s.json' % i for i in ids) if f in files]
        start = START.format(version=version, name=name, cars=b['cars'], romraider=b['romraider'],
                             ecuflash=b['ecuflash'], logger=b['logger'], count='%d (%s)' % (len(ids), ', '.join(ids)))
        top = 'subaru-dit-defs_%s_%s' % (version, name)
        zp = os.path.join(out, top + '.zip')
        with zipfile.ZipFile(zp, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
            z.writestr(top + '/START_HERE.md', start)
            for f in pick:
                z.write(os.path.join(ROOT, f), top + '/' + f)
        rows.append('| %s | %d | `%s.zip` |' % (b['cars'], len(ids), top))
        print('%s: %d files, %d ROMs, %.1f MB' % (zp, len(pick), len(ids), os.path.getsize(zp) / 1e6))
    notes = ['Beta: nothing has been validated on a running engine or flashed to a car yet. Keep a stock read of your '
             'ECU and read the README\'s known issues first.', '',
             'Download the zip for your car. Each has only the files those cars need, plus a `START_HERE.md` with the '
             'steps. Find your calibration ID in the [ROM lists](https://github.com/%s#rom-lists) first: a ROM that '
             'isn\'t listed isn\'t supported.' % REPO, '', '| Car | ROMs | Zip |', '|---|---|---|'] + rows + \
            ['', '## What\'s new', '', section(version), '']
    open(os.path.join(out, 'notes.md'), 'w', encoding='utf-8').write('\n'.join(notes))


def main():
    a = sys.argv[1:]
    if a[:1] == ['version']:
        cmd_version(a[1] if len(a) > 1 else '')
    elif a[:1] == ['build'] and len(a) == 3:
        cmd_build(a[1], a[2])
    else:
        sys.exit(__doc__)


if __name__ == '__main__':
    main()

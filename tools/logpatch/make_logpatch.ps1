<#
.SYNOPSIS
    FA20DIT logging patch: re-point spare SSM 0xA8 index slots at RAM values and fix the checksum.
    Windows PowerShell 5.1 or later. Same rules and checks as make_logpatch.py.

.DESCRIPTION
    Only two things change: the 32-bit pointer words of the spec's slots in the 848-entry index table, and the
    checksum correction word at the end of the image (0x1FFFFE for 2 MB, 0x27FFFE for 2.5 MB images; 16-bit big-endian
    word sum from 0x6000 to the end = 0x5AA5, as checksum.ps1).

    Refuses to write anything if:
      * the ROM is not 2 MB, its checksum is already bad, or it doesn't contain the spec's calibration ID;
      * the table base is not loaded as a literal anywhere in the ROM;
      * the table's two "spare" pointers (its two most common values) don't point at a constant 0x00/0xFF ROM byte;
      * a slot to patch is already in use (doesn't hold a spare pointer), is listed twice, or is out of range;
      * a new pointer is not in RAM 0xFFF80000..0xFFF9FFFF.
    After writing it re-reads the file and verifies: bytes changed only inside the patched words and the correction
    word, every slot reads back as requested, and the checksum and validity markers are good.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File make_logpatch.ps1 specs\logpatch_LF75404S.json stock.bin stock_logpatch.bin

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File make_logpatch.ps1 -Verify specs\logpatch_LF75404S.json stock.bin stock_logpatch.bin

.NOTES
    Exit code 0 = PASS, 1 = refused or FAIL.
#>
param(
    [switch]$Verify,
    [Parameter(Mandatory = $true, Position = 0)][string]$Spec,
    [Parameter(Mandatory = $true, Position = 1)][string]$Rom,
    [Parameter(Mandatory = $true, Position = 2)][string]$Out
)

$ErrorActionPreference = 'Stop'
$START  = 0x6000
$SIZES  = @(0x200000, 0x280000)                 # 2015-2018 (2 MB) and 2019+ (2.5 MB, SH72544R) images
$END    = 0x200000
$SUMLOC = 0x1FFFFE
$TARGET = 0x5AA5
$N      = 0x350
# (a hex literal above 0x7FFFFFFF is a negative Int32 in PowerShell 5.1, so these are parsed from strings)
$RAM_LO = [Convert]::ToInt64('FFF80000', 16)
$RAM_HI = [Convert]::ToInt64('FFFA0000', 16)

# Fast word sum and byte diff in C# (compiled once per session); plain PowerShell loops if Add-Type is not allowed.
$fast = $false
if ($env:FA20_NO_CSHARP) { Write-Host '  (C# helper disabled by FA20_NO_CSHARP)' } else { try {
    if (-not ('FA20Patch' -as [type])) {
        Add-Type -TypeDefinition @'
using System.Collections.Generic;
public static class FA20Patch {
    public static int Sum16(byte[] d, int lo, int hi, int skip) {
        int s = 0;
        for (int a = lo; a < hi; a += 2) {
            if (a == skip) continue;
            s = (s + ((d[a] << 8) | d[a + 1])) & 0xFFFF;
        }
        return s;
    }
    public static int[] Diff(byte[] a, byte[] b) {
        List<int> r = new List<int>();
        for (int i = 0; i < a.Length; i++) if (a[i] != b[i]) r.Add(i);
        return r.ToArray();
    }
}
'@
    }
    $fast = $true
} catch {
    Write-Host '  (C# helper unavailable, using the slower PowerShell loops)'
} }

function Stop-Refused([string]$msg) { Write-Host $msg; exit 1 }

function Get-Word([byte[]]$d, [int]$a) { return ([int]$d[$a] -shl 8) -bor [int]$d[$a + 1] }

function Get-U32([byte[]]$d, [int]$a) {
    return ([long]$d[$a] -shl 24) -bor ([long]$d[$a + 1] -shl 16) -bor ([long]$d[$a + 2] -shl 8) -bor [long]$d[$a + 3]
}

function Set-U32([byte[]]$d, [int]$a, [long]$v) {
    $d[$a]     = [byte](($v -shr 24) -band 0xFF)
    $d[$a + 1] = [byte](($v -shr 16) -band 0xFF)
    $d[$a + 2] = [byte](($v -shr 8) -band 0xFF)
    $d[$a + 3] = [byte]($v -band 0xFF)
}

function ConvertFrom-Hex([string]$s) {
    $t = $s.Trim()
    if ($t.StartsWith('0x') -or $t.StartsWith('0X')) { $t = $t.Substring(2) }
    return [Convert]::ToInt64($t, 16)
}

function Get-Sum16([byte[]]$d, [int]$skip) {
    if ($fast) { return [FA20Patch]::Sum16($d, $START, $END, $skip) }
    $s = 0
    for ($a = $START; $a -lt $END; $a += 2) {
        if ($a -ne $skip) { $s = ($s + (([int]$d[$a] -shl 8) -bor [int]$d[$a + 1])) -band 0xFFFF }
    }
    return $s
}

function Get-Correction([byte[]]$d) { return ($TARGET - (Get-Sum16 $d $SUMLOC) + 0x10000) -band 0xFFFF }

function Get-Diff([byte[]]$a, [byte[]]$b) {
    if ($fast) { return , [FA20Patch]::Diff($a, $b) }
    $r = New-Object System.Collections.Generic.List[int]
    for ($i = 0; $i -lt $a.Length; $i++) { if ($a[$i] -ne $b[$i]) { $r.Add($i) } }
    return , $r.ToArray()
}

function Find-Bytes([byte[]]$d, [byte[]]$pat) {
    # first offset of $pat in $d, or -1 (Latin-1 keeps one char per byte)
    $enc = [System.Text.Encoding]::GetEncoding(28591)
    return $enc.GetString($d).IndexOf($enc.GetString($pat), [System.StringComparison]::Ordinal)
}

# The checksum covers the whole image, so its end, correction word and end markers follow the image size
function Set-Size([int]$n) {
    $script:END = $n; $script:SUMLOC = $n - 2
}

# Checksum and validity markers, same report as checksum.ps1 / checksum.py
function Test-Image([byte[]]$d) {
    $ok = $true
    if ($SIZES -notcontains $d.Length) { Write-Host ('  size {0}, expected {1} or {2}' -f $d.Length, $SIZES[0], $SIZES[1]); return $false }
    Set-Size $d.Length
    $s = Get-Sum16 -d $d -skip (-1)
    $good = ($s -eq $TARGET)
    if (-not $good) { $ok = $false }
    $extra = ''
    if (-not $good) { $extra = ' (should be 0x{0:X4})' -f (Get-Correction $d) }
    Write-Host ('  sum16 0x{0:X4}..0x{1:X6} = 0x{2:X4} (need 0x{3:X4}) {4}; correction word 0x{5:X6} = 0x{6:X4}{7}' -f `
        $START, $END, $s, $TARGET, $(if ($good) { 'OK' } else { 'BAD' }), $SUMLOC, (Get-Word $d $SUMLOC), $extra)
    foreach ($m in @(@(0x6000, 0x5555), @(($END - 0xE), 0xAAAA))) {
        $v = Get-Word $d $m[0]
        $mok = ($v -eq $m[1])
        if (-not $mok) { $ok = $false }
        Write-Host ('  marker word 0x{0:X4} = 0x{1:X4}: {2}' -f $m[0], $m[1], $(if ($mok) { 'OK' } else { 'BAD (0x{0:X4})' -f $v }))
    }
    $a = Get-Word $d 0x6C; $b = Get-Word $d 0x6010
    $mok = ($a -eq $b)
    if (-not $mok) { $ok = $false }
    Write-Host ('  marker word 0x006C = word 0x6010 (0x{0:X4} / 0x{1:X4}): {2}' -f $a, $b, $(if ($mok) { 'OK' } else { 'BAD' }))
    $r0 = Get-Word $d ($END - 0x20); $r1 = Get-Word $d ($END - 0x1E)
    $mok = ($r0 -eq $TARGET -and $r1 -eq $TARGET)
    if (-not $mok) { $ok = $false }
    Write-Host ('  runtime reference words 0x{3:X6}/E2 = 0x{0:X4}/0x{1:X4}: {2}' -f $r0, $r1, $(if ($mok) { 'OK' } else { 'UNEXPECTED' }), ($END - 0x20))
    return $ok
}

# Pointer table and spare pointers: the two most common values (ties: the one seen first), both a constant 0x00/0xFF
function Get-TableInfo([byte[]]$d, [int]$base) {
    $ptrs = New-Object 'long[]' $N
    $count = @{}; $first = @{}
    for ($i = 0; $i -lt $N; $i++) {
        $p = Get-U32 $d ($base + 4 * $i)
        $ptrs[$i] = $p
        if ($count.ContainsKey($p)) { $count[$p]++ } else { $count[$p] = 1; $first[$p] = $i }
    }
    $top = $count.Keys | Sort-Object @{ Expression = { $count[$_] }; Descending = $true }, @{ Expression = { $first[$_] } } |
        Select-Object -First 2
    $spare = @{}
    foreach ($a in $top) {
        if (-not ($a -lt $END -and ($d[[int]$a] -eq 0x00 -or $d[[int]$a] -eq 0xFF))) {
            Stop-Refused ('spare pointer {0:X6} is not a constant 0x00/0xFF ROM byte' -f $a)
        }
        $spare[$a] = $true
    }
    return @{ Ptrs = $ptrs; Spare = $spare }
}

function Test-Spec($spec, [byte[]]$d) {
    $base = [int](ConvertFrom-Hex $spec.table)
    if ($SIZES -notcontains $d.Length) { Stop-Refused ('image size {0}, expected {1} or {2}' -f $d.Length, $SIZES[0], $SIZES[1]) }
    Set-Size $d.Length
    # the spec's RAM addresses are per calibration: refuse a ROM with another calibration ID
    if ((Find-Bytes $d ([System.Text.Encoding]::ASCII.GetBytes($spec.calid))) -lt 0) {
        Stop-Refused ('calibration ID {0} not found in the image: this spec is for another ROM' -f $spec.calid)
    }
    $lit = [byte[]]@((($base -shr 24) -band 0xFF), (($base -shr 16) -band 0xFF), (($base -shr 8) -band 0xFF), ($base -band 0xFF))
    if ((Find-Bytes $d $lit) -lt 0) { Stop-Refused ('table base {0:X6} is not loaded as a literal anywhere in the image' -f $base) }
    $info = Get-TableInfo $d $base
    $ptrs = $info.Ptrs; $spare = $info.Spare
    $seen = @{}
    $patches = New-Object System.Collections.ArrayList
    foreach ($e in $spec.entries) {
        $s = [int](ConvertFrom-Hex $e.slot); $ram = ConvertFrom-Hex $e.ram
        if ($seen.ContainsKey($s)) { Stop-Refused ('slot 0x{0:X3} listed twice' -f $s) }
        $seen[$s] = $true
        if (-not (0 -lt $s -and $s -lt $N)) { Stop-Refused ('slot 0x{0:X3} out of range' -f $s) }
        if (-not $spare.ContainsKey($ptrs[$s])) { Stop-Refused ('slot 0x{0:X3} is not spare (points at {1:X8})' -f $s, $ptrs[$s]) }
        if (-not ($RAM_LO -le $ram -and $ram -lt $RAM_HI)) { Stop-Refused ('slot 0x{0:X3}: {1:X8} is not RAM' -f $s, $ram) }
        [void]$patches.Add(@{ Slot = $s; Ram = $ram })
    }
    $stockRam = @{}
    for ($i = 0; $i -lt $N; $i++) {
        $p = $ptrs[$i]
        if ($RAM_LO -le $p -and $p -lt $RAM_HI) { $stockRam[$p] = $i }   # last index wins, as make_logpatch.py
    }
    $notes = @()
    foreach ($q in $patches) {
        if ($stockRam.ContainsKey($q.Ram)) {
            $notes += ('slot 0x{0:X3}: {1:X8} is already behind stock index 0x{2:X3}' -f $q.Slot, $q.Ram, $stockRam[$q.Ram])
        }
    }
    return @{ Base = $base; Ptrs = $ptrs; Spare = $spare; Patches = $patches; Notes = $notes }
}

function Test-Patched($spec, [byte[]]$src, [byte[]]$out) {
    $c = Test-Spec $spec $src
    $base = $c.Base
    $ok = $true
    $allowed = @{ $SUMLOC = $true; ($SUMLOC + 1) = $true }
    $slots = @{}
    foreach ($q in $c.Patches) {
        $slots[$q.Slot] = $true
        for ($k = 0; $k -lt 4; $k++) { $allowed[$base + 4 * $q.Slot + $k] = $true }
    }
    if ($out.Length -ne $src.Length) { Write-Host ('  FAIL: patched file is {0} bytes, input {1}' -f $out.Length, $src.Length); return $false }
    $diff = Get-Diff $src $out
    $outside = @($diff | Where-Object { -not $allowed.ContainsKey($_) })
    $words = @($diff | Where-Object { $_ -ge $base -and $_ -lt $base + 4 * $N } | ForEach-Object { [int][math]::Floor(($_ - $base) / 4) } |
        Sort-Object -Unique)
    $cw = 'unchanged'
    if (@($diff | Where-Object { $_ -eq $SUMLOC -or $_ -eq $SUMLOC + 1 }).Count -gt 0) { $cw = 'changed' }
    Write-Host ('  diff: {0} bytes changed, {1} table words (slots {2}), correction word {3}; outside allowed: {4}' -f `
        $diff.Count, $words.Count, (($words | ForEach-Object { '0x{0:X3}' -f $_ }) -join ','), $cw, $outside.Count)
    if ($outside.Count -gt 0) {
        $ok = $false
        Write-Host ('  FAIL: bytes changed outside the patched words: {0}' -f (($outside | Select-Object -First 20 | ForEach-Object { '{0:X6}' -f $_ }) -join ', '))
    }
    $bad = @($c.Patches | Where-Object { (Get-U32 $out ($base + 4 * $_.Slot)) -ne $_.Ram -or -not $c.Spare.ContainsKey($c.Ptrs[$_.Slot]) } |
        ForEach-Object { '0x{0:X3}' -f $_.Slot })
    $rb = 'yes'
    if ($bad.Count -gt 0) { $rb = 'NO ({0})' -f ($bad -join ', '); $ok = $false }
    Write-Host ('  slots: {0} patched, all were spare before and read back as requested: {1}' -f $c.Patches.Count, $rb)
    $other = @($words | Where-Object { -not $slots.ContainsKey($_) })
    if ($other.Count -gt 0) {
        $ok = $false
        Write-Host ('  FAIL: table words changed that are not in the spec: {0}' -f (($other | ForEach-Object { '0x{0:X3}' -f $_ }) -join ', '))
    }
    foreach ($n in $c.Notes) { Write-Host ('  note: {0}' -f $n) }
    Write-Host '  checksum (checksum.ps1 rule):'
    if (-not (Test-Image $out)) { $ok = $false }
    Write-Host ('  RESULT: {0}' -f $(if ($ok) { 'PASS' } else { 'FAIL' }))
    return $ok
}

$specPath = (Resolve-Path -LiteralPath $Spec).ProviderPath
$romPath  = (Resolve-Path -LiteralPath $Rom).ProviderPath
$specObj  = [System.IO.File]::ReadAllText($specPath) | ConvertFrom-Json
$src      = [System.IO.File]::ReadAllBytes($romPath)

if ($Verify) {
    $outPath = (Resolve-Path -LiteralPath $Out).ProviderPath
    $patched = [System.IO.File]::ReadAllBytes($outPath)
    if (Test-Patched $specObj $src $patched) { exit 0 } else { exit 1 }
}

$outPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Out)
if ($outPath -eq $romPath) { Stop-Refused 'the output file must not be the input ROM' }
if (-not (Test-Image $src)) { Stop-Refused 'input image does not pass the checksum check; refusing to patch' }
$c = Test-Spec $specObj $src
$d = [byte[]]$src.Clone()
foreach ($q in $c.Patches) { Set-U32 $d ($c.Base + 4 * $q.Slot) $q.Ram }
$old = Get-Word $d $SUMLOC
$new = Get-Correction $d
$d[$SUMLOC] = [byte](($new -shr 8) -band 0xFF)
$d[$SUMLOC + 1] = [byte]($new -band 0xFF)
[System.IO.File]::WriteAllBytes($outPath, $d)
Write-Host ('{0}: {1}, table {2:X6}, {3} slots re-pointed, correction word 0x{4:X4} -> 0x{5:X4} -> {6}' -f `
    (Split-Path -Leaf $romPath), $specObj.calid, $c.Base, $c.Patches.Count, $old, $new, $outPath)
$written = [System.IO.File]::ReadAllBytes($outPath)
if (Test-Patched $specObj $src $written) { exit 0 } else { exit 1 }

<#
.SYNOPSIS
    FA20DIT (SH72543R) flash checksum: verify or fix a 2 MB ROM image. Windows PowerShell 5.1 or later.

.DESCRIPTION
    The ECU requires the 16-bit sum of all big-endian words from 0x6000 up to 0x200000 to equal 0x5AA5.
    The word at 0x1FFFFE is the correction word; "fix" rewrites only that word. The validity markers
    (word 0x6000 = 0x5555, word 0x1FFFF2 = 0xAAAA, word 0x006C = word 0x6010) and the runtime reference
    words (0x1FFFE0 and 0x1FFFE2 = 0x5AA5) are checked and reported, never edited.
    Same rule and checks as tools/checksum.py.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File tools\checksum.ps1 fix edited.bin edited_fixed.bin

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File tools\checksum.ps1 verify edited_fixed.bin

.NOTES
    "fix" without an output file overwrites the input. Exit code 0 = every check OK, 1 = something failed.
#>
param(
    [Parameter(Mandatory = $true, Position = 0)][ValidateSet('verify', 'fix')][string]$Mode,
    [Parameter(Mandatory = $true, Position = 1)][string]$Image,
    [Parameter(Position = 2)][string]$Out
)

$ErrorActionPreference = 'Stop'
$START  = 0x6000
$END    = 0x200000
$SUMLOC = 0x1FFFFE
$TARGET = 0x5AA5

# Fast 16-bit word sum in C# (compiled once per session); falls back to plain PowerShell if Add-Type is not allowed.
$fast = $false
try {
    if (-not ('FA20Sum' -as [type])) {
        Add-Type -TypeDefinition @'
public static class FA20Sum {
    public static int Sum16(byte[] d, int lo, int hi, int skip) {
        int s = 0;
        for (int a = lo; a < hi; a += 2) {
            if (a == skip) continue;
            s = (s + ((d[a] << 8) | d[a + 1])) & 0xFFFF;
        }
        return s;
    }
}
'@
    }
    $fast = $true
} catch {
    Write-Host '  (C# helper unavailable, using the slower PowerShell loop)'
}

function Get-Word([byte[]]$d, [int]$a) { return ([int]$d[$a] -shl 8) -bor [int]$d[$a + 1] }

function Get-Sum16([byte[]]$d, [int]$skip) {
    if ($fast) { return [FA20Sum]::Sum16($d, $START, $END, $skip) }
    $s = 0
    for ($a = $START; $a -lt $END; $a += 2) {
        if ($a -ne $skip) { $s = ($s + (([int]$d[$a] -shl 8) -bor [int]$d[$a + 1])) -band 0xFFFF }
    }
    return $s
}

function Get-Correction([byte[]]$d) { return ($TARGET - (Get-Sum16 $d $SUMLOC) + 0x10000) -band 0xFFFF }

function Test-Image([byte[]]$d) {
    $ok = $true
    if ($d.Length -ne $END) {
        Write-Host ('  size {0}, expected {1}' -f $d.Length, $END)
        return $false
    }
    $s = Get-Sum16 -d $d -skip (-1)
    $good = ($s -eq $TARGET)
    if (-not $good) { $ok = $false }
    $extra = ''
    if (-not $good) { $extra = ' (should be 0x{0:X4})' -f (Get-Correction $d) }
    Write-Host ('  sum16 0x{0:X4}..0x{1:X6} = 0x{2:X4} (need 0x{3:X4}) {4}; correction word 0x{5:X6} = 0x{6:X4}{7}' -f `
        $START, $END, $s, $TARGET, $(if ($good) { 'OK' } else { 'BAD' }), $SUMLOC, (Get-Word $d $SUMLOC), $extra)
    foreach ($m in @(@(0x6000, 0x5555), @(0x1FFFF2, 0xAAAA))) {
        $v = Get-Word $d $m[0]
        $mok = ($v -eq $m[1])
        if (-not $mok) { $ok = $false }
        Write-Host ('  marker word 0x{0:X4} = 0x{1:X4}: {2}' -f $m[0], $m[1], $(if ($mok) { 'OK' } else { 'BAD (0x{0:X4})' -f $v }))
    }
    $a = Get-Word $d 0x6C; $b = Get-Word $d 0x6010
    $mok = ($a -eq $b)
    if (-not $mok) { $ok = $false }
    Write-Host ('  marker word 0x006C = word 0x6010 (0x{0:X4} / 0x{1:X4}): {2}' -f $a, $b, $(if ($mok) { 'OK' } else { 'BAD' }))
    $r0 = Get-Word $d 0x1FFFE0; $r1 = Get-Word $d 0x1FFFE2
    $mok = ($r0 -eq $TARGET -and $r1 -eq $TARGET)
    if (-not $mok) { $ok = $false }
    Write-Host ('  runtime reference words 0x1FFFE0/E2 = 0x{0:X4}/0x{1:X4}: {2}' -f $r0, $r1, $(if ($mok) { 'OK' } else { 'UNEXPECTED' }))
    return $ok
}

$path = (Resolve-Path -LiteralPath $Image).ProviderPath
$data = [System.IO.File]::ReadAllBytes($path)

if ($Mode -eq 'verify') {
    Write-Host $path
    if (Test-Image $data) { Write-Host '  RESULT: OK'; exit 0 } else { Write-Host '  RESULT: FAILED'; exit 1 }
}

# fix
if ($data.Length -ne $END) { Write-Host ('{0}: size {1}, expected {2}' -f $path, $data.Length, $END); exit 1 }
if ([string]::IsNullOrEmpty($Out)) { $outPath = $path }
else { $outPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Out) }
$old = Get-Word $data $SUMLOC
$new = Get-Correction $data
$data[$SUMLOC] = [byte](($new -shr 8) -band 0xFF)
$data[$SUMLOC + 1] = [byte]($new -band 0xFF)
[System.IO.File]::WriteAllBytes($outPath, $data)
Write-Host ('{0}: correction word 0x{1:X4} -> 0x{2:X4}, written to {3}' -f $path, $old, $new, $outPath)
if (Test-Image $data) { Write-Host '  RESULT: OK'; exit 0 } else { Write-Host '  RESULT: FAILED'; exit 1 }

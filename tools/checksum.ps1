<#
.SYNOPSIS
    DIT flash checksum: verify or fix a 2 MB (2015-2018, SH72543R), 2.5 MB (2019+, SH72544R) or 4032 KB
    (2022+ WRX, RH850) ROM image. Windows PowerShell 5.1 or later.

.DESCRIPTION
    The ECU requires the 16-bit sum of all big-endian words from 0x6000 up to the end of flash (0x200000, or
    0x280000 in a 2.5 MB image) to equal 0x5AA5. The last word (0x1FFFFE / 0x27FFFE) is the correction word;
    "fix" rewrites only that word. The validity markers (word 0x6000 = 0x5555, word 0x1FFFF2 / 0x27FFF2 = 0xAAAA,
    word 0x006C = word 0x6010) and the runtime reference words (0x1FFFE0/E2 or 0x27FFE0/E2 = 0x5AA5) are checked
    and reported, never edited. Same rule and checks as tools/checksum.py.

    2022+ WRX (RH850, 4032 KB image): the 16-bit sum of all little-endian words of the whole file must equal
    0x5AA5; "fix" rewrites the word at file offset 0x3EFF7E (address 0x3FFF7E). That this is the word the factory
    balances is inferred. A 4 MB file (boot block in front) is refused: drop its first 65536 bytes.

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
$END    = 0x200000           # set from the image size below: 0x200000 (2 MB) or 0x280000 (2.5 MB)
$SUMLOC = 0x1FFFFE
$TARGET = 0x5AA5
$SIZES  = @(0x200000, 0x280000)
$RH850_SIZE   = 0x3F0000     # 2022+ WRX: little-endian word sum of the whole file
$RH850_SUMLOC = 0x3EFF7E

function Set-Size([int]$n) {
    $script:END = $n; $script:SUMLOC = $n - 2
}

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
    if (-not ('DITSumLE' -as [type])) {
        Add-Type -TypeDefinition @'
public static class DITSumLE {
    public static int Sum16(byte[] d, int skip) {
        int s = 0;
        for (int a = 0; a + 1 < d.Length; a += 2) {
            if (a == skip) continue;
            s = (s + (d[a] | (d[a + 1] << 8))) & 0xFFFF;
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

function Get-SumLE([byte[]]$d, [int]$skip) {
    if ($fast) { return [DITSumLE]::Sum16($d, $skip) }
    $s = 0
    for ($a = 0; $a + 1 -lt $d.Length; $a += 2) {
        if ($a -ne $skip) { $s = ($s + ([int]$d[$a] -bor ([int]$d[$a + 1] -shl 8))) -band 0xFFFF }
    }
    return $s
}

function Test-RH850([byte[]]$d) {
    $s = Get-SumLE $d (-1)
    $good = ($s -eq $TARGET)
    $w = [int]$d[$RH850_SUMLOC] -bor ([int]$d[$RH850_SUMLOC + 1] -shl 8)
    $extra = ''
    if (-not $good) { $extra = ' (should be 0x{0:X4})' -f (($TARGET - (Get-SumLE $d $RH850_SUMLOC) + 0x10000) -band 0xFFFF) }
    Write-Host ('  2022+ WRX (RH850) image: sum16 of all little-endian words = 0x{0:X4} (need 0x{1:X4}) {2}; correction word 0x{3:X6} (address 0x{4:X6}) = 0x{5:X4}{6}' -f `
        $s, $TARGET, $(if ($good) { 'OK' } else { 'BAD' }), $RH850_SUMLOC, ($RH850_SUMLOC + 0x10000), $w, $extra)
    return $good
}

function Get-Correction([byte[]]$d) { return ($TARGET - (Get-Sum16 $d $SUMLOC) + 0x10000) -band 0xFFFF }

function Test-Image([byte[]]$d) {
    $ok = $true
    if ($d.Length -eq $RH850_SIZE) { return (Test-RH850 $d) }
    if ($d.Length -eq 0x400000) {
        Write-Host '  size 4194304: a 4 MB 2022+ WRX image with its boot block; use the 4032 KB image (drop the first 65536 bytes)'
        return $false
    }
    if ($SIZES -notcontains $d.Length) {
        Write-Host ('  size {0}, expected {1} or {2} (or {3} for a 2022+ WRX)' -f $d.Length, $SIZES[0], $SIZES[1], $RH850_SIZE)
        return $false
    }
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
    Write-Host ('  runtime reference words 0x{0:X6}/{1:X2} = 0x{2:X4}/0x{3:X4}: {4}' -f ($END - 0x20), (($END - 0x1E) -band 0xFF), $r0, $r1, $(if ($mok) { 'OK' } else { 'UNEXPECTED' }))
    return $ok
}

$path = (Resolve-Path -LiteralPath $Image).ProviderPath
$data = [System.IO.File]::ReadAllBytes($path)

if ($Mode -eq 'verify') {
    Write-Host $path
    if (Test-Image $data) { Write-Host '  RESULT: OK'; exit 0 } else { Write-Host '  RESULT: FAILED'; exit 1 }
}

# fix
if ([string]::IsNullOrEmpty($Out)) { $outPath = $path }
else { $outPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Out) }
if ($data.Length -eq $RH850_SIZE) {
    $old = [int]$data[$RH850_SUMLOC] -bor ([int]$data[$RH850_SUMLOC + 1] -shl 8)
    $new = ($TARGET - (Get-SumLE $data $RH850_SUMLOC) + 0x10000) -band 0xFFFF
    $data[$RH850_SUMLOC] = [byte]($new -band 0xFF)
    $data[$RH850_SUMLOC + 1] = [byte](($new -shr 8) -band 0xFF)
    [System.IO.File]::WriteAllBytes($outPath, $data)
    Write-Host ('{0}: correction word 0x{1:X4} -> 0x{2:X4}, written to {3}' -f $path, $old, $new, $outPath)
    if (Test-Image $data) { Write-Host '  RESULT: OK'; exit 0 } else { Write-Host '  RESULT: FAILED'; exit 1 }
}
if ($SIZES -notcontains $data.Length) { Write-Host ('{0}: size {1}, expected {2} or {3}' -f $path, $data.Length, $SIZES[0], $SIZES[1]); exit 1 }
Set-Size $data.Length
$old = Get-Word $data $SUMLOC
$new = Get-Correction $data
$data[$SUMLOC] = [byte](($new -shr 8) -band 0xFF)
$data[$SUMLOC + 1] = [byte]($new -band 0xFF)
[System.IO.File]::WriteAllBytes($outPath, $data)
Write-Host ('{0}: correction word 0x{1:X4} -> 0x{2:X4}, written to {3}' -f $path, $old, $new, $outPath)
if (Test-Image $data) { Write-Host '  RESULT: OK'; exit 0 } else { Write-Host '  RESULT: FAILED'; exit 1 }

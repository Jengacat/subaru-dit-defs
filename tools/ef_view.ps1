<#
.SYNOPSIS
    2022+ WRX (FA24DIT, RH850) EcuFlash view copies: make a 3 MB copy of a 4032 KB image for EcuFlash, and merge the
    edited copy back into the full image with the checksum fixed. Windows PowerShell 5.1 or later.

.DESCRIPTION
    EcuFlash 1.44 has no memory model the size of these images, so the 2022+ WRX EcuFlash definitions use its 3 MB model
    Generic3072K and open a copy of the first 3 MB of the image. Every table is in the first 1 MB. The rest of the
    image (code, and the checksum balancing word at file offset 0x3EFF7E) stays in the full image.
    "merge" puts the copy's 3 MB back in front of the full image's last 1008 KB, then sets the balancing word so
    the 16-bit sum of little-endian words is 0x5AA5 (the rule of tools\checksum.ps1 and tools/checksum.py).
    Same behaviour as tools/ef_view.py.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File tools\ef_view.ps1 view stock.bin stock_view.bin

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File tools\ef_view.ps1 merge stock.bin stock_view.bin edited_full.bin

.NOTES
    Never flash a view copy: it is 3 MB and lacks the end of the image. Exit code 0 = OK, 1 = something failed.
#>
param(
    [Parameter(Mandatory = $true, Position = 0)][ValidateSet('view', 'merge')][string]$Mode,
    [Parameter(Mandatory = $true, Position = 1)][string]$Full,
    [Parameter(Mandatory = $true, Position = 2)][string]$View,
    [Parameter(Position = 3)][string]$Out
)

$ErrorActionPreference = 'Stop'
$SIZE    = 0x3F0000          # 4032 KB: addresses 0x10000-0x3FFFFF
$VSIZE   = 0x300000          # EcuFlash Generic3072K
$SUMLOC  = 0x3EFF7E          # file offset of the balancing word (address 0x3FFF7E)
$TARGET  = 0x5AA5
$MAXDIFF = 0x40000           # more changed bytes than this: the view was made from another image

$fast = $false
try {
    if (-not ('RH850View' -as [type])) {
        Add-Type -TypeDefinition @'
public static class RH850View {
    public static int Sum16(byte[] d) {
        int s = 0;
        for (int a = 0; a + 1 < d.Length; a += 2) s = (s + (d[a] | (d[a + 1] << 8))) & 0xFFFF;
        return s;
    }
    public static int Diff(byte[] a, byte[] b, int n) {
        int c = 0;
        for (int i = 0; i < n; i++) if (a[i] != b[i]) c++;
        return c;
    }
}
'@
    }
    $fast = $true
} catch {
    Write-Host '  (C# helper unavailable, using the slower PowerShell loop)'
}

function Get-Sum16([byte[]]$d) {
    if ($fast) { return [RH850View]::Sum16($d) }
    $s = 0
    for ($a = 0; $a + 1 -lt $d.Length; $a += 2) { $s = ($s + ([int]$d[$a] -bor ([int]$d[$a + 1] -shl 8))) -band 0xFFFF }
    return $s
}

function Get-Diff([byte[]]$a, [byte[]]$b, [int]$n) {
    if ($fast) { return [RH850View]::Diff($a, $b, $n) }
    $c = 0
    for ($i = 0; $i -lt $n; $i++) { if ($a[$i] -ne $b[$i]) { $c++ } }
    return $c
}

function Read-Image([string]$p, [int]$size, [string]$what) {
    $path = (Resolve-Path -LiteralPath $p).ProviderPath
    $d = [System.IO.File]::ReadAllBytes($path)
    if ($d.Length -ne $size) { Write-Host ('{0}: {1} bytes, expected {2} ({3})' -f $path, $d.Length, $size, $what); exit 1 }
    return ,$d
}

function Get-OutPath([string]$p) { return $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($p) }

$fullData = Read-Image $Full $SIZE 'a full RH850 image'

if ($Mode -eq 'view') {
    if ((Get-Sum16 $fullData) -ne $TARGET) { Write-Host ('  warning: sum is 0x{0:X4}, not 0x{1:X4} (already edited?)' -f (Get-Sum16 $fullData), $TARGET) }
    $v = New-Object byte[] $VSIZE
    [System.Array]::Copy($fullData, 0, $v, 0, $VSIZE)
    $vp = Get-OutPath $View
    [System.IO.File]::WriteAllBytes($vp, $v)
    Write-Host ('{0}: first {1} bytes of the image; open it in EcuFlash, then merge it back' -f $vp, $VSIZE)
    exit 0
}

# merge
if ([string]::IsNullOrEmpty($Out)) { Write-Host 'merge needs an output file: ef_view.ps1 merge FULL VIEW OUT'; exit 1 }
$viewData = Read-Image $View $VSIZE 'an EcuFlash view copy'
$changed = Get-Diff $fullData $viewData $VSIZE
if ($changed -gt $MAXDIFF) { Write-Host ('{0} bytes differ: the view was not made from this image' -f $changed); exit 1 }
$o = New-Object byte[] $SIZE
[System.Array]::Copy($viewData, 0, $o, 0, $VSIZE)
[System.Array]::Copy($fullData, $VSIZE, $o, $VSIZE, $SIZE - $VSIZE)
$old = [int]$o[$SUMLOC] -bor ([int]$o[$SUMLOC + 1] -shl 8)
$new = ($old + $TARGET - (Get-Sum16 $o) + 0x10000) -band 0xFFFF
$o[$SUMLOC] = [byte]($new -band 0xFF)
$o[$SUMLOC + 1] = [byte](($new -shr 8) -band 0xFF)
$sum = Get-Sum16 $o
$op = Get-OutPath $Out
[System.IO.File]::WriteAllBytes($op, $o)
Write-Host ('{0}: {1} byte(s) edited; balancing word 0x{2:X6} 0x{3:X4} -> 0x{4:X4}; sum 0x{5:X4}' -f $op, $changed, $SUMLOC, $old, $new, $sum)
if ($sum -eq $TARGET) { Write-Host '  RESULT: OK'; exit 0 } else { Write-Host '  RESULT: FAILED'; exit 1 }

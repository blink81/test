Add-Type @"
using System;
using System.Runtime.InteropServices;
public class W32 {
    [DllImport("kernel32")] public static extern IntPtr GetModuleHandle(string n);
    [DllImport("kernel32")] public static extern bool ReadProcessMemory(IntPtr h, IntPtr a, byte[] b, int s, out int r);
    [DllImport("kernel32")] public static extern IntPtr GetCurrentProcess();
    [DllImport("user32")]   public static extern IntPtr GetDesktopWindow();
}
"@

$hUser32 = [W32]::GetModuleHandle("user32.dll")
$hwnd    = [W32]::GetDesktopWindow()
$hwndIdx = $hwnd.ToInt64() -band 0xFFFF

$buf  = New-Object byte[] 8
$read = 0
$addr = [IntPtr]($hUser32.ToInt64() + 0xbd688)
[W32]::ReadProcessMemory([W32]::GetCurrentProcess(), $addr, $buf, 8, [ref]$read) | Out-Null
$ptr = [BitConverter]::ToInt64($buf, 0)

"USER32 base : 0x{0:X16}" -f $hUser32.ToInt64()
"Reading at  : 0x{0:X16}" -f $addr.ToInt64()
"Value found : 0x{0:X16}" -f $ptr

if ($ptr -gt 0x10000 -and $ptr -lt 0x7FFFFFFF0000) {
    "OFFSET 0xbd688 = VALID user-space pointer"
    "Entry for desktop HWND at: 0x{0:X16}" -f ($ptr + 0x18 * $hwndIdx)
} else {
    "OFFSET 0xbd688 = INVALID - need to scan"
}

$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


$$$ If invalid, find the real offset: $$$

$results = @()
# Scan +-0x20000 around the hardcoded value
for ($off = 0x90000; $off -le 0x100000; $off += 8) {
    $buf  = New-Object byte[] 8
    $read = 0
    $addr = [IntPtr]($hUser32.ToInt64() + $off)
    [W32]::ReadProcessMemory([W32]::GetCurrentProcess(), $addr, $buf, 8, [ref]$read) | Out-Null
    if ($read -ne 8) { continue }
    $ptr = [BitConverter]::ToInt64($buf, 0)

    # Must be a valid user-space pointer
    if ($ptr -le 0x10000 -or $ptr -ge 0x7FFFFFFF0000) { continue }

    # Entry for desktop hwnd must fall in reasonable range (within 64MB of base)
    $entry = $ptr + 0x18 * $hwndIdx
    if ($entry -gt $ptr -and $entry -lt ($ptr + 0x4000000)) {
        $results += "CANDIDATE: offset=0x{0:X} ptr=0x{1:X16} entry=0x{2:X16}" -f $off, $ptr, $entry
    }
}

if ($results.Count -eq 0) {
    "No candidates found - try wider scan range"
} else {
    $results | Select-Object -First 10
}



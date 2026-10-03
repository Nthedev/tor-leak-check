#!/usr/bin/bash

## Add Safe Cofiguration option in new .conf file
sudo touch /etc/tor/torrc.d/no-leaks.conf
if ! sudo grep -q "SafeSocks 1" /etc/tor/torrc.d/no-leaks.conf; then
    echo "SafeSocks 1" | sudo tee -a /etc/tor/torrc.d/no-leaks.conf
fi
if ! sudo grep -q "no-leaks.conf" /etc/tor/torrc; then
    echo "%include /etc/tor/torrc.d/no-leaks.conf" | sudo tee -a /etc/tor/torrc
fi
echo "Added Tor safe configuration option"

## Start tor
if ! systemctl is-active --quiet tor; then
    echo "Starting Tor (requires privileges)"
    sudo systemctl start tor || { echo "Failed to start Tor"; exit 1; }
else systemctl reload-or-restart tor
fi
sleep 5  # Wait for Tor circuits to establish


## Fetch "normal" ip address and ip address after routing traffic through tor
ip=$(curl -s --max-time 10 https://api.ipify.org)
ipv6=$(curl -s --max-time 10 https://api6.ipify.org)
printf "Public ip address:\nipv4: %s \n ipv6: %s\n" "$ip" "$ipv6"

torip=$(torify curl -s --max-time 10 https://api.ipify.org || echo "Error while fetching tor ip address")
toripv6=$(torify curl -s --max-time 10 https://api6.ipify.org)
printf "Anonymized ip address:\nipv4: %s \n ipv6: %s" "$torip" "$toripv6"


## Compare tor and non-tor ip address to check if tor is working properly
if [[ "$ip" != "$torip" ]] && [[ "$ipv6" != "$toripv6" ]]; then
    echo "No IP leaks detected"
else
    echo "Leak detected! Your tor ip address matches your normal ip address."
    exit 1
fi

## Open a browser to make sure local SOCKS5 proxy is working
## Use ipleak.net to check for other ip leaking vectors (Web-RTC, DNS, etc.)
## Opens system browser, also recommends doing the same with tor browser
torify xdg-open https://ipleak.net
printf "Opened https://ipleak.net \n if your browser did not open, please open a a browser with torify YOUR BROWSER (for example brave), then visit https://ipleak.net \n Also make sure to visit https://ipleak.net in tor browser \n it is possible, that this doesn't work and shows your real ip address, do not panic, open your browser settings and add a Socks5 Proxy at 127.0.0.1:9050 \n Note: This script does not guarentee no leaks, but aims to configure tor in a more private way"
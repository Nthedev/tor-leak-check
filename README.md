![License](https://img.shields.io/github/license/Nthedev/tor-leak-check)
![Shell](https://img.shields.io/badge/language-Shell-green)

# 🧅 tor-leak-check

A lightweight Bash script designed to help you verify if you are leaking Personally Identifiable Information (PII) — specifically your real IP address — while connected to the Tor network. It also automatically configures Tor for safer SOCKS proxy usage and launches browser-based leak tests.

## 🚀 Features

- **Automatic Tor Hardening**: Configures your Tor daemon with `SafeSocks 1` to prevent unsafe SOCKS connections that might leak DNS or IP data.
- **Startup Verification**: Automatically starts/restarts the Tor service and waits (with a timeout) for the daemon to become fully active.
- **IP Leak Detection**: Compares your system's actual public IPv4 and IPv6 addresses against the addresses routed through the Tor proxy to detect IP leaks.
- **Browser-Based Testing**: Automatically launches [ipleak.net](https://ipleak.net) via `torify` to check for more complex leaks like WebRTC, DNS, and Torrent leaks.

## 📋 Prerequisites

This script is intended for **Linux** systems and requires the following packages to be installed:

- `tor` (The Tor daemon)
- `curl` (For fetching IP data from APIs)
- `torsocks` / `torify` (To route terminal traffic through Tor)
- `systemd` (For managing the Tor service)
- `xdg-utils` (For `xdg-open` to launch the default web browser)

### Debian / Ubuntu
```bash
sudo apt update
sudo apt install tor torsocks curl xdg-utils
```

### Arch Linux
```bash
sudo pacman -S tor torsocks curl xdg-utils
```

## 📦 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Nthedev/tor-leak-check.git
   ```
2. Navigate into the directory:
   ```bash
   cd tor-leak-check
   ```
3. Make the script executable:
   ```bash
   chmod +x tor-leak-check.sh
   ```

## 🖥️ Usage

Run the script from your terminal. You will be prompted for your `sudo` password, as the script needs elevated privileges to modify Tor's configuration files (`/etc/tor/torrc`) and manage the `systemd` service.

```bash
./tor-leak-check.sh
```

### What to expect:
1. The script will write `SafeSocks 1` to `/etc/tor/torrc.d/no-leaks.conf` and include it in your main `torrc`.
2. It will start or restart the Tor daemon and wait up to 20 seconds for it to initialize.
3. It will fetch your real IPv4 and IPv6 addresses and print them to the console.
4. It will fetch your anonymized (Tor-routed) IPv4 and IPv6 addresses and compare them.
5. If your real IPs match your Tor IPs, it will alert you of a **Leak detected!**
6. Finally, it will attempt to open `https://ipleak.net` in your default browser via `torify`. Follow the on-screen instructions to also test your Tor Browser.

## 🛡️ Manual Browser Testing (Recommended)

While this script configures the daemon and terminal routing, browser-level leaks (like WebRTC) must be tested manually:

1. Open your standard browser through `torify`:
   ```bash
   torify brave # or firefox, chrome, etc.
   ```
2. Visit [https://ipleak.net](https://ipleak.net) and verify that no real IPs or DNS servers are exposed.
3. Open the official **Tor Browser**, visit [https://ipleak.net](https://ipleak.net), and ensure it remains fully anonymous.
4. *(Optional)* If `ipleak.net` shows your real IP in a standard browser, don't panic. Check your browser's proxy settings and ensure the SOCKS5 Proxy is strictly pointing to `127.0.0.1:9050`.

## 🗑️ Uninstall / Revert Changes

If you wish to undo the configuration changes made by this script and return Tor to its default state, run the following commands:

```bash
sudo rm /etc/tor/torrc.d/no-leaks.conf
sudo sed -i '\|%include /etc/tor/torrc.d/no-leaks.conf|d' /etc/tor/torrc
sudo systemctl restart tor
```

## ⚠️ Disclaimer

> This script does not guarantee 100% anonymity or that no leaks exist. It is designed to configure Tor in a more private way and assist in basic network leak checks. Always perform comprehensive manual testing for full operational security (OPSEC).

## 📄 License

This project is licensed under the **GPL-3.0 License**. See the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/Nthedev/tor-leak-check/issues).

---
*Created by [Nthedev](https://github.com/Nthedev)*

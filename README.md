<p align="center">
  <img src="https://img.shields.io/badge/Bash-Shell-green?style=flat-square&logo=gnu-bash" alt="Bash">
  <img src="https://img.shields.io/github/license/Nthedev/tor-leak-check?style=flat-square" alt="License">
</p>

# 🧅 tor-leak-check

A lightweight, automated Bash script designed to configure your local Tor daemon with safe defaults and verify that you are not leaking Personally Identifiable Information (PII) while connected to the Tor network.

## 📖 Overview

`tor-leak-check` automatically hardens your local Tor configuration, verifies that your IPv4 and IPv6 traffic is successfully routed through the network, and launches advanced leak-testing tools to ensure your DNS requests and WebRTC data remain completely hidden.

## ✨ Features

- **Automated Tor Hardening:** Automatically generates a drop-in configuration file (`/etc/tor/torrc.d/no-leaks.conf`) and enables `SafeSocks 1` to aggressively prevent DNS leaks.
- **Service Management:** Automatically starts or reloads the Tor service via `systemd` and polls the daemon until it is fully active (with a 20-second timeout safeguard).
- **IP Verification:** Compares your real public IPv4 and IPv6 addresses against your Tor-routed addresses using external APIs to guarantee your traffic is actually anonymized.
- **Deep Browser Testing:** Automatically opens [ipleak.net](https://ipleak.net) routed through your local Tor SOCKS5 proxy (`127.0.0.1:9050`) to test for WebRTC, DNS, and torrent IP leaks.
- **Error Handling:** Gracefully handles service start failures and connection timeouts, providing clear error messages if the Tor daemon fails to initialize.

## 📋 Prerequisites

This script is designed for Linux systems using `systemd`. Ensure you have the following dependencies installed:

- **Tor:** The Tor daemon.
- **Torsocks:** Provides the `torify` command to route non-native applications through Tor.
- **cURL:** Required for fetching IP addresses from external APIs.
- **xdg-utils:** Required for `xdg-open` to launch your default web browser.

**Debian/Ubuntu Installation:**
```bash
sudo apt update
sudo apt install tor torsocks curl xdg-utils

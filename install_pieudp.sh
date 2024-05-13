#!/bin/bash

# Updating system and installing necessary packages
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl wget

# Downloading Hysteria
HYSTERIA_LATEST=$(curl -s https://api.github.com/repos/HyNetwork/hysteria/releases/latest | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4)
wget $HYSTERIA_LATEST -O hysteria.tar.gz

# Unpacking and setting up Hysteria
sudo tar -xzf hysteria.tar.gz -C /usr/local/bin/
sudo chmod +x /usr/local/bin/hysteria

# Cleaning up
rm hysteria.tar.gz

# Configuration file setup
cat <<EOF | sudo tee /etc/hysteria/config.json
{
    "server": "0.0.0.0:36712",
    "protocol": "udp",
    "auth": {
        "mode": "password",
        "config": {
            "password": "pieudp"
        }
    },
    "obfs": "pieudp"
}
EOF

# Creating systemd service
cat <<EOF | sudo tee /etc/systemd/system/hysteria.service
[Unit]
Description=Hysteria UDP Acceleration Service
After=network.target

[Service]
ExecStart=/usr/local/bin/hysteria -config /etc/hysteria/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Enabling and starting the service
sudo systemctl enable hysteria.service
sudo systemctl start hysteria.service

echo "Hysteria has been installed and started successfully."

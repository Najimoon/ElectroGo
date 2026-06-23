#!/bin/bash
set -e

apt update -y
apt install -y nginx git wget apt-transport-https software-properties-common

wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb

apt update -y
apt install -y dotnet-sdk-8.0

mkdir -p /opt/electrogo
cd /opt/electrogo

git clone https://github.com/Najimoon/ElectroGo.git app
cd app

dotnet restore
dotnet publish -c Release -o /opt/electrogo/publish

cat > /etc/systemd/system/electrogo.service <<EOF
[Unit]
Description=ElectroGO ASP.NET Core App
After=network.target

[Service]
WorkingDirectory=/opt/electrogo/publish
ExecStart=/usr/bin/dotnet /opt/electrogo/publish/ElectroGO.dll --urls http://localhost:5000
Restart=always
RestartSec=10
User=root
Environment=ASPNETCORE_ENVIRONMENT=Production

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable electrogo
systemctl start electrogo

cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

nginx -t
systemctl restart nginx
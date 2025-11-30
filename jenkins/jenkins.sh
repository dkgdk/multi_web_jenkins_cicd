#!/bin/bash
set -e

echo "==========================================="
echo "     FIXING JENKINS GPG + INSTALLATION"
echo "==========================================="

echo "[1] Removing OLD Jenkins repo & keys..."
sudo rm -f /etc/apt/sources.list.d/jenkins.list
sudo rm -f /usr/share/keyrings/jenkins-keyring.asc

echo "[2] Cleaning apt..."
sudo apt clean
sudo apt update || true   # ignore errors here

echo "[3] Adding NEW Jenkins GPG key..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

sudo chmod 644 /usr/share/keyrings/jenkins-keyring.asc

echo "[4] Adding NEW Jenkins repository..."
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "[5] Updating APT..."
sudo apt update -y

echo "[6] Installing Java 17..."
sudo apt install -y openjdk-17-jdk

echo "[7] Installing Jenkins..."
sudo apt install -y jenkins

echo "[8] Starting Jenkins..."
sudo systemctl enable jenkins
sudo systemctl restart jenkins

echo "==========================================="
echo "      JENKINS INSTALLATION COMPLETE"
echo "==========================================="

echo
echo "Jenkins running at: http://<YOUR_SERVER_IP>:8080"
echo "Initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo

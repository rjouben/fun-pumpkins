1. Make Script executable:
+ sudo chmod +x /opt/scripts/cert-sync.sh

2. Create Systemd Service:
+ sudo nano /etc/systemd/system/cert-sync.service

3. Create Systemd Timer:
+ sudo nano /etc/systemd/system/cert-sync.timer

4. Enable and Start the Timer:
+ sudo systemctl daemon-reexec
+ sudo systemctl daemon-reload
+ sudo systemctl enable --now file-sync.timer

5. View Timer Status:
+ systemctl list-timers cert-sync.timer

6. View logs:
+ journalctl -u cert-sync.service
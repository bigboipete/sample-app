#/bin/bash -eux

mkdir /var/gs-spring-boot/
mv /tmp/gs-spring-boot.jar /var/gs-spring-boot/
useradd jambitadmin
chown spring-boot:spring-boot /var/gs-spring-boot/gs-spring-boot.jar
cat <<EOF > /etc/systemd/system/sample-app.service;
[Unit]
Description=gs-spring-boot
After=syslog.target
[Service]
User=jambitadmin
ExecStart=/var/gs-spring-boot/gs-spring-boot.jar
SuccessExitStatus=143
[Install]
WantedBy=multi-user.target
EOF
systemctl enable sample-app.service
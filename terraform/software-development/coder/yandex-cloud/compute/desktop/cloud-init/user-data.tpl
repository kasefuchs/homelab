#cloud-config
ssh_pwauth: false

users:
  - name: ${coder_workspace_owner_name}
    lock_passwd: false
    plain_text_passwd: ${access_password}
    sudo:
      - ALL=(ALL) NOPASSWD:ALL
    groups:
      - sudo
    shell: /bin/bash

write_files:
  # Coder initialization script.
  - path: /opt/coder/init
    permissions: "0755"
    encoding: b64
    content: ${coder_agent_init_script}

  # Coder service.
  - path: /etc/systemd/system/coder-agent.service
    permissions: "0644"
    content: |
      [Unit]
      Description=Coder Agent
      After=network-online.target
      Wants=network-online.target

      [Service]
      User=${coder_workspace_owner_name}
      ExecStart=/opt/coder/init
      Environment=CODER_AGENT_TOKEN=${coder_agent_token}
      Restart=always
      RestartSec=10
      TimeoutStopSec=90
      KillMode=process

      OOMScoreAdjust=-900
      SyslogIdentifier=coder-agent

      [Install]
      WantedBy=multi-user.target

  # LightDM configuration.
  - path: /etc/lightdm/lightdm.conf
    permissions: "0644"
    content: |
      [VNCServer]
      enabled=true
      command=/usr/bin/Xvnc -rfbauth /etc/vncpasswd
      port=5900
      listen-address=127.0.0.1
      depth=16
      width=1280
      height=720

  # NoVNC service.
  - path: /etc/systemd/system/novnc.service
    permissions: "0644"
    content: |
      [Unit]
      Description=Websockify noVNC Server
      After=network.target
      Wants=network.target

      [Service]
      User=${coder_workspace_owner_name}
      ExecStart=/usr/bin/websockify --web /usr/share/novnc/ 127.0.0.1:6080 127.0.0.1:5900
      Restart=on-failure
      RestartSec=10
      KillMode=process

      [Install]
      WantedBy=multi-user.target

runcmd:
  # Set VNC password.
  - echo ${access_password} | /usr/bin/vncpasswd -f > /etc/vncpasswd

  # Start services.
  - systemctl daemon-reload
  - systemctl start coder-agent lightdm novnc

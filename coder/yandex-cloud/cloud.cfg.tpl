#cloud-config
users:
  - name: ${coder_workspace_owner_name}
    sudo:
      - ALL=(ALL) NOPASSWD:ALL
    groups:
      - sudo
    shell: /bin/bash

write_files:
  - path: /opt/coder/init
    permissions: "0755"
    encoding: b64
    content: ${coder_agent_init_script}

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

runcmd:
  - systemctl daemon-reload
  - systemctl enable coder-agent
  - systemctl restart coder-agent

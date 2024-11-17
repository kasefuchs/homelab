module "personalize" {
  source   = "registry.coder.com/modules/personalize/coder"
  version  = "1.0.2"
  agent_id = coder_agent.agent.id

  log_path = "/tmp/personalize.log"
}

module "coder-login" {
  source   = "registry.coder.com/modules/coder-login/coder"
  version  = "1.0.15"
  agent_id = coder_agent.agent.id
}

module "git-config" {
  source   = "registry.coder.com/modules/git-config/coder"
  version  = "1.0.15"
  agent_id = coder_agent.agent.id

  allow_email_change    = false
  allow_username_change = false
}

module "git-commit-signing" {
  source   = "registry.coder.com/modules/git-commit-signing/coder"
  version  = "1.0.11"
  agent_id = coder_agent.agent.id
}

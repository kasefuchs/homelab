resource "nomad_namespace" "namespace" {
  name        = var.name
  meta        = var.meta
  description = var.description

  dynamic "capabilities" {
    for_each = var.capabilities == null ? [] : [var.capabilities]

    content {
      enabled_task_drivers  = try(var.capabilities.task_drivers.enabled, [])
      disabled_task_drivers = try(var.capabilities.task_drivers.disabled, [])
    }
  }
}

resource "nomad_acl_policy" "admin" {
  name = "ns-${nomad_namespace.namespace.name}-admin"
  rules_hcl = templatefile("${path.module}/policies/nomad/ns-admin.hcl.tftpl", {
    nomad_namespace_name = nomad_namespace.namespace.name
  })
}

resource "consul_acl_policy" "policy" {
  name        = "nomad-tasks-${nomad_namespace.namespace.name}"
  description = "ACL policy for Nomad tasks in the ${nomad_namespace.namespace.name} Nomad namespace"

  rules = templatefile("${path.module}/policies/consul/nomad-tasks.hcl.tftpl", {
    nomad_namespace_name          = nomad_namespace.namespace.name
    consul_nomad_tasks_key_prefix = local.consul_nomad_tasks_key_prefix
  })
}

resource "consul_acl_role" "role" {
  name        = "nomad-tasks-${nomad_namespace.namespace.name}"
  description = "ACL role for Nomad tasks in the ${nomad_namespace.namespace.name} Nomad namespace"

  policies = [
    local.consul_nomad_tasks_acl_policy,
    consul_acl_policy.policy.name
  ]
}

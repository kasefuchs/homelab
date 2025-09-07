resource "nomad_dynamic_host_volume" "dynamic_host" {
  name      = each.value.name
  plugin_id = each.value.plugin
  namespace = each.value.namespace

  node_id   = try(each.value.node.id, null)
  node_pool = try(each.value.node.pool, null)

  parameters = each.value.parameters

  capacity_min = try(each.value.capacity.min, null)
  capacity_max = try(each.value.capacity.max, null)

  dynamic "capability" {
    for_each = each.value.capabilities

    content {
      access_mode     = capability.value.access_mode
      attachment_mode = capability.value.attachment_mode
    }
  }

  dynamic "constraint" {
    for_each = each.value.constraints

    content {
      attribute = constraint.value.attribute
      operator  = constraint.value.operator
      value     = constraint.value.value
    }
  }

  for_each = {
    for index, volume in var.dynamic_host :
    volume.name => volume
  }
}

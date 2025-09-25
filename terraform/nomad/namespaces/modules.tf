module "namespace" {
  source = "./namespace"

  name         = each.value.name
  description  = try(each.value.description, "")
  meta         = try(each.value.meta, {})
  capabilities = try(each.value.capabilities, null)

  for_each = {
    for index, namespace in var.namespaces :
    namespace.name => namespace
  }
}

locals {
  root_certificate_ttl = provider::time::duration_parse("87600h").seconds # 10 years.
}

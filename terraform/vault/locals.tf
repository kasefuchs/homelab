locals {
  root_certificate_ttl         = provider::time::duration_parse("87600h").seconds # 10 years.
  intermediate_certificate_ttl = provider::time::duration_parse("43800h").seconds # 5 years.
}

provider "aws" {
  region = var.region
}

module "static_site_cdn" {
  source              = "../../module/static_site_cdn"
  for_each            = { for i in var.static_site_list : i.name => i }
  name                = each.value.name
  allow_locations     = each.value.allow_locations
  price_classes       = each.value.price_classes
  default_root_object = each.value.default_root_object

  system_name = var.system_name
  env         = var.env
}

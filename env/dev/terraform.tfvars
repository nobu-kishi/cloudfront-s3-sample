#--------------------------------------------------------------
# General
#--------------------------------------------------------------
region      = "ap-northeast-1"
system_name = "sample"
env         = "dev"

static_site_list = [
  {
    name                = "static-site"
    allow_locations     = ["US", "JP"]
    price_classes       = "PriceClass_200"
    default_root_object = "index.html"
  },
  # {
  #   name                = "static-site2"
  #   allow_locations     = ["JP"]
  #   price_classes       = "PriceClass_200"
  #   default_root_object = "index.html"
  # }
]
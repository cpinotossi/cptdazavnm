data "azurerm_subscription" "subscription" {
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.prefix
}

resource "azurerm_resource_group" "rg_root" {
  location = var.location
  name     = "${var.prefix}root"
  provider = azurerm.root_1
}
resource "azurerm_resource_group" "rg_plattform_lz_1" {
  location = var.location
  name     = "${var.prefix}platform_lz_1"
  provider = azurerm.plattform_lz_1
}
resource "azurerm_resource_group" "rg_app_lz_1" {
  location = var.location
  name     = "${var.prefix}app_lz_1"
  provider = azurerm.app_lz_1
}
resource "azurerm_resource_group" "rg_app_lz_2" {
  location = var.location
  name     = "${var.prefix}app_lz_2"
  provider = azurerm.app_lz_2
}
resource "azurerm_resource_group" "rg_sandbox_1" {
  location = var.location
  name     = "${var.prefix}sandbox_1"
  provider = azurerm.sandbox_1
}


# module "spoke_app_lz_1" {
#   source                = "./modules/spoke"
#   vnet_name             = "spoke1applz"
#   vnet_address_space    = ["${var.cidrs["spoke1"]}"]
#   subnet_name           = "default"
#   subnet_address_prefixes = ["${var.cidrs["spoke1_subnet_0_default"]}"]
#   resource_group_name   = azurerm_resource_group.rg_app_lz_1.name
#   location              = var.location
#   vm_name               = "${var.prefix}s1"
#   vm_size               = var.vm_size
#   admin_user            = var.admin_user
#   admin_password        = var.admin_password
#   source_image = var.source_image
#   providers = {
#     azurerm = azurerm.app_lz_1
#   }
# }

# module "spoke_app_lz_2" {
#   source                = "./modules/spoke"
#   vnet_name             = "spoke2applz"
#   vnet_address_space    = ["${var.cidrs["spoke2"]}"]
#   subnet_name           = "default"
#   subnet_address_prefixes = ["${var.cidrs["spoke2_subnet_0_default"]}"]
#   resource_group_name   = azurerm_resource_group.rg_app_lz_2.name
#   location              = var.location
#   vm_name               = "${var.prefix}s2"
#   vm_size               = var.vm_size
#   admin_user            = var.admin_user
#   admin_password        = var.admin_password
#   source_image = var.source_image
#   providers = {
#     azurerm = azurerm.app_lz_2
#   }
# }

# module "spoke_sandbox_1" {
#   source                = "./modules/spoke"
#   vnet_name             = "spoke3sandbox"
#   vnet_address_space    = ["${var.cidrs["spoke3"]}"]
#   subnet_name           = "default"
#   subnet_address_prefixes = ["${var.cidrs["spoke3_subnet_0_default"]}"]
#   resource_group_name   = azurerm_resource_group.rg_sandbox_1.name
#   location              = var.location
#   vm_name               = "${var.prefix}s3"
#   vm_size               = var.vm_size
#   admin_user            = var.admin_user
#   admin_password        = var.admin_password
#   source_image = var.source_image
#   providers = {
#     azurerm = azurerm.sandbox_1
#   }
# }






# locals {
#   init_dir = "/var/lib/azure"
#   vm_init_files = {
#     "${local.init_dir}/fastapi/docker-compose-app1-80.yml"   = { owner = "root", permissions = "0744", content = templatefile("../../scripts/init/fastapi/docker-compose-app1-80.yml", {}) }
#     "${local.init_dir}/fastapi/docker-compose-app2-8080.yml" = { owner = "root", permissions = "0744", content = templatefile("../../scripts/init/fastapi/docker-compose-app2-8080.yml", {}) }
#     "${local.init_dir}/fastapi/app/app/Dockerfile"           = { owner = "root", permissions = "0744", content = templatefile("../../scripts/init/fastapi/app/app/Dockerfile", {}) }
#     "${local.init_dir}/fastapi/app/app/_app.py"              = { owner = "root", permissions = "0744", content = templatefile("../../scripts/init/fastapi/app/app/_app.py", {}) }
#     "${local.init_dir}/fastapi/app/app/main.py"              = { owner = "root", permissions = "0744", content = templatefile("../../scripts/init/fastapi/app/app/main.py", {}) }
#     "${local.init_dir}/fastapi/app/app/requirements.txt"     = { owner = "root", permissions = "0744", content = templatefile("../../scripts/init/fastapi/app/app/requirements.txt", {}) }
#   }
# }

# module "vm_cloud_init" {
#   source = "git::https://github.com/cpinotossi/cptdtfazmodules.git//cloud-config-gen"
#   files = merge(
#     local.vm_init_files,
#     local.vm_startup_init_files
#   )
#   packages = [
#     "docker.io", "docker-compose", #npm,
#   ]
#   run_commands = [
#     "bash ${local.init_dir}/init/startup.sh",
#     "docker-compose -f ${local.init_dir}/fastapi/docker-compose-app1-80.yml up -d",
#     "docker-compose -f ${local.init_dir}/fastapi/docker-compose-app2-8080.yml up -d",
#   ]
# }
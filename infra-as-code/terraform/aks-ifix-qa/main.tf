provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~>2.0"
  features {}
  subscription_id  = "71f67180-c7fb-43dd-988a-e9f9e3135adc"
  tenant_id        = "b36b0fbe-cea1-4178-8664-ba81a1e51765" 
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
}

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_group}"
  location = "${var.location}"
  tags = {
     environment = "${var.environment}"
  }
}

module "kubernetes" {
  source = "../modules/kubernetes/azure"
  environment = "${var.environment}"
  name = "${var.environment}"
  ssh_public_key = "~/.ssh/id_rsa.pub"
  location = "${azurerm_resource_group.resource_group.location}"
  resource_group = "${azurerm_resource_group.resource_group.name}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  nodes = "1"
  vm_size = "Standard_DS2_v2"
}

module "node-group" {  
  for_each = toset(["ifix", "mgramseva"])
  source = "../modules/node-pool/azure"
  node_group_name     = "${each.key}ng"
  cluster_id          = "${module.kubernetes.cluster_id}"
  vm_size             = "Standard_D4ds_v4"
  nodes          = 2
}

module "zookeeper" {
  source = "../modules/storage/azure"
  environment = "${var.environment}"
  itemCount = "3"
  disk_prefix = "zookeeper"
  location = "${azurerm_resource_group.resource_group.location}"
  resource_group = "${module.kubernetes.node_resource_group}"
  storage_sku = "Premium_LRS"
  disk_size_gb = "5"
  
}

module "kafka" {
  source = "../modules/storage/azure"
  environment = "${var.environment}"
  itemCount = "3"
  disk_prefix = "kafka"
  location = "${azurerm_resource_group.resource_group.location}"
  resource_group = "${module.kubernetes.node_resource_group}"
  storage_sku = "Standard_LRS"
  disk_size_gb = "100"
  
}
module "es-master" {
  source = "../modules/storage/azure"
  environment = "${var.environment}"
  itemCount = "3"
  disk_prefix = "es-master"
  location = "${azurerm_resource_group.resource_group.location}"
  resource_group = "${module.kubernetes.node_resource_group}"
  storage_sku = "Premium_LRS"
  disk_size_gb = "2"
  
}
module "es-data-v1" {
  source = "../modules/storage/azure"
  environment = "${var.environment}"
  itemCount = "3"
  disk_prefix = "es-data-v1"
  location = "${azurerm_resource_group.resource_group.location}"
  resource_group = "${module.kubernetes.node_resource_group}"
  storage_sku = "Premium_LRS"
  disk_size_gb = "100"
  
}

module "kafka-ifix" {
  source = "../modules/storage/azure"
  environment = "${var.environment}"
  itemCount = "3"
  disk_prefix = "kafka-ifix"
  location = "${azurerm_resource_group.resource_group.location}"
  resource_group = "${module.kubernetes.node_resource_group}"
  storage_sku = "Standard_LRS"
  disk_size_gb = "100"
  
}

module "zookeeper-ifix" {
  source = "../modules/storage/azure"
  environment = "${var.environment}"
  itemCount = "3"
  disk_prefix = "zookeeper-ifix"
  location = "${azurerm_resource_group.resource_group.location}"
  resource_group = "${module.kubernetes.node_resource_group}"
  storage_sku = "Premium_LRS"
  disk_size_gb = "5"
  
}

module "postgres-db" {
  source = "../modules/storage/azure"
  environment = "${var.environment}"
  itemCount = "2"
  disk_prefix = "postgres-db"
  location = "${azurerm_resource_group.resource_group.location}"
  resource_group = "${module.kubernetes.node_resource_group}"
  storage_sku = "Premium_LRS"
  disk_size_gb = "20"
  
}

resource "azurerm_kubernetes_cluster_node_pool" "ng" {
  name                  = "${var.node_group_name}"
  kubernetes_cluster_id = "${var.cluster_id}"
  vm_size               = "${var.vm_size}"
  node_count            = "${var.nodes}"
  node_taints           = ["dedicated=${var.node_group_name}:NoSchedule"]
 # priority        = "Spot"
 # eviction_policy = "Delete"
 # spot_max_price  = -1
  enable_auto_scaling = true
  min_count = 1
  max_count = 2


  node_labels = {
    lifecycle = "spot"
    Name = "${var.node_group_name}"
    Environment  = "${var.node_group_name}"
  }

  tags = {
     Environment = "${var.node_group_name}"
     Name = "${var.node_group_name}"
  }

}
locals {
  common_tags = "${map(
    "Group", "developer_host",
    "Admin", "${var.display_name} ${var.email_address}",
  )}"
}

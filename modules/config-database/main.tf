
resource "null_resource" "cloudantdb_build" {
  provisioner "local-exec" {
    working_dir = "${path.module}"
    command     = "/bin/bash ./deployCloudantDB.sh ${var.is_dr_provision} ${var.db_name} ${var.is_partitioned} ${var.pri_resource_host} ${var.pri_resource_username} ${var.pri_resource_password} ${var.pri_resource_apikey} ${var.dr_resource_host} ${var.dr_resource_username} ${var.dr_resource_password} ${var.dr_resource_apikey}"
    interpreter = ["/bin/bash", "-c"]
  }
}
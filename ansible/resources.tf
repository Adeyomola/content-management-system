resource "null_resource" "db" {
  provisioner "local-exec" {
    command = "ansible-playbook playbook.yml"
  }
}

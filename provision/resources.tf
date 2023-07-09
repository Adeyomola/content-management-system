resource "null_resource" "oidc_id" {
  provisioner "local-exec" {
    command     = "export TF_VAR_oidc_id=$(terraform output oidc_provider | cut -d '/' -f 3 | tr -d '\"')"
    interpreter = ["/bin/bash", "-c"]
  }
}

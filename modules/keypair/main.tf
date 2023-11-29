resource "tls_private_key" "generate_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name = "private_KP"
  public_key = tls_private_key.generate_private_key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
    echo '${tls_private_key.generate_private_key.private_key_pem}'> private_KP.em
    chmod 400 private_KP.em
    EOT
  }

  tags = {
    Name = "private_KP"
  }
}
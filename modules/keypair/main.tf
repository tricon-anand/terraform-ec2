resource "aws_key_pair" "generated_key_pair" {
  key_name = "demoKeyPair"
  public_key = tls_private_key.generate_private_key.public_key_openssh

  tags = {
    Name = "demoKeyPair"
  }
}

resource "tls_private_key" "generate_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "keyPairSSH" {
  content  = tls_private_key.generate_private_key.private_key_pem
  filename = "${path.module}/keyPairSSH"
}

output "aws_keypair" {
  value = aws_key_pair.generated_key_pair.key_name
}
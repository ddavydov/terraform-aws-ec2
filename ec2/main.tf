# Get Availability Zones
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate a Private Key and encode it as PEM.
resource "aws_key_pair" "key_pair" {
  key_name   = "key"
  public_key = tls_private_key.key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.key.private_key_pem}' > ./key.pem"
  }
}

# Create a EC2 Instance (Ubuntu 22)
resource "aws_instance" "node" {
  instance_type          = "t2.micro" # free instance
  ami                    = "ami-0149b2da6ceec4bb0"
  key_name               = aws_key_pair.key_pair.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnet

  tags = {
    Name = "node-0"
  }

  user_data_base64 = base64encode(templatefile("${path.module}/userdata.tftpl", var.userdata))
  user_data_replace_on_change = true
}

# Create and assosiate an Elastic IP
resource "aws_eip" "eip" {
  instance = aws_instance.node.id
}

provider "aws" {
   region = "ap-south-1"
   profile= "default"
 }

 
resource "aws_instance" "instance" {
     ami = "ami-01a4f99c4ac11b03c"
     instance_type = "t2.micro"
     vpc_security_group_ids = ["sg-0877b56aefc9b0f1e"]
     key_name = "feb"
     user_data = file("jen.sh")
     tags = {
       Name = "jenkins server"
     }
}
resource "null_resource" "name" {
     
     connection {
         type = "ssh"
         user = "ec2-user"
         private_key = "${file("C:/Users/user/Downloads/feb.pem")}"
         host = aws_instance.instance.public_ip
     }

     provisioner "file" {
          source = "jen.sh"
          destination = "/tmp/jen.sh"
     }     
     
     
     provisioner "remote-exec" {
         inline = [
          "sudo chmod +x /tmp/jen.sh",
          "sudo /tmp/jen.sh",
             
          ]
     }
     depends_on = [aws_instance.instance]
}

output "website_url" {
     value = join("",["http://",aws_instance.instance.public_dns,":","8080"])
}









     






 









    









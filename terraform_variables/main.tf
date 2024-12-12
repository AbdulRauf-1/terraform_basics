# resource "local_file" "devops" {
#   filename = "/home/rauf/Music/Personal Work/terraform/terraform_variables/devops.txt"
#   content = "This is the direct message"
# }

# resource "local_file" "devops_automated" {
#     filename = var.filename
#     content = var.content
# }

resource "local_file" "devops" {
  filename = var.file_list[0]
  content = var.content_map["content1"]
}

resource "local_file" "devops_automated" {
    filename = var.file_list[1]
    content = var.content_map["content2"]

}

# output "devops_command_line" {
#     value = var.devops_command_line
# }

output "aws_ec2_instance" {
  value = var.aws_ec2_object
  sensitive = true
}

output "prod_ec2" {
  value = var.image
}
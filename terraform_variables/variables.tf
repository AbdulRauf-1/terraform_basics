variable "filename" {
    default = "/home/rauf/Music/Personal Work/terraform/terraform_variables/devops_automated.txt"
}

variable "content" {
    default = "This is the automated message using variable file"
}

# export TF_VAR_devops_command_line="testing the export using command_line"
# variable "devops_command_line" {}

variable "content_map" {
    type = map
    default = {
        "content1"="content 1 from variable file"
        "content2"="content 2 from variable file"

    }
}

variable "file_list" {
    type = list
    default = ["/home/rauf/Music/Personal Work/terraform/terraform_variables/test1.txt","/home/rauf/Music/Personal Work/terraform/terraform_variables/test2.txt"]
}

variable "aws_ec2_object" {
    type = object({
      name = string
      instances= number
      keys=list(string)
      ami=string
    })
    default = {
      name = "test_ec2_instance"
      instances = 1
      keys = ["key1.pem","key2.pem"]
      ami="ubuntu-adf6"
    }
}

variable "image" {}
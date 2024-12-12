resource "aws_instance" "ec2_test" {
    ami = "ami-005fc0f236362e99f"
    instance_type = "t2.micro"
    tags = {
      Name = "test_instance"
    }
}
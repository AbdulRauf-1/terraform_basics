resource "local_file" "devops" {
    filename = "/home/rauf/Music/Personal Work/terraform/testing/test.txt"
    content = "Writing first terraform file"
}

resource "random_string" "rand_str" {
  length = 20
  special = true
}

output "rand_str" {
  value = random_string.rand_str[*].result
}
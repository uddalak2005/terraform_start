resource "local_file" "my_file" {
  filename        = "./my_file.txt"
  content         = "This is a text file created using terraform"
  file_permission = 0777
}

variable "server_port" {
  description = "The port the server will use for SSH"
  default     = "22"
}

variable "sshkey" {
  description = "sshkey"
}

variable "exoscale_api_key" { type = string }
variable "exoscale_api_secret" { type = string }
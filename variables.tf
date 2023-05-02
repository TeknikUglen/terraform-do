variable "do_api_token" {
  description = "API token for Digital Ocean"
  type        = string
  default     = ""
}

variable "do_vpc_uuid" {
  description = "VPC UUID for Digital Ocean"
  type        = string
  default     = ""
}

// 
variable "do_ssh_keys" {
	description = "SSH Key array"
  type        = list(string)
  default     = [""]
}
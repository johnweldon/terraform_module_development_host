variable "region" {
  description = "Region"
  default     = "us-east-1"
}

variable "amisize" {
  description = "Size of nodes"
  default     = "t3a.micro"
}

variable "email_address" {
  description = "Administrator Email Address"
}

variable "display_name" {
  description = "Administrator Display Name"
}

variable "key_name" {
  description = "AWS Name for Key Pair"
  default     = "development_key"
}

variable "public_key_path" {
  description = "Local path to public key"
}

variable "private_key_path" {
  description = "Local path to private key"
}

variable "ssh_config" {
  description = "Custom SSH config"
  default     = ""
}

variable "base_domain_name" {
  description = "Base domain name for DNS records"
}

variable "time_zone" {
  description = "Time Zone"
  default     = "America/Phoenix"
}


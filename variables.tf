variable "region" {
  description = "The location/region where the resource is created. Please review the Hosting Standard to select a approved location"
  default     = "us-east-1"
}

variable "prefix" {
  default = "Endava-VM"
}

variable "key" {
  default = "devops-endava-aws-key"
}


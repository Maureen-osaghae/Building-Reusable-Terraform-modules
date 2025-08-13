variable "aws_region" {
    type = string
    description = "Region to deploy our resources"
    default = "us-east-1"
  
}

variable "tagging" {
  type = map(string)
  default = {
    name         = "maureen-instance"
    BusinessUnit = "infosec"
  }
}
  

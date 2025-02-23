variable "subid" {
  description = "The subscription ID."
  type = any
  
}

variable "aksrgname" {
  description = "The resource group name of the AKS cluster."
  type = any
}

variable "aksclustername" {
  description = "The name of the AKS cluster."
  type = any
}

variable "Tags" {
  description = "BYO Tags, preferrable from a local on your side :D"
  type = map(string)
}


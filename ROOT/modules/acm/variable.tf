variable "domain_name" {
  description = "Domain name for the SSL certificate"
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional domain names"
  type        = list(string)
  default     = []
}
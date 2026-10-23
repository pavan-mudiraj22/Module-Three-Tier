output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.cert.arn
}

output "domain_validation_options" {
  description = "DNS records required to validate the certificate"
  value       = aws_acm_certificate.cert.domain_validation_options
}
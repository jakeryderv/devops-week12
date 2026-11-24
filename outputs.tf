output "portal_url" {
  description = "URL for the Week 12 status portal."
  value       = "http://localhost:${var.web_port}"
}

output "adminer_url" {
  description = "URL for the Adminer database interface."
  value       = "http://localhost:${var.adminer_port}"
}

Terraform AWS Cloudfront distribution
=====================================

Create a AWS Cloudfront distribution


Example:

```
module "cloufront" {
  source  = "Aplyca/cloudfront/aws"

  name    = "Cloudfront"
  origin = "origin.example.com"
  aliases = [
    "example.com",
    "*.example.com"
  ]

  custom_origin_config = [{
    http_port = 80
    https_port = 443
    origin_protocol_policy = "https-only"
    origin_ssl_protocols = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
    origin_read_timeout = 60
  }]

  forwarded_headers = ["Host"]
  tags {
    App = "My App"
    Environment = "Prod"
  }
  certificate = "${var.certificate_arn}"
}
```

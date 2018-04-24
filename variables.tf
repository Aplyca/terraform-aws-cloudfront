variable "name" {
  description = "Name prefix for all CloudFront resources."
  default     = "App"
}

variable "origin" {
  description = "Origin for CloudFront distribution"
  default     = ""
}

variable "aliases" {
  description = "A list of DNS aliases to associate with."
  type        = "list"
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "custom_origin_config" {
  description = "Custom origin config"
  default     = []
}

variable "s3_origin_config" {
  description = "S3 origin config"
  default     = []
}

variable "forwarded_headers" {
  description = "Forwarded headers"
  default     = []
}

variable "access_identity" {
  description = "Enalbe Cloudfront origin access identity creation"
  default = false
}

variable "certificate" {
  description = "ACM certificate arn"
  default = ""
}

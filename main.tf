locals {
  id = "${replace(var.name, " ", "-")}"
}

# ----------------------------------------
# CREATE A CLOUDFRONT DISTRIBUTION
# ----------------------------------------

# CloudFront distribution
resource "aws_cloudfront_distribution" "this" {
  count = "${var.access_identity ? 0 : 1}"
  origin {
    domain_name = "${var.origin}"
    origin_id   = "${local.id}"
    dynamic "custom_origin_config" {
      for_each = var.custom_origin_config.http_port != "" ? list(var.custom_origin_config) : []
      content {
        http_port   = var.custom_origin_config.http_port
        https_port   = var.custom_origin_config.https_port
        origin_protocol_policy = var.custom_origin_config.origin_protocol_policy
        origin_ssl_protocols = var.custom_origin_config.origin_ssl_protocols
      }
    }
  }

  enabled = true
  comment = "${var.name}"
  aliases = "${var.aliases}"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.id}"
    compress = true

    forwarded_values {
      query_string = true
      headers = ["${var.forwarded_headers}"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = "${var.min_ttl}"
    default_ttl            = "${var.default_ttl}"
    max_ttl                = "${var.max_ttl}"
  }

  tags = "${merge(var.tags, map("Name", "${var.name}"))}"

  viewer_certificate {
    acm_certificate_arn = "${var.certificate}"
    cloudfront_default_certificate = "${var.certificate == "" ? true : false}"
    ssl_support_method = "${var.certificate != "" ? "sni-only" : null}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_distribution" "access_identity" {
  count = "${var.access_identity ? 1 : 0}"
  origin {
    domain_name = "${var.origin}"
    origin_id   = "${local.id}"
    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${length(aws_cloudfront_origin_access_identity.this.*.id) > 0 ? element(concat(aws_cloudfront_origin_access_identity.this.*.id, list("")), 0) : ""}"
    }
  }

  enabled = true
  comment = "${var.name}"
  aliases = "${var.aliases}"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.id}"
    compress = true

    forwarded_values {
      query_string = true
      headers = "${var.forwarded_headers}"

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = "${var.min_ttl}"
    default_ttl            = "${var.default_ttl}"
    max_ttl                = "${var.max_ttl}"
  }

  tags = "${merge(var.tags, map("Name", "${var.name}"))}"

  viewer_certificate {
    acm_certificate_arn = "${var.certificate}"
    cloudfront_default_certificate = "${var.certificate == "" ? true : false}"
    ssl_support_method = "${var.certificate != "" ? "sni-only" : null}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "this" {
  count = "${var.access_identity ? 1 : 0}"
  comment = "${local.id}"
}

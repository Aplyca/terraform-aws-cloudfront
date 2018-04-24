output "distribution_domain" {
  value = "${length(aws_cloudfront_distribution.this.*.domain_name) > 0 ? element(concat(aws_cloudfront_distribution.this.*.domain_name, list("")), 0) : element(concat(aws_cloudfront_distribution.access_identity.*.domain_name, list("")), 0)}"
}

output "distribution_zone_id" {
  value = "${length(aws_cloudfront_distribution.this.*.hosted_zone_id) > 0 ? element(concat(aws_cloudfront_distribution.this.*.hosted_zone_id, list("")), 0) : element(concat(aws_cloudfront_distribution.access_identity.*.hosted_zone_id, list("")), 0)}"  
}

output "aliases" {
  value = "${var.aliases}"
}

output "access_identity_arn" {
  value = "${length(aws_cloudfront_origin_access_identity.this.*.iam_arn) > 0 ? element(concat(aws_cloudfront_origin_access_identity.this.*.iam_arn, list("")), 0) : ""}"
}


# // Athena
# variable "bucket" {}
# variable "create_database" {
#   type        = bool
#   default     = true
#   description = "A boolean that indicates if the new database should be created."
# }

# variable "database_name" {
#   type        = string
#   default     = null
#   description = "Name of the existing database. Required if create_database variable is false"
# }



# variable "database_force_destroy" {
#   type        = bool
#   default     = false
#   description = "A boolean that indicates all tables should be deleted from the database so that the database can be destroyed without error. The tables are not recoverable."
# }


# variable "query_output_locations" {
#   type        = map(string)
#   default     = {}
#   description = "A map of output locations (S3 URLs) for Athena queries. Keys are query names identical to the map above"
# }

# variable "query_output_buckets_kms_keys" {
#   type        = map(string)
#   default     = {}
#   description = "A map of KMS keys used to encrypt data in output S3 buckets for Athena queries. Keys are query names identical to the map above. Results will not be encrypted if the key for a query is not defined in the map."
# }

# variable "enforce_workgroup_configuration" {
#   type        = string
#   default     = true
#   description = "(Optional) Boolean whether the settings for the workgroup override client-side settings. "
# }
# variable "publish_cloudwatch_metrics_enabled" {
#   type        = string
#   default     = true
#   description = "(Optional) Boolean whether Amazon CloudWatch metrics are enabled for the workgroup. Defaults to true."
# }

variable "hostname" {
  type = string
}

variable "base_os_volume_id" {
  type        = string
  description = "The id of the volume from the base os."
}

variable "volume_size" {
  type        = number
  default     = 10
  description = "The size of the volume in GB (we multiple 1000000000 to get it in bytes)"
}

variable "memory" {
  type    = number
  default = 1024
}

variable "vcpus" {
  type    = number
  default = 2
}

variable "ipv4_address" {
  type        = string
  description = "The ipv4 address that needs to be configured for this guest"
}
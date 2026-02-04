variable "aws_region" {
  type        = string
  description = "AWS region to deploy the cluster into."
  default     = "us-east-1"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster."
  default     = "observability-eks"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.20.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet CIDR blocks."
  default     = ["10.20.0.0/24", "10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet CIDR blocks."
  default     = ["10.20.10.0/24", "10.20.11.0/24", "10.20.12.0/24"]
}

variable "node_instance_types" {
  type        = list(string)
  description = "Instance types for the managed node group."
  default     = ["t3.large"]
}

variable "node_desired_size" {
  type        = number
  description = "Desired node group size."
  default     = 3
}

variable "node_min_size" {
  type        = number
  description = "Minimum node group size."
  default     = 2
}

variable "node_max_size" {
  type        = number
  description = "Maximum node group size."
  default     = 6
}

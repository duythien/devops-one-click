
# VPC Module

The VPC module creates a VPC with public subnets across multiple availability zones. An Internet Gateway is attached to the VPC to allow access to the internet.

## Variables

- **`vpc_cidr`**: CIDR block for the VPC.
- **`az_count`**: The number of availability zones to use for the VPC (default: `2`).

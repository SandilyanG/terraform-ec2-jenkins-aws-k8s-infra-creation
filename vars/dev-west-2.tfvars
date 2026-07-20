# AWS region value block: sets the default region for provider operations.
aws_region = "us-west-2"

# VPC value block: supplies the existing VPC ID where the Jenkins security group will live.
vpc_id = "vpc-0045b4043c68c2917"

# CIDR block value: defines the network range referenced by the deployment variables.
cidr_block = "172.31.0.0/16"

# SSH key name block: selects the EC2 key pair used for instance login.
key_name = "asecguru"

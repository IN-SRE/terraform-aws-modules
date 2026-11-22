# RDS Module

Creates an RDS MySQL instance with a parameter group, option group, CloudWatch log groups, and monitoring role. It uses an existing DB subnet group and security group.

## Usage

```hcl
module "rdsdb" {
  source = "./modules/rds"

  identifier             = "webapp-dev-db"
  db_name                = "webappdb"
  username               = "dbadmin"
  password               = var.db_password
  db_subnet_group_name   = "dev-db-subnet-group"
  vpc_security_group_ids = ["sg-0123456789abcdef0"]
}
```

## Main Inputs

| Name | Description | Default |
|------|-------------|---------|
| identifier | DB instance name | required |
| db_name | Initial database name | required |
| username | Master username | required |
| password | Master password | required |
| db_subnet_group_name | Existing subnet group | required |
| vpc_security_group_ids | Security groups | required |
| instance_class | Instance size | `db.t3.micro` |
| allocated_storage | Storage in GiB | `20` |
| multi_az | Multi-AZ deployment | `false` |
| skip_final_snapshot | Skip snapshot on delete | `true` |
| deletion_protection | Block accidental delete | `false` |

## Outputs

| Name | Description |
|------|-------------|
| db_endpoint | Connection endpoint |
| db_address | Hostname |
| db_port | Port |

## Notes

- The password is write-only and is not stored in state. Change `password_version` to rotate it.
- For production, set `multi_az = true`, `deletion_protection = true`, and `skip_final_snapshot = false`.
- Requires AWS provider 5.87.0 or newer.
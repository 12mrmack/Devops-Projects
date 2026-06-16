# Assignment04 - Modular Terraform

VPC + ALB + Auto Scaling (OpenSearch / Dashboards) infrastructure on AWS,
refactored from a single `main.tf` into small single-responsibility modules.

## Structure

```
terraform/
├── main.tf            # root - composes all modules & wires outputs->inputs
├── variables.tf       # root input variables
├── outputs.tf         # root outputs
├── providers.tf       # AWS provider (region)
├── versions.tf        # terraform + provider version pins
├── backend.tf         # optional S3 remote state (commented)
├── terraform.tfvars   # variable values
└── modules/
    ├── vpc/           # VPC + Internet Gateway
    ├── subnets/       # public + private subnets
    ├── nat/           # Elastic IP + NAT gateway
    ├── routing/       # route tables + subnet associations
    ├── nacl/          # public + private network ACLs
    ├── security/      # alb-sg, bastion-sg, app-sg
    ├── alb/           # ALB, listeners, target groups
    ├── compute/       # bastion, launch template, ASG, userdata.sh
    └── s3/            # remote state bucket
```

## Network module dependency flow

```
vpc ──> subnets ──> nat ──┐
  │         │             ├──> routing
  │         └─────────────┘
  └──> nacl  (also consumes subnets)
```

- **vpc** exposes `vpc_id`, `vpc_cidr`, `igw_id`
- **subnets** consumes `vpc_id`; exposes `public_subnet_ids`, `private_subnet_ids`
- **nat** consumes `public_subnet_ids[0]`; exposes `nat_gateway_id`
  (root adds `depends_on = [module.vpc]` so the IGW exists first)
- **routing** consumes `vpc_id`, `igw_id`, `nat_gateway_id`, both subnet lists
- **nacl** consumes `vpc_id`, `vpc_cidr`, both subnet lists

## Usage

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

## Notes

- **userdata.sh** lives in `modules/compute/` and is a placeholder. Replace
  it with your real OpenSearch / Dashboards bootstrap script before applying.
- **Remote state**: the state bucket is created by this same config, so use
  the local backend for the first apply, then migrate (see `backend.tf`).
- The `app_tg` target group keeps `protocol = "HTTPS"` while its listener is
  `HTTP`, exactly as in the original file. Adjust if your OpenSearch nodes
  serve plain HTTP on 9200.

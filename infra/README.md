# d-soa-network.yaml (Core Networking)
- VPC với 3 tầng
- 6 subnets: 2 public, 2 private app, 2 private DB
- Internet Gateway, NAT Gateways
- Route Tables
- S3 Gateway Endpoint

# d-soa-security-groups.yaml (Network Security)
- Security Groups cho ALB: soa-sg-codeland-alb
- Security Groups cho ECS: soa-sg-codeland-ecs-task
- Security Groups cho RDS: soa-sg-codeland-db
- Security Groups cho Bastion: soa-sg-codeland-bastion

<!-- # DB thủ công
- soa-rds-codeland-db -->

# d-soa-parameter.yaml
- soa-param-codeland-secret-key
- soa-param-codeland-db-url

# d-soa-compute.yaml (ECS & Load Balancer)	
- ECS Cluster
- Application Load Balancer
- Target Groups
- ALB Listeners
- ECS Service
- ECS Task Definition
- ECS Execution Role

# Update giá trị trong parameter (value từ DB endpoint và secret manager)
- soa-param-codeland-db-secret-name
- soa-param-codeland-db-url

# d-soa-bastion.yaml
- Create key pair và tải về máy
    - soa-keypair-codeland-bastion
- Create Cfn stack

### Connect via Session Manager
Run lệnh bên dưới

```bash
sudo su -
su - ec2-user
```

### Connect DB
```bash
# test connect
./connect-db.sh

# Thoát db
\q
```

### Migration
```bash
cd /home/ec2-user/projects
git clone {your-backend-repo-url}
cd soa-project-backend
```

# Tạo thủ công: SOAGitHubActionsRole	
Identity providers
soaGitHubActionsRole

# Deploy app: online-learning-api	
- Github Action

# Create Certificate and Customize domain

# Deploy frontend (Amplify)	
- soa-project-frontend
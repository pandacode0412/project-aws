## Project AWS – Containerized App on AWS

### 1. Giới thiệu

Với vai trò **DevOps Engineer của CodeLand Technologies**, nhiệm vụ của dự án này là **chuyển ứng dụng từ môi trường local development sang môi trường production trên AWS Cloud**, bảo đảm tính sẵn sàng cao, bảo mật và khả năng mở rộng.

Hệ thống gồm tối thiểu:

- **Frontend**: React app (build thành static web)
- **Backend**: Flask API (production-ready config)
- **Database**: PostgreSQL
- **Hạ tầng**: AWS (ECS Fargate, RDS, ECR, VPC, ALB, Route53, ACM, …)

### 2. Overview Architecture Diagram

Sơ đồ kiến trúc tổng quan của hệ thống:

![Overview Architecture Diagram](./docs/overview-architecture-diagram.png)

> Gợi ý: Đặt file hình vào thư mục `docs/` với tên `overview-architecture-diagram.png` (hoặc đổi lại đường dẫn trong README cho đúng với repo của bạn).

### 3. Hệ thống hoạt động như thế nào?

Ở môi trường local, toàn bộ ứng dụng được **đóng gói bằng Docker**:

- Mỗi phần **Frontend** và **Backend** có một `Dockerfile` riêng.
- File `docker-compose.yml` dùng để chạy đồng thời frontend, backend và PostgreSQL trên máy của developer.
- Khi chạy `docker-compose up`, bạn sẽ có một môi trường tương tự production:
  - Frontend tại `http://localhost:3000`.
  - Backend API tại `http://localhost:5001`.
  - PostgreSQL chạy trong container riêng, dữ liệu được lưu persistent giữa các lần restart.

Trên **AWS**, hệ thống được triển khai theo kiến trúc chuẩn production:

- **Mạng (Network)**:
  - Một **VPC** riêng với kiến trúc 3 lớp: Public subnet, Private subnet cho ứng dụng, Private subnet cho database.
  - **Subnets** được triển khai trên nhiều AZ (Multi-AZ) để tăng độ sẵn sàng.
  - **Security Groups**, **NACLs** và **VPC Endpoints** giúp kiểm soát chặt chẽ luồng traffic vào/ra.
  - **Internet Gateway** và **NAT Gateway** cho phép các service cần thiết truy cập internet một cách an toàn.
- **Compute & Storage**:
  - Ứng dụng chạy trên **ECS Fargate**, giúp không phải quản lý server trực tiếp.
  - Frontend và Backend là các **Fargate Tasks** khác nhau, scale độc lập.
  - Database sử dụng **RDS PostgreSQL** với cấu hình Multi-AZ, backup và high availability.
  - Docker images được lưu trữ tại **ECR** (Elastic Container Registry).
- **Bảo mật & cấu hình**:
  - **Secrets Manager** lưu trữ thông tin nhạy cảm như database credentials.
  - **SSM Parameter Store** lưu các biến cấu hình (config) của ứng dụng.
  - Các **IAM Role** được thiết kế theo nguyên tắc **least privilege**, mỗi service chỉ có đúng quyền nó cần.

### 4. Triển khai & CI/CD

Việc build và deploy ứng dụng được tự động hóa bằng **GitHub Actions** (ví dụ workflow `_build_dev.yml`):

- Khi developer **push code** lên repository:
  - GitHub Actions chạy pipeline build.
  - Build Docker image cho Backend và tạo static build cho Frontend.
  - Push các Docker images lên **ECR** với tag phù hợp (ví dụ: `app-backend:${GITHUB_SHA}`). 
  - Cập nhật services trên **ECS Fargate** để sử dụng image mới.
- Pipeline có thể kèm thêm:
  - **Kiểm tra tự động** (lint, unit test, integration test).
  - **Smoke test / health check** sau khi deploy để đảm bảo dịch vụ chạy ổn định.

### 5. Tên miền & bảo mật (Domain & SSL)

Hệ thống sử dụng tên miền riêng và HTTPS để đảm bảo an toàn cho người dùng:

- **Route53** quản lý DNS cho domain (ví dụ: `api.codeland.tech`, `app.codeland.tech`).
- **AWS Certificate Manager (ACM)** cấp và quản lý chứng chỉ SSL/TLS.
- Người dùng truy cập qua **Application Load Balancer (ALB)**:
  - ALB nhận kết nối HTTPS, thực hiện **TLS termination**.
  - Sau đó ALB phân phối traffic về các ECS services (frontend/backend) theo rules định nghĩa sẵn.

### 6. Tech stack chính

- **Frontend**: React (containerized).
- **Backend**: Flask (Python) với production config.
- **Database**: PostgreSQL (local qua Docker, production qua AWS RDS).
- **Containerization**: Docker, Docker Compose, AWS ECS Fargate.
- **Registry**: AWS ECR.
- **Infra**: AWS VPC, Subnets, Security Groups, NAT/Internet Gateway, Route53, ACM, ALB.
- **CI/CD**: GitHub Actions.

### 7. Cách chạy local (tóm tắt)

- Cài đặt Docker & Docker Compose.
- Cấu hình file `.env` (nếu có) cho backend và database.
- Từ thư mục gốc:

```bash
docker-compose up --build
```

- Truy cập:
  - Frontend: `http://localhost:3000`
  - Backend API: `http://localhost:5001`

### 8. Ghi chú

- Các bước triển khai chi tiết (Terraform/CDK, cấu hình GitHub Actions, ECS, RDS, Route53, ACM, ALB, …) có thể được mô tả thêm trong thư mục `infra/` hoặc tài liệu bổ sung nếu cần.
- README này tập trung mô tả **kiến trúc tổng quan**, **cách hệ thống hoạt động** và **cách chạy ứng dụng** dựa trên overview architecture diagram.

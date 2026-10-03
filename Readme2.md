# E-Commerce Store – AWS Terraform & Docker Deployment

## 1. Project Overview

This project deploys a multi-service Node.js E-Commerce application using:

- AWS EC2
- AWS VPC
- Terraform
- Docker
- Docker Hub
- MongoDB
- Node.js
- React

### Application Services

| Service | Port |
|---|---:|
| Frontend | 3000 |
| User Service | 3001 |
| Product Service | 3002 |
| Cart Service | 3003 |
| Order Service | 3004 |
| MongoDB | 27017 |

---

# 2. Architecture

``` text
                         Internet
                            |
                            |
                    Public IP / EC2
                            |
                    +-------+-------+
                    |  AWS EC2      |
                    | Ubuntu 22.04  |
                    | Docker        |
                    +-------+-------+
                            |
                    ecommerce-net
                            |
        +-------------------+-------------------+
        |                   |                   |
   Frontend            Backend Services      MongoDB
   Port 3000                                  27017
        |
        +---------- User Service     3001
        |
        +---------- Product Service  3002
        |
        +---------- Cart Service     3003
        |
        +---------- Order Service    3004
```

# 4. Docker Images

The following five application services were containerized:

prassanaganesh/ecommerce-user
prassanaganesh/ecommerce-product
prassanaganesh/ecommerce-cart
prassanaganesh/ecommerce-order
prassanaganesh/ecommerce-frontend
Build Commands
docker build -t prassanaganesh/ecommerce-user:latest ./backend/user-service
<img width="1495" height="742" alt="image" src="https://github.com/user-attachments/assets/ffa3d0a6-29e2-49c8-a759-b63b8b8b7887" />

docker build -t prassanaganesh/ecommerce-product:latest ./backend/product-service
<img width="1457" height="527" alt="image" src="https://github.com/user-attachments/assets/428a15db-dae6-4cad-b9f0-5169373069d9" />

docker build -t prassanaganesh/ecommerce-cart:latest ./backend/cart-service
<img width="1472" height="531" alt="image" src="https://github.com/user-attachments/assets/5e479ba8-91c0-46ad-8a27-cc03b5901351" />

docker build -t prassanaganesh/ecommerce-order:latest ./backend/order-service
<img width="1462" height="527" alt="image" src="https://github.com/user-attachments/assets/8e63b6e5-7da0-4746-b023-c2f18ea56f8a" />

docker build -t prassanaganesh/ecommerce-frontend:latest ./frontend
<img width="1497" height="527" alt="image" src="https://github.com/user-attachments/assets/f2477462-3de4-405f-8838-70b6854558f2" />

Verify Images
docker images | grep ecommerce

<img width="1791" height="142" alt="image" src="https://github.com/user-attachments/assets/4c3f3f0c-e375-4c58-8036-091d7cdb8a2b" />

# 5. Local Docker Testing

Run the frontend locally:

docker run -d \
  --name ecommerce-frontend-test \
  -p 3000:3000 \
  prassanaganesh/ecommerce-frontend:latest

Check:

docker ps
<img width="1873" height="402" alt="docker ps -a" src="https://github.com/user-attachments/assets/64fcab20-268d-4fab-a041-cce22706bf60" />

Test:

curl http://localhost:3000

Check logs:

docker logs ecommerce-frontend-test

Remove test container:

docker rm -f ecommerce-frontend-test
# 6. Docker Hub

Login:

docker login
<img width="1111" height="192" alt="image" src="https://github.com/user-attachments/assets/a4e43436-6938-4636-9f54-a78130c03af9" />

Push the five images:

docker push prassanaganesh/ecommerce-user:latest

docker push prassanaganesh/ecommerce-product:latest

docker push prassanaganesh/ecommerce-cart:latest

docker push prassanaganesh/ecommerce-order:latest

docker push prassanaganesh/ecommerce-frontend:latest

Docker Hub:

https://hub.docker.com/u/prassanaganesh
<img width="1557" height="272" alt="image" src="https://github.com/user-attachments/assets/c11f5f4c-1c49-424e-9971-af8e8a18d27d" />

# 7. Terraform Infrastructure

Terraform provisions:

AWS VPC
Public subnet
Internet Gateway
Public route table
Security Group
Ubuntu EC2
Docker deployment using user-data
Terraform Commands
cd terraform

Initialize:

terraform init

Format:

terraform fmt

Validate:

terraform validate
<img width="1016" height="601" alt="image" src="https://github.com/user-attachments/assets/fa5358a4-6416-48fc-be69-a2075a6ddf40" />

Plan:

terraform plan -var="key_name=<ecommerce-assignment-key>"

Apply:

terraform apply -var="key_name=<ecommerce-assignment-key>"

<img width="1701" height="495" alt="image" src="https://github.com/user-attachments/assets/24eb32c9-acee-4c04-ae99-f34dd9ff620d" />

# 8. Terraform Outputs

After deployment:

terraform output

Expected outputs:

instance_id
public_ip
frontend_url
user_service_url
product_service_url
cart_service_url
order_service_url

Get frontend URL only:

terraform output -raw frontend_url

Get public IP:

terraform output -raw public_ip(IP kept changeing as i have done in differnt duration )

<img width="1001" height="212" alt="image" src="https://github.com/user-attachments/assets/f964acf3-c81d-4731-b652-bb0c9b951827" />

<img width="1396" height="517" alt="image" src="https://github.com/user-attachments/assets/2606b7e3-d2c8-4f64-a908-1e7f9e9117f8" />

9. AWS Infrastructure Verification

The Terraform deployment creates:

VPC
 |
 +-- Public Subnet
       |
       +-- Internet Gateway
       |
       +-- Route Table
       |
       +-- Security Group
       |
       +-- Ubuntu EC2
Security Group
Port	Purpose	Access
22	SSH	External
3000	Frontend	Public
3001	User Service	Internal
3002	Product Service	Internal
3003	Cart Service	Internal
3004	Order Service	Internal
27017	MongoDB	Internal

# 10. EC2 Verification

SSH into the server:

ssh -i ~/.ssh/ecommerce-assignment-key.pem ubuntu@44.213.124.13

Check Docker:

docker --version

Check running containers:

docker ps

Expected:

ecommerce-frontend
ecommerce-user
ecommerce-product
ecommerce-cart
ecommerce-order
ecommerce-mongo
# 11. Backend Verification

Test User Service:

<img width="1427" height="201" alt="image" src="https://github.com/user-attachments/assets/474b01a0-4a46-4b5e-bcd2-7cdedff76c90" />

curl http://localhost:3001/health
<img width="1172" height="576" alt="image" src="https://github.com/user-attachments/assets/f7ac88af-738b-43bb-9011-7f21676820b8" />

Test Product Service:

curl http://localhost:3002/health

Test Cart Service:

curl http://localhost:3003/health

Test Order Service:

curl http://localhost:3004/health
<img width="972" height="950" alt="image" src="https://github.com/user-attachments/assets/42ab6f8c-b6d1-4550-8f42-cff19d0fef1b" />

If the application uses a different health endpoint, verify the service using its available API endpoint.
<img width="1917" height="1010" alt="image" src="https://github.com/user-attachments/assets/1e14ee5e-7cad-4b9b-bb05-3de22a31795a" />

# 12. Docker Network Verification

List networks:

docker network ls

Inspect application network:

docker network inspect ecommerce-net

The application containers are connected through:

ecommerce-net

This allows the services to communicate using Docker container names.

# 13. Container Logs

Frontend:

docker logs ecommerce-frontend --tail 30

User:

docker logs ecommerce-user --tail 30

Product:

docker logs ecommerce-product --tail 30

Cart:

docker logs ecommerce-cart --tail 30

Order:

docker logs ecommerce-order --tail 30

MongoDB:

docker logs ecommerce-mongo --tail 30
# 14. Public Frontend Verification

Open the following URL in a browser:

http://<EC2_PUBLIC_IP>:3000

The e-commerce frontend should be accessible publicly.

This is the final deployment verification.

# 15. Review Screenshot Evidence

--------------------------------------------

The following screenshots are for reference

01 — Repository / Dockerfiles

Run:

find . -name Dockerfile -print
<img width="586" height="105" alt="image" src="https://github.com/user-attachments/assets/cf2c4398-b35d-4c6b-8ff3-99723a4c9482" />

|_ Demonstrates all five services have Dockerfiles.

Screenshot 02 — Docker Images

Run:

docker images | grep ecommerce

<img width="1207" height="112" alt="image" src="https://github.com/user-attachments/assets/eac9b6ad-4abb-46be-8710-b35c1772bcf4" />

Purpose: Demonstrates that all five Docker images were successfully built.

Screenshot 03 — Local Container Test

Run:

docker run -d \
  --name ecommerce-frontend-test \
  -p 3000:3000 \
  prassanaganesh/ecommerce-frontend:latest

docker ps

curl http://localhost:3000

Purpose: Demonstrates local Docker testing.

Screenshot 04 — Docker Hub

Open:

https://hub.docker.com/u/prassanaganesh

Show the five repositories:

ecommerce-user
ecommerce-product
ecommerce-cart
ecommerce-order
ecommerce-frontend
<img width="1405" height="105" alt="image" src="https://github.com/user-attachments/assets/201e25d0-de9e-4ebb-be0c-a05591a9f0c8" />

Purpose: Demonstrates Docker images were pushed to Docker Hub.

Screenshot 05 — Terraform Files


ls -lh terraform
<img width="847" height="177" alt="image" src="https://github.com/user-attachments/assets/d520be68-2144-442a-a08b-e9a29914521f" />

Purpose: Demonstrates Terraform infrastructure-as-code files.

Screenshot 06 — Terraform Validation

cd terraform
terraform validate
<img width="905" height="75" alt="image" src="https://github.com/user-attachments/assets/c7a95bc4-f0de-409c-b530-1fb327ae21e8" />

|_ Demonstrates valid Terraform configuration.

Screenshot 07 — Terraform Apply / Output

Run:

terraform output

Show:

<img width="707" height="140" alt="image" src="https://github.com/user-attachments/assets/6485d7de-480a-479c-a1a6-14c15632cf13" />

|_ Demonstrates successful AWS provisioning and application outputs.

Screenshot 08 — AWS EC2

AWS Console → EC2 → Instances.

<img width="1917" height="267" alt="image" src="https://github.com/user-attachments/assets/0946b57e-54ec-45bd-a52e-413b1a308372" />

Screenshot 09 — EC2 Docker Containers

SSH into EC2 and run:

docker ps

The screenshot should clearly show:

<img width="1873" height="402" alt="docker ps -a" src="https://github.com/user-attachments/assets/beed8a23-e2b8-4b94-a2e5-ab1d67351a9b" />

Purpose: Demonstrates successful Docker deployment on AWS.

Screenshot 10 — Backend Health Checks

Run:

curl http://localhost:3001/health
curl http://localhost:3002/health
curl http://localhost:3003/health
curl http://localhost:3004/health

<img width="1427" height="201" alt="image" src="https://github.com/user-attachments/assets/1b1a0ebe-f815-4722-98f4-134b16cf7f19" />

Purpose: Demonstrates that backend services are running.

Screenshot 11 — Docker Network

Run:

docker network inspect ecommerce-net

Purpose: Demonstrates internal Docker networking between services.

Screenshot 12 — Public Frontend

Open in browser:

http://44.213.124.13:3000

<img width="1917" height="1012" alt="image" src="https://github.com/user-attachments/assets/fd476d1f-5688-4a88-b0aa-64cfc852ab85" />

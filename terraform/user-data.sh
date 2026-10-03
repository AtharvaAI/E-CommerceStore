#!/bin/bash

set -eux

# Update packages
apt-get update -y

# Install Docker
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

# Wait for Docker
sleep 10

# Docker network
docker network create ecommerce-net || true

# Pull images
docker pull prassanaganesh/ecommerce-user:latest
docker pull prassanaganesh/ecommerce-product:latest
docker pull prassanaganesh/ecommerce-cart:latest
docker pull prassanaganesh/ecommerce-order:latest
docker pull prassanaganesh/ecommerce-frontend:latest

# MongoDB
docker pull mongo:7

# Start MongoDB
docker rm -f ecommerce-mongo || true

docker run -d \
  --name ecommerce-mongo \
  --network ecommerce-net \
  --restart unless-stopped \
  -p 27017:27017 \
  mongo:7

sleep 15

# User service
docker rm -f ecommerce-user || true

docker run -d \
  --name ecommerce-user \
  --network ecommerce-net \
  --restart unless-stopped \
  -p 3001:3001 \
  -e PORT=3001 \
  -e MONGODB_URI=mongodb://ecommerce-mongo:27017/ecommerce_users \
  -e JWT_SECRET=dev-secret-key \
  prassanaganesh/ecommerce-user:latest

# Product service
docker rm -f ecommerce-product || true

docker run -d \
  --name ecommerce-product \
  --network ecommerce-net \
  --restart unless-stopped \
  -p 3002:3002 \
  -e PORT=3002 \
  -e MONGODB_URI=mongodb://ecommerce-mongo:27017/ecommerce_products \
  prassanaganesh/ecommerce-product:latest

# Cart service
docker rm -f ecommerce-cart || true

docker run -d \
  --name ecommerce-cart \
  --network ecommerce-net \
  --restart unless-stopped \
  -p 3003:3003 \
  -e PORT=3003 \
  -e MONGODB_URI=mongodb://ecommerce-mongo:27017/ecommerce_carts \
  -e PRODUCT_SERVICE_URL=http://ecommerce-product:3002 \
  prassanaganesh/ecommerce-cart:latest

# Order service
docker rm -f ecommerce-order || true

docker run -d \
  --name ecommerce-order \
  --network ecommerce-net \
  --restart unless-stopped \
  -p 3004:3004 \
  -e PORT=3004 \
  -e MONGODB_URI=mongodb://ecommerce-mongo:27017/ecommerce_orders \
  -e CART_SERVICE_URL=http://ecommerce-cart:3003 \
  -e PRODUCT_SERVICE_URL=http://ecommerce-product:3002 \
  -e USER_SERVICE_URL=http://ecommerce-user:3001 \
  prassanaganesh/ecommerce-order:latest

# Frontend
docker rm -f ecommerce-frontend || true

docker run -d \
  --name ecommerce-frontend \
  --network ecommerce-net \
  --restart unless-stopped \
  -p 3000:3000 \
  -e HOST=0.0.0.0 \
  -e PORT=3000 \
  prassanaganesh/ecommerce-frontend:latest

echo "======================================"
echo "E-Commerce deployment completed"
echo "======================================"

docker ps

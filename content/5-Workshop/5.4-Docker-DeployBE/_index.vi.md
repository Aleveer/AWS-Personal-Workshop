---
title : "Build Docker Image và Deploy Backend"
weight : 4
chapter : false
pre : " <b> 5.4. </b> "
---

## Mục tiêu

- Build Docker image backend (NestJS) bằng Dockerfile viết sẵn.
- Push image lên ECR.
- Cập nhật ECS service dùng image mới.
- Kiểm tra health check và chức năng sau deploy.

## 1. Kiểm tra Dockerfile

- File: `backend/Dockerfile`
- Command start: `node dist/main.js`.

```Dockerfile
FROM node:20-alpine AS deps
WORKDIR /app

COPY package*.json ./
RUN npm ci --no-audit --no-fund

FROM node:20-alpine AS build
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY package*.json ./
COPY tsconfig*.json ./
COPY src ./src

RUN npm run build

FROM node:20-alpine AS prod
WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev --no-audit --no-fund

COPY --from=build /app/dist ./dist

ENV NODE_ENV=production
# Port Nest lắng nghe – ECS/ALB đang trỏ port 3000
ENV PORT=3000
EXPOSE 3000

# Start Nest app HTTP (main.ts)
CMD ["node", "dist/main.js"]
```

## 2. Đăng nhập ECR

```bash
aws ecr get-login-password --region ap-southeast-2 \
| docker login --username AWS --password-stdin 986446886396.dkr.ecr.ap-southeast-2.amazonaws.com
```

- Thay repository URI nếu khác account/region.

Terminal login ECR thành công:
![ecr-login](/images/5-Workshop/5.4-Docker-DeployBE/ecr-login.png)

## 3. Build image

```bash
docker build -t webchat-app-dev-backend .
```

- Thực thi tại thư mục `backend/`.

Output build thành công:

![docker-build](/images/5-Workshop/5.4-Docker-DeployBE/docker-build.png)

## 4. Tag image với ECR

```bash
docker tag webchat-app-dev-backend:latest \
  986446886396.dkr.ecr.ap-southeast-2.amazonaws.com/webchat-app-dev-backend:latest
```

## 5. Push image lên ECR

```bash
docker push 986446886396.dkr.ecr.ap-southeast-2.amazonaws.com/webchat-app-dev-backend:latest
```

- Kiểm tra trên ECR repository: image mới và digest mới.

ECR repository với tag/digest mới:

![ecr-repo](/images/5-Workshop/5.4-Docker-DeployBE/ecr-repo.png)

## 6. Kiểm tra sau deploy

- Kiểm tra API nhanh qua `/api/auth/login`:
  ![api-test](/images/5-Workshop/5.4-Docker-DeployBE/api-login-test.png)

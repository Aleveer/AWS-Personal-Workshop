---
title : "Build Docker Image and Deploy Backend"
weight : 4
chapter : false
pre : " <b> 5.4. </b> "
---

## Objectives

- Build Docker image for backend (NestJS) using the provided Dockerfile.
- Push image to ECR.
- Update ECS service to use the new image.
- Verify health check and functionality after deployment.

## 1. Check Dockerfile

- File: `backend/Dockerfile`
- Start command: `node dist/main.js`.

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
# Port Nest listens on – ECS/ALB is pointing to port 3000
ENV PORT=3000
EXPOSE 3000

# Start Nest app HTTP (main.ts)
CMD ["node", "dist/main.js"]
```

## 2. Login to ECR

```bash
aws ecr get-login-password --region ap-southeast-2 \
| docker login --username AWS --password-stdin 986446886396.dkr.ecr.ap-southeast-2.amazonaws.com
```

- Replace repository URI if different account/region.

Terminal login to ECR successful:
![ecr-login](/images/5-Workshop/5.4-Docker-DeployBE/ecr-login.png)

## 3. Build image

```bash
docker build -t webchat-app-dev-backend .
```

- Execute in the `backend/` directory.

Output build successful:

![docker-build](/images/5-Workshop/5.4-Docker-DeployBE/docker-build.png)

## 4. Tag image with ECR

```bash
docker tag webchat-app-dev-backend:latest \
  986446886396.dkr.ecr.ap-southeast-2.amazonaws.com/webchat-app-dev-backend:latest
```

## 5. Push image to ECR

```bash
docker push 986446886396.dkr.ecr.ap-southeast-2.amazonaws.com/webchat-app-dev-backend:latest
```

- Check on ECR repository: new image and new digest.

ECR repository with new tag/digest:

![ecr-repo](/images/5-Workshop/5.4-Docker-DeployBE/ecr-repo.png)

## 6. Verify after deployment

- Quick API check via `/api/auth/login`:
  ![api-test](/images/5-Workshop/5.4-Docker-DeployBE/api-login-test.png)

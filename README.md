# 🚀 MEAN Stack CRUD Application — Dockerized Deployment

> **Full-stack Tutorial Management System** built with MongoDB, Express.js, Angular 15, and Node.js — containerized with Docker, orchestrated with Docker Compose, and deployed via GitHub Actions CI/CD.

---

## 📐 Architecture

```
                    ┌──────────────────────────────────────────┐
                    │              Ubuntu VM / Host             │
                    │                                          │
   Internet ──────►│  ┌──────────────────────────────────┐    │
                    │  │     Nginx Reverse Proxy (:80)    │    │
                    │  │                                  │    │
                    │  │   /       ──► Frontend (:80)     │    │
                    │  │   /api    ──► Backend  (:8080)   │    │
                    │  └──────────────────────────────────┘    │
                    │          │                  │             │
                    │   ┌──────┴─────┐   ┌───────┴────────┐   │
                    │   │  Angular   │   │ Express API    │   │
                    │   │  (nginx)   │   │ (Node.js)      │   │
                    │   └────────────┘   └───────┬────────┘   │
                    │                            │             │
                    │                    ┌───────┴────────┐   │
                    │                    │   MongoDB      │   │
                    │                    │   (mongo:6)    │   │
                    │                    └────────────────┘   │
                    └──────────────────────────────────────────┘
```

### Services

| Service | Technology | Port | Description |
|---------|-----------|------|-------------|
| **Nginx** | nginx:alpine | 80 | Reverse proxy — entry point |
| **Frontend** | Angular 15 + nginx:alpine | 80 (internal) | Single-page application |
| **Backend** | Node.js 18 + Express | 8080 | REST API server |
| **MongoDB** | mongo:6 | 27017 | NoSQL database |

---

## 📁 Project Structure

```
crud-dd-task-mean-app/
├── backend/
│   ├── app/
│   │   ├── config/db.config.js
│   │   ├── controllers/tutorial.controller.js
│   │   ├── models/
│   │   └── routes/turorial.routes.js
│   ├── server.js
│   ├── package.json
│   ├── Dockerfile
│   └── .dockerignore
├── frontend/
│   ├── src/
│   ├── angular.json
│   ├── package.json
│   ├── Dockerfile
│   ├── nginx.conf
│   └── .dockerignore
├── nginx/
│   └── nginx.conf
├── scripts/
│   ├── setup.sh
│   └── deploy.sh
├── .github/
│   └── workflows/
│       └── deploy.yml
├── docker-compose.yml
└── README.md
```

---

## 🛠️ Prerequisites

- **Docker** (v20.10+)
- **Docker Compose** (v2.0+)
- **Git**

---

## 🚀 Quick Start (Local Development)

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/crud-dd-task-mean-app.git
cd crud-dd-task-mean-app
```

### 2. Build and Run with Docker Compose

```bash
# Build all images
docker compose build

# Start all services
docker compose up -d
```

### 3. Access the Application

| URL | Service |
|-----|---------|
| `http://localhost` | Application (via Nginx) |
| `http://localhost:4200` | Frontend (direct) |
| `http://localhost:8080/api/tutorials` | Backend API (direct) |
| `http://localhost:27017` | MongoDB |

### 4. Stop the Application

```bash
docker compose down
```

---

## 🐳 Docker Build Instructions

### Build Individual Images

```bash
# Build backend image
docker build -t mean-backend:latest ./backend

# Build frontend image
docker build -t mean-frontend:latest ./frontend
```

### Docker Hub Push Instructions

```bash
# Login to Docker Hub
docker login

# Tag images
docker tag mean-backend:latest <your-dockerhub-username>/mean-backend:latest
docker tag mean-frontend:latest <your-dockerhub-username>/mean-frontend:latest

# Push images
docker push <your-dockerhub-username>/mean-backend:latest
docker push <your-dockerhub-username>/mean-frontend:latest
```

---

## ☁️ Ubuntu VM Deployment

### 1. Initial Server Setup

SSH into your Ubuntu VM and run the setup script:

```bash
# Clone the repository
git clone https://github.com/<your-username>/crud-dd-task-mean-app.git
cd crud-dd-task-mean-app

# Make scripts executable
chmod +x scripts/setup.sh scripts/deploy.sh

# Run setup (installs Docker, Docker Compose, Nginx, Git)
./scripts/setup.sh

# Log out and back in for Docker group changes
exit
```

### 2. Deploy the Application

```bash
cd crud-dd-task-mean-app
./scripts/deploy.sh
```

### 3. Verify Deployment

```bash
# Check running containers
docker compose ps

# Check logs
docker compose logs -f

# Test API endpoint
curl http://localhost/api/tutorials
```

---

## ⚙️ GitHub Actions CI/CD Pipeline

The pipeline (`.github/workflows/deploy.yml`) automatically builds, pushes, and deploys on every push to `main`.

### Pipeline Flow

```
Push to main → Checkout → Docker Login → Build Images → Push to Hub → SSH Deploy
```

### Required GitHub Secrets

Navigate to **Settings → Secrets and Variables → Actions** in your GitHub repository and add:

| Secret | Description | Example |
|--------|-------------|---------|
| `DOCKER_USERNAME` | Docker Hub username | `johndoe` |
| `DOCKER_PASSWORD` | Docker Hub password or access token | `dckr_pat_xxx` |
| `VM_HOST` | Ubuntu VM IP address | `203.0.113.50` |
| `VM_USERNAME` | SSH username on the VM | `ubuntu` |
| `VM_SSH_KEY` | Private SSH key for VM access | Contents of `~/.ssh/id_rsa` |

### Setting Up SSH Key Authentication

```bash
# On your local machine - generate SSH key pair
ssh-keygen -t rsa -b 4096 -C "github-actions-deploy"

# Copy public key to the VM
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@<VM_IP>

# Copy private key content — paste this as VM_SSH_KEY secret
cat ~/.ssh/id_rsa
```

---

## 🌐 Nginx Reverse Proxy

The Nginx reverse proxy (`nginx/nginx.conf`) acts as the single entry point:

| Route | Destination | Purpose |
|-------|-------------|---------|
| `/` | `frontend:80` | Serves Angular SPA |
| `/api/*` | `backend:8080` | Proxies API requests |

**Features:**
- Gzip compression for performance
- Security headers (X-Frame-Options, X-Content-Type-Options, X-XSS-Protection)
- WebSocket support via `Upgrade` headers
- Upstream health monitoring
- Connection pooling

---

## 🧪 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tutorials` | Get all tutorials |
| GET | `/api/tutorials/:id` | Get tutorial by ID |
| POST | `/api/tutorials` | Create a tutorial |
| PUT | `/api/tutorials/:id` | Update a tutorial |
| DELETE | `/api/tutorials/:id` | Delete a tutorial |
| DELETE | `/api/tutorials` | Delete all tutorials |
| GET | `/api/tutorials?title=` | Search by title |

---

## 📸 Screenshots

> *Replace these placeholders with actual screenshots of your deployment*

| Screenshot | Description |
|-----------|-------------|
| ![Application Home]("C:\Users\91986\OneDrive\Pictures\Screenshots\Screenshot 2026-02-24 202117.png") | Application home page |
| ![Docker Containers]("C:\Users\91986\OneDrive\Pictures\Screenshots\Screenshot 2026-02-24 202203.png") | Running Docker containers |
| ![Docker Hub]("C:\Users\91986\OneDrive\Pictures\Screenshots\Screenshot 2026-02-24 201819.png") | Images on Docker Hub |
| ![Docker Hub]("C:\Users\91986\OneDrive\Pictures\Screenshots\Screenshot 2026-02-24 201842.png") | Images on Docker Hub |
| ![GitHub Actions]("C:\Users\91986\OneDrive\Pictures\Screenshots\Screenshot 2026-02-24 201636.png") | CI/CD pipeline run |
| ![GitHub Actions]("C:\Users\91986\OneDrive\Pictures\Screenshots\Screenshot 2026-02-24 201551.png") | CI/CD pipeline run |
| ![VM Deployment]("C:\Users\91986\OneDrive\Pictures\Screenshots\Screenshot 2026-02-24 201912.png") | Live deployment on Ubuntu VM |

---

## 🔧 Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MONGODB_URI` | `mongodb://localhost:27017/dd_db` | MongoDB connection string |
| `PORT` | `8080` | Backend server port |
| `NODE_ENV` | `production` | Node.js environment |

---

## 📄 License

ISC

---

<p align="center">
  <b>Built for DevOps Internship — Discover Dollar</b><br>
  MongoDB · Express · Angular · Node.js · Docker · Nginx · GitHub Actions
</p>

# DevOps FastAPI CI/CD Project

This is a production-style DevOps project built using:

- **FastAPI** (Python)
- **Docker & Docker Compose**
- **GitHub Actions (CI/CD)**
- **Docker Hub**
- **AWS EC2 Deployment**
- **Prometheus + Grafana Monitoring**

## 📌 Features
- FastAPI microservice with `/health`, `/metrics`, `/items`.
- Multi-stage Dockerfile for small production images.
- GitHub Actions pipeline:
  - Run tests
  - Build Docker image
  - Push to Docker Hub
  - Deploy to EC2 via SSH
- Monitoring with Prometheus & Grafana.
- Infrastructure code (Terraform skeleton included).

## 📁 Project Structure
<!-- update -->
# Trigger CI
     

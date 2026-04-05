# 🌐 GCP Smart IoT Analytics Platform

An end-to-end IoT data engineering and analytics platform built on **Google Cloud Platform (GCP)**. This project demonstrates a scalable architecture for ingesting, processing, and analyzing real-time IoT sensor data using modern DevOps and DataOps practices.

---

## 🚀 Overview

This platform is designed to handle high-velocity data streams from IoT devices. It leverages GCP's managed services to provide a resilient pipeline from ingestion to predictive analytics.

### Key Features:
* **Infrastructure as Code (IaC):** Full environment provisioning using **Terraform**.
* **Container Orchestration:** Managed services deployed on **Google Kubernetes Engine (GKE)**.
* **Automated CI/CD:** Streamlined deployments via **Cloud Build**.
* **AI/ML Integration:** Predictive sensor analytics using **Vertex AI** and Jupyter Notebooks.
* **Serverless Logic:** Event-driven data processing with **Cloud Functions**.

---

## 🏗️ Architecture

The project follows a modern cloud-native architecture:
1.  **Ingestion:** IoT data is received via Pub/Sub (simulated or real devices).
2.  **Processing:** Cloud Functions and GKE-hosted microservices handle data transformation.
3.  **Storage:** Processed data is stored in BigQuery for analytical querying.
4.  **Analytics:** Vertex AI models provide insights and predictions on sensor health and trends.
5.  **Visualization:** Dashboards for real-time monitoring.

---

## 📂 Project Structure

```text
├── Terraform/             # IaC for VPC, GKE, Vertex AI, and Storage
├── cloud_build/           # CI/CD pipeline configurations
├── functions/             # Serverless Cloud Functions (Python)
├── notebooks/             # Data analysis & ML model development
├── dashboards/            # Visualization assets
└── scripts/               # Helper scripts for deployment and testing
```

---

## 🛠️ Tech Stack

* **Cloud:** Google Cloud Platform (GCP)
* **IaC:** Terraform
* **Orchestration:** Kubernetes (GKE), Docker
* **Data/AI:** BigQuery, Vertex AI, Jupyter
* **CI/CD:** Cloud Build, GitHub Actions
* **Languages:** HCL, Python

---

## 🚦 Getting Started

### Prerequisites
* GCP Project with billing enabled.
* Google Cloud SDK installed and authenticated.
* Terraform installed locally.

### Deployment
1. **Clone the repo:**
   ```bash
   git clone [https://github.com/Brian432-cpu/GCP-SMART-IOT-ANALYTICS-PLATFORM.git](https://github.com/Brian432-cpu/GCP-SMART-IOT-ANALYTICS-PLATFORM.git)
   cd GCP-SMART-IOT-ANALYTICS-PLATFORM/Terraform
   ```
2. **Initialize and Apply Infrastructure:**
   ```bash
   terraform init
   terraform apply
   ```

---

## 📝 License
This project is licensed under the MIT License - see the LICENSE file for details.
```

# 1. Enable Required APIs for AI/ML
resource "google_project_service" "vertex_ai_api" {
  project = var.project_id
  service = "aiplatform.googleapis.com"

  # Prevent accidental disabling of the API which could destroy models
  disable_on_destroy = false
}

# 2. Vertex AI Dataset (Tabular for IoT Telemetry)
# This acts as the managed container for the data used to train your models
resource "google_vertex_ai_dataset" "iot_sensor_dataset" {
  display_name        = "iot_telemetry_training_set"
  location            = var.region
  region              = var.region
  metadata_schema_uri = "gs://google-cloud-aiplatform/schema/dataset/metadata/tabular_1.0.0.yaml"

  depends_on = [google_project_service.vertex_ai_api]
}

# 3. Vertex AI Endpoint
# This is the REST URL where your sensor_prediction models will be deployed
resource "google_vertex_ai_endpoint" "sensor_prediction_endpoint" {
  name         = "sensor-prediction-endpoint"
  display_name = "Sensor Prediction Service"
  location     = var.region
  region       = var.region

  labels = {
    env  = "production"
    team = "devops-iot"
  }

  depends_on = [google_project_service.vertex_ai_api]
}

# 4. IAM Permissions for Vertex AI
# Allow the Cloud Function Service Account to predict using the endpoint
resource "google_project_iam_member" "vertex_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.function_sa.email}"
}
provider "google" {
  project = "idme-assessment-section3"
  region  = "us-east4"
}

// GCS BUCKET

resource "google_storage_bucket" "data_bucket" {
  name                        = "gcs-bucket-idme-femi-assessment"
  location                    = "US"
  storage_class               = "STANDARD"
  force_destroy               = true
  uniform_bucket_level_access = true
  public_access_prevention = "enforced" // deny bucket public access
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }

  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type = "Delete"
    }
  }
}

// PUBSUB TOPIC & SUBSCRIPTION

resource "google_pubsub_topic" "my_topic" {
  name = "pubsub-topic"
}

resource "google_pubsub_subscription" "my_subscription" {
  name  = "pubsub-subscription"
  topic = google_pubsub_topic.my_topic.name

  ack_deadline_seconds = 10

  message_retention_duration = "86400s" # 24 hours
}

// SERVICE ACCOUNTS

// Writer Service Account
resource "google_service_account" "writer_sa" {
  account_id   = "writer-sa"
  display_name = "Service Account with write access to GCS and PubSub"
}

// Reader Service Account
resource "google_service_account" "reader_sa" {
  account_id   = "reader-sa"
  display_name = "Service Account with read access to GCS and PubSub Subscription"
}

// IAM Bindings

// Writer SA Permissions
resource "google_project_iam_member" "writer_sa_pubsub_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.writer_sa.email}"
}

resource "google_storage_bucket_iam_member" "writer_sa_gcs_writer" {
  bucket = google_storage_bucket.data_bucket.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.writer_sa.email}"
}

// Reader SA Permissions
resource "google_project_iam_member" "reader_sa_pubsub_subscriber" {
  project = var.project_id
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.reader_sa.email}"
}

resource "google_storage_bucket_iam_member" "reader_sa_gcs_reader" {
  bucket = google_storage_bucket.data_bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.reader_sa.email}"
}

// Variables (optional - cleaner code)
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "idme-assessment-section3"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-east4"
}
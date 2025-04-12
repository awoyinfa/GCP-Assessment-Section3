# GCP-Assessment-Section3
# GCP Infrastructure Deployment with Terraform

This Terraform configuration provisions the following GCP resources:

- **GCS Bucket**
    - Public access disabled.
    - Standard storage with a retention policy:
    - After 90 days, objects are transitioned to Archive storage.
    - After 365 days, objects are automatically deleted.
   
- **Google Pub/Sub**
    - A Pub/Sub topic with a single subscription.
    - Subscription retains messages for up to 24 hours.

- **Service Accounts**
  - **Writer Service Account**
    - Write access to the GCS bucket.
    - Publish access to the Pub/Sub topic.
  - **Reader Service Account**
    - Read access to the GCS bucket.
    - Subscriber access to the Pub/Sub subscription.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/infrastructure-as-code) v6.29.0 
- A GCP Project
- [gcloud CLI](https://cloud.google.com/sdk/docs/install) installed and authenticated
- Billing enabled on your GCP account
- Required API services enabled:
  - Cloud Storage (`storage.googleapis.com`)
  - Cloud Pub/Sub (`pubsub.googleapis.com`)
  - IAM Service Account (`iam.googleapis.com`)

## Setup

1. **Clone the repository**

    gitbash
   
    git clone https://github.com/awoyinfa/GCP-Assessment-Section3.git
   
    cd GCP-Assessment-Section3

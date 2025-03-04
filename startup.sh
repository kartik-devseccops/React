 #!/bin/bash

echo "Fetching environment variables from GCP Secret Manager"

GCP_PROJECT="my-react-project-12345"
SERVICE_NAME="your-service-name"

for secret in $(gcloud secrets list --project=$GCP_PROJECT --format="value(name)"); do
  VALUE=$(gcloud secrets versions access latest --secret=$secret --project=$GCP_PROJECT)
  echo "$secret=$VALUE" >> .env
done

echo "Starting application..."
python manage.py runserver 0.0.0.0:8080

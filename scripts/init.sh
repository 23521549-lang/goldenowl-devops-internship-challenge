#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="$SCRIPT_DIR/../terraform"

log() { echo "[$(date '+%H:%M:%S')] $1"; }
fail() { echo "[ERROR] $1" >&2; exit 1; }

cd "$TF_DIR" || fail "terraform directory not found at $TF_DIR"

BUCKET_NAME=$(grep -A3 'backend "s3"' backend.tf backend.tf.disabled 2>/dev/null | grep 'bucket' | head -1 | grep -oP '"\K[^"]+' | head -1)
if [ -z "$BUCKET_NAME" ]; then
  fail "could not determine backend bucket name from backend.tf or backend.tf.disabled"
fi

log "Checking if backend bucket $BUCKET_NAME exists..."
if aws s3api head-bucket --bucket "$BUCKET_NAME" >/dev/null 2>&1; then
  log "Bucket exists. Ensuring backend.tf is active..."
  if [ -f backend.tf.disabled ]; then
    mv backend.tf.disabled backend.tf
  fi
  rm -rf .terraform
  terraform init -input=false -reconfigure || fail "terraform init failed"
else
  log "Bucket does not exist. Running bootstrap from local backend..."
  if [ -f backend.tf ]; then
    mv backend.tf backend.tf.disabled
  fi
  rm -rf .terraform terraform.tfstate terraform.tfstate.backup
  terraform init -input=false -lock=false || fail "terraform init failed"

  log "Creating S3 bucket and DynamoDB table..."
  terraform apply -target=module.bootstrap -auto-approve -input=false -lock=false || fail "bootstrap failed"

  log "Switching backend to S3..."
  mv backend.tf.disabled backend.tf || fail "backend.tf.disabled not found after bootstrap"

  log "Migrating state to S3..."
  terraform init -migrate-state -force-copy -input=false || fail "state migration failed"
fi

log "Planning infrastructure changes..."
terraform plan -out=tfplan || fail "terraform plan failed"

log "Applying plan..."
terraform apply tfplan

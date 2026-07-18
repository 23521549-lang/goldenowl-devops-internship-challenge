#!/bin/bash
set -e

log() { echo "[$(date '+%H:%M:%S')] $1"; }
fail() { echo "[ERROR] $1" >&2; exit 1; }

log "Initializing Terraform (local backend)..."
terraform init -input=false || fail "terraform init failed"

log "Creating S3 bucket and DynamoDB table..."
terraform apply -target=module.bootstrap -auto-approve -input=false || fail "bootstrap failed"

log "Switching backend to S3..."
mv backend.tf.disabled backend.tf || fail "backend.tf.disabled not found"

log "Migrating state to S3..."
terraform init -migrate-state -force-copy -input=false || fail "state migration failed"

log "Bootstrap complete. Deploying infrastructure..."
terraform apply

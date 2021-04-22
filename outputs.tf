output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "connect_to_cluster" {
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone ${var.zone} --project ${var.project_id}"
  description = "connection cli"
}

locals {
  httpapp_enabled_auto_deployments = true
  httpapp_image_version            = "v0.1.0"
  httpapp_port                     = 80

  httpapp_cpu    = 1024
  httpapp_memory = 2048

  httpapp_max_concurrency = 100
  httpapp_max_size        = 2
  httpapp_min_size        = 1
}

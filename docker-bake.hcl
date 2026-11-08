variable "IMAGE" {
  default = "ghcr.io/specsnl/utils"
}

target "docker-metadata-action" {
  tags = ["${IMAGE}:latest"]
}

group "default" {
  targets = ["utils"]
}

target "utils" {
  inherits   = ["docker-metadata-action"]
  context    = "."
  dockerfile = "Dockerfile"
}

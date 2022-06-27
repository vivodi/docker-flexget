target "docker-metadata-action" {}

target "linux-amd64" {
  inherits = ["docker-metadata-action"]
  context = "./"
  dockerfile = "Dockerfile"
  platforms = [
    "linux/amd64"
  ]
}

target "linux-arm64" {
  inherits = ["docker-metadata-action"]
  context = "./"
  dockerfile = "Dockerfile.aarch64"
  platforms = [
    "linux/arm64"
  ]
}
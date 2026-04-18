packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "yandex" "debian_docker" {
  disk_type           = "network-hdd"
  folder_id           = "b1gn............"
  image_description   = "my custom debian with docker"
  image_name          = "debian-11-docker"
  source_image_family = "debian-11"
  ssh_username        = "debian"
  subnet_id           = "e2lh9u2ch3tfk8fibvpk"
  token               = "y0__xD........................."
  use_ipv4_nat        = true
  zone                = "ru-central1-b"
}


build {
  sources = ["source.yandex.debian_docker"]

 provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install ca-certificates curl",
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc",
      "sudo chmod a+r /etc/apt/keyrings/docker.asc",
      "sudo tee /etc/apt/sources.list.d/docker.sources",
      "sudo apt update",
      "sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "sudo apt install -y htop",
      "sudo apt install -y tmux"
    ]
  }
}


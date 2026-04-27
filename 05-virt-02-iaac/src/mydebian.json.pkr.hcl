
source "yandex" "debian_docker" {
  disk_type           = "network-hdd"
  folder_id           = "b1g........................."
  image_description   = "my custom debian with docker"
  image_name          = "debian-11-docker"
  source_image_family = "debian-11"
  ssh_username        = "debian"
  subnet_id           = "e2lh9u2ch3tfk8fibvpk"
  token               = "y0__xD............................."
  use_ipv4_nat        = true
  zone                = "ru-central1-b"
}


build {
  sources = ["source.yandex.debian_docker"]

 provisioner "shell" {
    inline = [ <<EOF
        # Add Docker's official GPG key:
        sudo apt update,
        sudo apt install ca-certificates curl,
        sudo install -m 0755 -d /etc/apt/keyrings,
        sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc,
        #curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        #sudo chmod a+r /etc/apt/keyrings/docker.gpg,
        sudo chmod a+r /etc/apt/keyrings/docker.asc,

        # Add the repository to Apt sources:
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null
        
        sudo apt update,
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin,
        sudo apt install -y htop,
        sudo apt install -y tmux,
        EOF
    ]
  }
}


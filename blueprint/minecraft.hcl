network "local" {
  subnet = "10.10.0.0/16"
}

container "minecraft" {

  network {
    name = "network.local"
  }

  image {
    name = "hashicraft/minecraft:v1.19.2-fabric"
  }

  volume {
    source      = "./mc_server/mods"
    destination = "/minecraft/mods"
  }

  volume {
    source      = "./mc_server/plugins"
    destination = "/minecraft/plugins"
  }

  volume {
    source      = "./mc_server/world"
    destination = "/minecraft/world"
  }

  volume {
    source      = "./mc_server/worlds"
    destination = "/minecraft/worlds"
  }

  volume {
    source      = "./mc_server/config"
    destination = "/minecraft/config"
  }

  port {
    local  = 25565
    remote = 25565
    host   = 25565
  }

  port {
    local  = 27015
    remote = 27015
    host   = 27015
  }

  env {
    key   = "JAVA_MEMORY"
    value = "8G"
  }

  env {
    key   = "MINECRAFT_MOTD"
    value = "HashiCraft"
  }

  env {
    key   = "WHITELIST_ENABLED"
    value = "false"
  }

  env {
    key   = "RCON_PASSWORD"
    value = "password"
  }

  env {
    key   = "RCON_ENABLED"
    value = "true"
  }
}

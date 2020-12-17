# HashiCraft Minecraft Server

![](./images/hashicraft_logo.png)

This repository contains a Minecraft server with the Forge modding tools installed for Docker. Docker containers are immutable instances therfore any changes
you make to your Server across restarts will be lost. To save the state of your ensure the following container volumes are mapped to a local folder:

* /minecraft/world - Main world save data
* /minecraft/config - Main configuration folder for the server and modules

Access to the minecraft server is typically configured through the banning ips, whitelisting players, and banning players. Since the configuration files for these
options ares stored in the main Minecraft folder `/minecraft`, these settings would be lost after a container restart. To solve this problem this Docker image links the following files to the `/minecraft/config` folder:

* banned-ips.json
* banned-players.json
* usercache.json
* whitelist.json
* ops.json

To see a demo of this Image being deployed to Azure Container Images, checkout episode 1 of HashiCraft.

[https://www.youtube.com/watch?v=zL4Xt7CyuDE&t=1s](https://www.youtube.com/watch?v=zL4Xt7CyuDE&t=1s)

## Configuration

Configuration of the Mincraft server is completed through the following Environment variables:

### WORLD_BACKUP
Download a world backup archive in tar.gz format from the given URL and copy the contents to /minecraft/world when the server starts. It is expected
that the .tar.gz archive only has the world data at the root level.

Note: This operation will only take place when the /minecraft/world folder is empty

#### Example
```
WORLD_BACKUP=https://github.com/nicholasjackson/hashicraft/releases/download/v0.0.0/world2.tar.gz
```

#### Default - null


### MODS_BACKUP
Download a compressed folder in tar.gz format containing Minecraft mods and extract to /minecraft/mods when the server
starts. It is expected that the .tar.gz file has the mods at the root level.

Note: This operation will only take place when the /minecraft/mods folder is empty

#### Example
```
MODS_BACKUP=https://github.com/nicholasjackson/hashicraft/releases/download/v0.0.0/mods.tar.gz
```

#### Default - null


### RESOURCE_PACK
Download a compressed folder in zip format containing Minecraft resource pack, clients joining the server who have resource packs
enabled will automatically download and apply this resource pack.

#### Example
```
RESOURCE_PACK=https://github.com/HashiCraft/terraform_minecraft_azure_containers/releases/download/files/KawaiiWorld1.12.zip
```

#### Default - null


### JAVA_MEMORY
Configures how much memory is allocated to the Java virtual machine.

#### Example
```
JAVA_MEMORY=4
```

#### Default - 1G


### MINECRAFT_PORT
Port which the Minecraft server listens on.

#### Example
```
MINECRAFT_PORT=25565
```

#### Default - 25565


### ALLOW_NETHER
Enable the Nether underworld for the server

#### Example
```
ALLOW_NETHER=true
```

#### Default - false


### MINECRAFT_MOTD
Message of the day presented to users when they log in.

#### Example
```
MINECRAFT_MOTD="Welcome to the Minecraft server"
```

#### Default - null


### RCON_PORT
Port which the RCon remote admin server listens on.

#### Example
```
RCON_PORT=27015
```

#### Default - 27015


### RCON_ENABLED
Is the RCon remote admin server enabled?

#### Example
```
RCON_ENABLED=true
```

#### Default - false


### RCON_PASSWORD
Password to access the remote RCon server.

Note: You should always use a strong password when your server is connected to the public internet.

#### Example
```
RCON_ENABLED=3fdf32dss29$#c1
```

#### Default - null


### WHITELIST_ENABLED
Enable the Minecraft server player whitelist?

Note: You should always enable the whitelist when a server is connected to the public internet.

Users can be added to the whitelist using the following command from either the server or RCom terminal.

```
whitelist add <USERNAME>
```

#### Example
```
WHITELIST_ENABLED=true
```

#### Default - true


### GAME_MODE
Sets the game mode for new players.
Allowed values: "survival", "creative", or "adventure"

```
GAME_MODE=creative
```

#### Default - creative


### ENABLE_QUERY
Enables GameSpy4 protocol server listener. Used to get information about server.

```
ENABLE_QUERY=false
```

#### Default - false

### PLAYER_IDLE_TIMEOUT
If non-zero, players are kicked from the server if they are idle for more than that many minutes.

```
PLAYER_IDLE_TIMEOUT=30
```

#### Default - 0


### DIFFICULTY
Defines the difficulty (such as damage dealt by mobs and the way hunger and poison affects players) of the server.
Allowed values: "peaceful", "easy", "normal", "hard"

```
DIFFICULTY=peaceful
```

#### Default - easy


### SPAWN_MONSTERS
Determines if monsters can spawn.
true - Enabled. Monsters appear at night and in the dark.
false - Disabled. No monsters.

```
SPAWN_MONSTERS=false
```

#### Default - false


### SPAWN_ANIMALS
Determines if animals can spawn.
true - Animals spawn as normal.
false - Animals immediately vanish.

```
SPAWN_ANIMALS=false
```

#### Default - false


### SPAWN_NPCS
Determines if villagers can spawn.
true - Villagers spawn as normal.
false - Villagers immediately vanish.

```
SPAWN_NPCS=false
```

#### Default - false


## Running locally

```shell
docker run \
  --rm \
  -it \
  -p 25565:25565 \
  -p 27015:27015 \
  -v ${PWD}/mods:/minecraft/mods \
  -v ${PWD}/world:/minecraft/world \
  -v ${PWD}/config:/minecraft/config \
  -e "MINECRAFT_MOTD=Hello World" \
  -e "RCON_ENABLED=true" \
  -e "RCON_PASSWORD=password" \
  -e "WORLD_BACKUP=https://github.com/HashiCraft/digital-ocean-deploy/releases/download/v0.0.0/world.tar.gz" \
  hashicraft/minecraft:v1.16.3
```

## Running with Shipyard

Install Shipyard [https://shipyard.run](https://shipyard.run)

```
➜ shipyard run ./blueprint
Running configuration from:  ./

2020-04-09T09:12:28.504+0100 [DEBUG] Statefile does not exist
2020-04-09T09:12:28.504+0100 [INFO]  Creating Container: ref=minecraft
2020-04-09T09:12:28.562+0100 [DEBUG] Image exists in local cache: image=hashicraft/minecraft:latest
2020-04-09T09:12:28.562+0100 [INFO]  Creating Container: ref=minecraft
```

On initialization the Docker container will download the world and mods and copy these to your local disk:

* ./mods == Minecraft mods
* ./world == Minecraft world
* ./config == Minecraft config

To reset a world to its default state simply remove the contents of `./world`

## Building Docker
To make changes to the docker image you can modify the Dockerfile and entrypoint.sh script then build a new container

```
docker build -t hashicraft/minecraft:latest
```

## Exposing your server to the outside world
If you would like to expose your server to the Outside world NGrok is a great tool [https://ngrok.com/](https://ngrok.com/).

Install ngrok from https://ngrok.com/

Create a remote port for your local minecraft server

```shell
ngrok tcp 25565

Session Status                online                                                                                                                                                
Account                       Nicholas Jackson (Plan: Free)                                                                                                                         
Version                       2.3.35                                                                                                                                                
Region                        United States (us)                                                                                                                                    
Web Interface                 http://127.0.0.1:4040                                                                                                                                 
Forwarding                    tcp://0.tcp.ngrok.io:17144 -> localhost:25565                                                                                                         
                                                                                                                                                                                    
Connections                   ttl     opn     rt1     rt5     p50     p90                                                                                                           
                              0       0       0.00    0.00    0.00    0.00  
```

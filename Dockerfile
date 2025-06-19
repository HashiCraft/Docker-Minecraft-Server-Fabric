FROM openjdk:21-slim

# Build arguments for version parameterization
ARG MINECRAFT_VERSION=1.21.1
ARG FABRIC_INSTALLER_VERSION=1.0.1
ARG RCON_CLI_VERSION=1.6.8

WORKDIR /minecraft

RUN apt-get update && apt-get install -y libfreetype6 curl wget

# Install rcon
RUN curl -L -o rcon-cli.tar.gz https://github.com/itzg/rcon-cli/releases/download/${RCON_CLI_VERSION}/rcon-cli_${RCON_CLI_VERSION}_linux_amd64.tar.gz && \
  tar -xzf rcon-cli.tar.gz && \
  rm rcon-cli.tar.gz && \
  mv rcon-cli /usr/local/bin

# Setup the server
RUN curl -L -o fabric-installer.jar https://maven.fabricmc.net/net/fabricmc/fabric-installer/${FABRIC_INSTALLER_VERSION}/fabric-installer-${FABRIC_INSTALLER_VERSION}.jar && \
  java -jar fabric-installer.jar server -downloadMinecraft -mcversion ${MINECRAFT_VERSION}

# Copy the signed eula
COPY ./eula.txt eula.txt

# Add the entrypoint
COPY ./entrypoint.sh /minecraft/entrypoint.sh
COPY ./server.properties /server.properties

# Set defaults for environment variables
ENV MINECRAFT_PORT 25565
ENV RCON_PORT 27015
ENV JAVA_MEMORY 1G
ENV RCON_ENABLED false
ENV WHITELIST_ENABLED true
ENV ALLOW_NETHER false
ENV GAME_MODE creative
ENV ENABLE_QUERY false
ENV PLAYER_IDLE_TIMEOUT 0
ENV DIFFICULTY easy
ENV SPAWN_MONSTERS false
ENV SPAWN_ANIMALS false
ENV SPAWN_NPCS false

ENV LEVEL_TYPE default
ENV PVP false
ENV BROADCAST_CONSOLE_TO_OPS true
ENV SPAWN_PROTECTION 16
ENV MAX_TICK_TIME 60000
ENV FORCE_GAMEMODE true
#ENV GENERATOR_SETTINGS
ENV OP_PERMISSION_LEVEL 4
ENV SNOOPER_ENABLED true
ENV HARDCORE false
ENV ENABLE_COMMAND_BLOCK false
ENV MAX_PLAYERS 10000
ENV NETWORK_COMPRESSION_THRESHOLD 256
#ENV RESOURCE_PACK_SHA1
ENV MAX_WORLD_SIZE 29999984
#ENV SERVER_IP
ENV ALLOW_FLIGHT true
ENV LEVEL_NAME world
ENV VIEW_DISTANCE 10
ENV GENERATE_STRUCTURES true
ENV ONLINE_MODE true
ENV MAX_BUILD_HEIGHT 256
#ENV LEVEL_SEED
ENV PREVENT_PROXY_CONNECTION false

ENTRYPOINT [ "/minecraft/entrypoint.sh" ]

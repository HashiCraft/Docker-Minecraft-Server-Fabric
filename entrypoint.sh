#!/bin/sh -e

# Add the default mods, plugins and world
if [ "${WORLD_BACKUP}" != "" ]; then
  if [ ! "$(ls -A /minecraft/world)" ]; then 
    echo "Installing default world ${WORLD_BACKUP}"
    
    if [ ! -d "/minecraft/world" ]; then
      mkdir /minecraft/world
    fi
   
    cd /tmp && \
      wget -O world.tar.gz ${WORLD_BACKUP} && \
      tar -C /minecraft/world -xzf world.tar.gz && \
      rm world.tar.gz
  fi
fi

if [ "${MODS_BACKUP}" != "" ]; then 
  if [ ! "$(ls -A /minecraft/mods)" ]; then 
    echo "Installing default mods ${MODS_BACKUP}"
    
    if [ ! -d "/minecraft/mods" ]; then
      mkdir /minecraft/mods
    fi

    cd /tmp && \
      wget -O mods.tar.gz ${MODS_BACKUP} && \
      tar -C /minecraft/mods -xzf mods.tar.gz && \
      rm mods.tar.gz
  fi
fi

if [ "${PLUGINS_BACKUP}" != "" ]; then 
  if [ ! "$(ls -A /minecraft/plugins)" ]; then 
    echo "Installing default plugins ${PLUGINS_BACKUP}"
    
    if [ ! -d "/minecraft/plugins" ]; then
      mkdir /minecraft/plugins
    fi

    cd /tmp && \
      wget -O plugins.tar.gz ${PLUGINS_BACKUP} && \
      tar -C /minecraft/plugins -xzf plugins.tar.gz && \
      rm plugins.tar.gz
  fi
fi

# Add config items which are in the main minecraft folder from config so that 
# they can persist across launches
if [ ! -d "/minecraft/config" ]; then
  mkdir /minecraft/config
fi

if [ ! -f "/minecraft/config/banned-ips.json" ]; then
  echo "[]" >> /minecraft/config/banned-ips.json
fi

if [ ! -f "/minecraft/config/banned-players.json" ]; then
  echo "[]" >> /minecraft/config/banned-players.json
fi

if [ ! -f "/minecraft/config/usercache.json" ]; then
  echo "[]" >> /minecraft/config/usercache.json
fi

if [ ! -f "/minecraft/config/whitelist.json" ]; then
  echo "[]" >> /minecraft/config/whitelist.json
fi

if [ ! -f "/minecraft/config/ops.json" ]; then
  echo "[]" >> /minecraft/config/ops.json
fi

ln -s /minecraft/config/banned-ips.json /minecraft/banned-ips.json
ln -s /minecraft/config/banned-players.json /minecraft/banned-players.json
ln -s /minecraft/config/usercache.json /minecraft/usercache.json
ln -s /minecraft/config/whitelist.json /minecraft/whitelist.json
ln -s /minecraft/config/ops.json /minecraft/ops.json

# Configure the properties
# Echo the file as it has embedded environment variables
eval "echo \"$(cat /server.properties)\"" > /minecraft/server.properties

# Start the server
cd /minecraft
java -Xmx${JAVA_MEMORY} -Xms${JAVA_MEMORY} -Dfml.queryResult=confirm -jar fabric-server-launch.jar nogui

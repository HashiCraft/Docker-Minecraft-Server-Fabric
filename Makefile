DOCKER_NAME=hashicraft/minecraft
MINECRAFT_VERSION=1.21.1
FABRIC_INSTALLER_VERSION=1.0.1
RCON_CLI_VERSION=1.6.8
DOCKER_VERSION=v$(MINECRAFT_VERSION)-fabric

build:
	docker build -t ${DOCKER_NAME}:${DOCKER_VERSION} \
		--build-arg MINECRAFT_VERSION=${MINECRAFT_VERSION} \
		--build-arg FABRIC_INSTALLER_VERSION=${FABRIC_INSTALLER_VERSION} \
		--build-arg RCON_CLI_VERSION=${RCON_CLI_VERSION} \
		--no-cache .

build_and_push: build
	docker push ${DOCKER_NAME}:${DOCKER_VERSION}

ngrok:
	ngrok tcp 25565

build_multi:
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
	docker buildx create --name multi || true
	docker buildx use multi
	docker buildx inspect --bootstrap
	docker buildx build --platform linux/arm64,linux/amd64 \
		-t ${DOCKER_NAME}:${DOCKER_VERSION} \
		--build-arg MINECRAFT_VERSION=${MINECRAFT_VERSION} \
		--build-arg FABRIC_INSTALLER_VERSION=${FABRIC_INSTALLER_VERSION} \
		--build-arg RCON_CLI_VERSION=${RCON_CLI_VERSION} \
    -f ./Dockerfile \
    . \
		--push
	docker buildx rm multi

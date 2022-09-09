DOCKER_NAME=hashicraft/minecraft
DOCKER_VERSION=v1.19.2-fabric

build:
	docker build -t ${DOCKER_NAME}:${DOCKER_VERSION} --no-cache .

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
    -f ./Dockerfile \
    . \
		--push
	docker buildx rm multi

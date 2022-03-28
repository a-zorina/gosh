DOCKER_REG      = 127.0.0.1:5000
VERSION         = latest
IMAGE_REFERENCE = ${DOCKER_REG}/buildkit-gosh
DOCKER          = docker


all: image build-example run-example

.PHONE: prepare
prepare:
	@echo ------------------------------------
	@echo Prepare custom docker registry
	@echo ------------------------------------
	${DOCKER} rm -f buildkitd || true
	${DOCKER} run -d --name buildkitd --network host --privileged moby/buildkit:latest
	${DOCKER} rm -f reg || true
	${DOCKER} run -d --name reg -p ${DOCKER_REG}:5000 docker.io/library/registry:2
	# debug logserver
	(cd hack/logserver; ${DOCKER} build -t logserver .)
	${DOCKER} rm -f logserver || true
	${DOCKER} run -d -p 8888:8888 --name logserver logserver

.PHONE: jaeger
jaeger:
	${DOCKER} rm -f jaeger || true
	${DOCKER} run -d --name jaeger \
		-p 6831:6831/udp -p 16686:16686 \
		jaegertracing/all-in-one

.PHONE: image
image:
	@echo ------------------------------------
	@echo Build buildkit-gosh \(aka frontend\)
	@echo ------------------------------------
	go mod vendor
	${DOCKER} build -f Dockerfile -t ${IMAGE_REFERENCE}:${VERSION} .
	${DOCKER} push ${IMAGE_REFERENCE}:${VERSION}

# Examples
.PHONE: build-example
build-example:
	@echo ------------------------------------
	@echo Build sample image
	@echo ------------------------------------
	./examples/simple/simple.sh buildctl

.PHONE: run-example
run-example:
	@echo ------------------------------------
	@echo Run sample image
	@echo ------------------------------------
	./examples/simple/simple.sh runctl

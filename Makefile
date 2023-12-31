include .env
export $(shell sed 's/=.*//' .env)

run::
	docker run --rm -v ${PWD}:/app \
        -p ${LOCAL_PORT_HTTP}:80 -p ${LOCAL_PORT_HTTPS}:443 \
        dunglas/frankenphp

build::
	./bin/build.sh

test::
	echo ${LOCAL_PORT_HTTP}
	echo ${LOCAL_PORT_HTTPS}
	echo ${APP_STATIC_NAME}

run-static-app::
	docker run -it --rm \
		-v ${PWD}/build/${APP_STATIC_NAME}:/srv/${APP_STATIC_NAME} \
		-p ${LOCAL_PORT_HTTP}:80 -p ${LOCAL_PORT_HTTPS}:443 \
		ubuntu:22.04 \
		/srv/${APP_STATIC_NAME} php-server --domain localhost

build-app-image::
	echo "#!/bin/sh" > ./build/entrypoint.sh
	echo "/srv/${APP_STATIC_NAME} php-server --domain localhost" >> ./build/entrypoint.sh
	docker rm image ${APP_STATIC_IMAGE} || true
	./bin/build-app-image.sh

clean::
	rm -f ./build/*

####################################
# All needed to build app image and run it
build-final::
	@$(MAKE) clean
	@$(MAKE) build
	@$(MAKE) build-app-image

run-app-image::
	docker run --rm \
		-p ${LOCAL_PORT_HTTP}:80 -p ${LOCAL_PORT_HTTPS}:443 \
		${APP_STATIC_IMAGE}


save-image::
	docker save ${APP_STATIC_IMAGE} > ./build/${APP_STATIC_IMAGE}.tar

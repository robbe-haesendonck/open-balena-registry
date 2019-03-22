FROM balena/open-balena-base:armv7-fin

EXPOSE 80

RUN apt-get update \
	&& apt-get install \
		musl \
	&& rm -rf /var/lib/apt/lists/*

ENV REGISTRY_VERSION v2.6.2
ENV REGISTRY_DIR $GOPATH/src/github.com/docker/distribution

RUN mkdir -p $REGISTRY_DIR \
	&& curl -sSL https://github.com/docker/distribution/archive/$REGISTRY_VERSION.tar.gz | tar -xz -C $REGISTRY_DIR --strip-components=1 \
	&& cd $REGISTRY_DIR/cmd/registry \
	&& CGO_ENABLED=1 go build \
	&& cp registry /usr/local/bin/docker-registry \
	&& chmod a+x /usr/local/bin/docker-registry

COPY config/services/resin-registry.service /etc/systemd/system/

COPY . /usr/src/app

RUN systemctl enable resin-registry.service

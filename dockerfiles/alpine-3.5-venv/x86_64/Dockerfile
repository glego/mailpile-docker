FROM alpine:3.5

ARG APP_NAME="mailpile"
ARG APP_VERSION="1.0.0rc2"
ARG APP_GIT_URL="https://github.com/mailpile/Mailpile.git"

LABEL maintainer="glenn.goffin@gmail.com" \
        app-name="$APP_NAME" \
        app-version="$APP_VERSION"

# Initialize mailpile
# RUN chown mailpile: /mailpile-data -R && ./mp setup

# Install

RUN apk --no-cache add \
	ca-certificates \
	openssl \
	gnupg1 \
	py-pip \
	py-imaging \
	py-jinja2 \
	py-lxml \
	py-lockfile \
	py-pillow \
	py-pbr \
	py-cryptography \
	su-exec  && \
    \
    # Install build dependencies
     apk add --no-cache --virtual .build-deps \
        git && \
    \
    # Clone mailpile into 
    echo "Cloning ${APP_NAME} version: $APP_VERSION" && \
    git clone "$APP_GIT_URL" "/Mailpile" -b master && \
    cd "/Mailpile" && \
    git checkout tags/$APP_VERSION && \
    \
    # Install python requirements
    pip install -r requirements.txt && \
    \
    # Copy entrypoint
    cp packages/docker/entrypoint.sh /entrypoint.sh && \
    \
    # Create users and groups
    addgroup -S mailpile && adduser -S -h /mailpile-data -G mailpile mailpile && \
    # Remove build dependencies
    apk del .build-deps 

# Volumes
VOLUME /mailpile-data/.local/share/Mailpile
VOLUME /mailpile-data/.gnupg

WORKDIR /Mailpile

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ./mp --www=0.0.0.0:33411 --wait
EXPOSE 33411


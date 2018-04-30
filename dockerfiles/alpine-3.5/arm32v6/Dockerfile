FROM arm32v6/alpine:3.5

ARG APP_NAME="mailpile"
ARG APP_VERSION="1.0.0rc2"
ARG APP_GIT_URL="https://github.com/mailpile/Mailpile.git"

ENV APP_DIR="/app/mailpile"

LABEL maintainer="glenn.goffin@gmail.com" \
        app-name="$APP_NAME" \
        app-version="$APP_VERSION"

COPY root /

# Install
RUN \
    # Fix persmissions (Windows Build)
    chmod +x /entrypoint.sh && \
    chmod +x -R /app/ansible/roles/mailpile/files && \
    chmod +x -R /app/s6/ && \
    \
    # Install dependencies
    apk --no-cache add \
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
	su-exec \ 
    ansible && \
    \
    # Install build dependencies
     apk add --no-cache --virtual .build-deps \
        git && \
    \
    # Clone mailpile
    echo "Cloning ${APP_NAME} version: $APP_VERSION" && \
    git clone "$APP_GIT_URL" "$APP_DIR" -b master && \
    cd "$APP_DIR" && \
    git checkout tags/$APP_VERSION && \
    \
    # Install python requirements
    pip install --upgrade pip && \
    pip install -r requirements.txt && \
    \
    # Install s6 overlay
    update-ca-certificates && \
    cd "/tmp/" && \
    wget "https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-armhf.tar.gz" && \
    tar xzf /tmp/s6-overlay-armhf.tar.gz -C / && \
    \
    # Create users and groups
    addgroup -S mailpile && adduser -S -h /mailpile-data -G mailpile mailpile && \
    \
    # Remove build dependencies
    apk del .build-deps 

# Volumes
VOLUME /mailpile-data/.local/share/Mailpile
VOLUME /mailpile-data/.gnupg

WORKDIR "$APP_DIR"

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mailpile"]
EXPOSE 33411


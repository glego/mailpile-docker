FROM alpine:3.6

ARG APP_NAME="mailpile"
ARG APP_VERSION="1.0.0rc2"
ARG APP_GIT_URL="https://github.com/mailpile/Mailpile.git"

LABEL maintainer="glenn.goffin@gmail.com" \
        app-name="$APP_NAME" \
        app-version="$APP_VERSION"

# Installing App
RUN export "APP_ROOT_DIR=/app" && \
    export "APP_DIR=$APP_ROOT_DIR/$(printf "$APP_NAME" | awk '{print tolower($0)}')" && \
    export "VENV_DIR=$APP_ROOT_DIR/venv" && \
    \
    # Installing run dependencies
    apk update \
    && apk add --no-cache \
        ca-certificates py-virtualenv ansible openssl gnupg libxslt libxml2 libffi linux-headers zlib && \
    \
    # Installing build dependencies
    apk add --no-cache --virtual .build-deps \
        git gcc make musl-dev  python-dev linux-headers libffi-dev libxml2-dev libxslt-dev openssl-dev jpeg-dev && \
    \
    # Installing
    echo "Cloning $APP_NAME version: $APP_VERSION" && \
    git clone "$APP_GIT_URL" "$APP_DIR" -b master && \
    cd "$APP_DIR" && \
    git checkout tags/$APP_VERSION && \
    \
    # Setup virtual environment
    virtualenv "$VENV_DIR" && \
    \
    # Installing app
    /bin/sh -c "source $VENV_DIR/bin/activate && \
                    cd "$APP_DIR" && \
                    pip install -r requirements.txt && \
                    ./mp setup && \
                    deactivate" && \
    \
    # Remove build dependencies
    apk del .build-deps && \
    \
    # Add app user
    # addgroup -S appuser -g 1001 && adduser -S -u 1001 -G appuser appuser && \
    \
    # Installing s6 overlay
    cd "/tmp/" && \
    wget "https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-amd64.tar.gz" && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
    \
    echo "Installation finished..."

# VOLUME ["/home/appuser/.local/share/Mailpile", "/home/appuser/.gnupg"]
# RUN chown -R 1001:1001 /home/appuser
# USER appuser

COPY root /
COPY dockerfiles/alpine-3.6/x86_64/Dockerfile /Dockerfile

RUN chmod +x /entrypoint.sh && \
    chmod +x -R /app/ansible/roles/mailpile/files && \
    chmod +x -R /app/s6/

# Entrypoint
EXPOSE 33411
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mailpile"]


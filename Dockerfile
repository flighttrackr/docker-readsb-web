# Builder
FROM alpine:3.20.2 AS builder

WORKDIR /app

# Packages
RUN apk add --no-cache findutils

# Get Leaflet
ARG LEAFLET_URL="https://github.com/Leaflet/Leaflet/releases/download/v1.9.3/leaflet.zip"
RUN wget -O /tmp/leaflet.zip "$LEAFLET_URL" && \
    unzip /tmp/leaflet.zip -d /tmp/leaflet

RUN mkdir -p assets/leaflet && \
    cp -r \
    /tmp/leaflet/leaflet.css \
    /tmp/leaflet/leaflet.js \
    /tmp/leaflet/leaflet.js.map \
    /tmp/leaflet/images/ \
    assets/leaflet/

RUN find /app -type d -exec chmod 755 {} \; && \
    find /app -type f -exec chmod 644 {} \;


# Release
FROM nginx:1.27.0-alpine AS release

# Workdir
WORKDIR /app

# Copy files
COPY --from=builder /app/assets/ /app/assets/
COPY index.html /app/index.html
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /docker-entrypoint.d/50-entrypoint.sh

# Permissions
RUN chmod +x /docker-entrypoint.d/50-entrypoint.sh
RUN chmod 644 /app/index.html

# Environment
ENV READSB_HOST="readsb" \
    READSB_PORT="8042" \
    PAGE_TITLE="Readsb Web" \
    REFRESH_RATE="250" \
    CENTER_LAT="45.0" \
    CENTER_LNG="9.0" \
    CENTER_RADIUS="500"

# Healthcheck
HEALTHCHECK CMD curl --fail http://localhost/ || exit 1

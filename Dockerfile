# Builder
FROM alpine:3.16.2 AS builder

WORKDIR /app

# Packages
RUN apk add --no-cache findutils

# Get Leaflet
ARG LEAFLET_URL="https://github.com/Leaflet/Leaflet/archive/refs/tags/v1.7.1.tar.gz"
RUN mkdir -p leaflet assets/leaflet && \
    wget -O - "$LEAFLET_URL" | tar -xvzf - --strip 1 -C /app/leaflet

RUN cp -r \
    leaflet/dist/leaflet.css \
    leaflet/dist/leaflet.js \
    leaflet/dist/leaflet.js.map \
    leaflet/dist/images/ \
    assets/leaflet/

RUN find /app -type d -exec chmod 755 {} \; && \
    find /app -type f -exec chmod 644 {} \;


# Release
FROM nginx:1.23.2-alpine AS release

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

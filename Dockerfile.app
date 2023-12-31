FROM alpine:latest

ARG APP_STATIC_NAME

RUN mkdir -p /srv
COPY ./build/${APP_STATIC_NAME} /srv/${APP_STATIC_NAME}
COPY ./build/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]


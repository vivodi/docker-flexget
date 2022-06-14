FROM python:alpine
ARG TARGETPLATFORM
COPY requirements.txt /tmp
COPY wheels /wheels
RUN set -eu; \
    apk add --no-cache \
        g++ \
        make \
        libffi-dev \
    ; \
    [ $TARGETPLATFORM = linux/arm64 ] && apk add --no-cache \
        zlib-dev \
        jpeg-dev \
    ; \
    pip install -r /tmp/requirements.txt -f /wheels --root /root-dir --no-warn-script-location; \
    find /root-dir/usr/local -depth \
    \( \
        \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
        -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name 'libpython*.a' \) \) \
    \) -exec rm -rf '{}' +
COPY root /root-dir

FROM python:alpine
LABEL maintainer="madwind.cn@gmail.com"
LABEL org.label-schema.name="flexget"
ENV PYTHONUNBUFFERED 1
COPY --from=0 /root-dir /
RUN set -eu; \
    apk add --no-cache \
        shadow \
        libstdc++ \
    ; \
    groupmod -g 1000 users; \
    useradd -mUu 911 flexget; \
    usermod -G users flexget; \
    chmod +x /usr/bin/entrypoint.sh
VOLUME /config /downloads
WORKDIR /config
EXPOSE 3539
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

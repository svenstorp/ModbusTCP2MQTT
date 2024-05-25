ARG BUILD_FROM
FROM $BUILD_FROM
ENV LANG C.UTF-8

# Build arugments
ARG BUILD_VERSION
ARG BUILD_ARCH


COPY requirements.txt ./
COPY custom_packets/SungrowModbusWebClient-0.3.3.tar.gz ./
RUN apk add --no-cache python3-dev py3-pip g++
RUN pip install --upgrade pycryptodomex==3.11.0 --no-cache-dir -r requirements.txt
RUN pip install SungrowModbusWebClient-0.3.3.tar.gz

COPY SunGather/ /
RUN true
COPY SunGather/exports/ /exports
RUN true
COPY run.sh /
RUN true
COPY config_generator.py /

VOLUME /logs
VOLUME /config
# Install requirements for add-on
RUN chmod a+x /run.sh

CMD ["/run.sh"]

LABEL \ 
    io.hass.name="ModbusTCP2MQTT" \
    io.hass.description="Sungrow-SMA Solar inverter communication Addon" \
    io.hass.version=${BUILD_VERSION} \
    io.hass.type="addon" \
    io.hass.arch=${BUILD_ARCH}

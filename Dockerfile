FROM public.ecr.aws/amazoncorretto/amazoncorretto:21
ARG FORGE_VERSION="47.4.0"
ARG PACK_VERSION="2.5.2"
ARG TARGETARCH
RUN curl -L "https://mediafilez.forgecdn.net/files/6436/590/Create%20Chronicles%20Bosses%20and%20Beyond-$PACK_VERSION.zip" -o /tmp/server.zip && \
    yum install -y unzip && \
    mkdir -p /srv/minecraft/ && \
    cd /srv/minecraft/ && \
    unzip /tmp/server.zip && \
    echo "eula=true" > /srv/minecraft/eula.txt && \
    rm /tmp/server.zip && \
    yum remove -y unzip
RUN FORGE_URL="http://files.minecraftforge.net/maven/net/minecraftforge/forge/1.20.1-$FORGE_VERSION/forge-1.20.1-$FORGE_VERSION-installer.jar" && \
    cd /srv/minecraft/ && \
    curl -L "$FORGE_URL" -o installer.jar && \
    java -jar installer.jar --installServer && \
    rm installer.jar
ADD minecraft_start_script.sh /usr/bin/minecraft_start_script
RUN chmod +x /usr/bin/minecraft_start_script
COPY rconc_${TARGETARCH} /usr/bin/rconc
ENTRYPOINT [ "/usr/bin/minecraft_start_script" ]

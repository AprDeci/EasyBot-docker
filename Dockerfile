FROM xrcuor/easybot:base

COPY ./NapCat.Shell.zip /app/napcat/NapCat.Shell.zip
WORKDIR /app/napcat
RUN unzip -q NapCat.Shell.zip \
       && rm NapCat.Shell.zip

COPY EasyBot-Linux-amd64.zip /app/EasyBot/


WORKDIR /app/EasyBot
RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) \
  && unzip -q EasyBot-Linux-${arch}.zip \
       && rm EasyBot-Linux-amd64.zip \
       && chmod +x /app/EasyBot/EasyBot 

COPY linuxqq_3.2.13-29456_amd64.deb /app/linuxqq.deb
# 安装Linux QQ
RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && \
    dpkg -i --force-depends /app/linuxqq.deb && rm /app/linuxqq.deb && \
    echo "(async () => {await import('file:///app/napcat/napcat.mjs');})();" > /opt/QQ/resources/app/loadNapCat.js
RUN  sed -i 's|"main": "[^"]*"|"main": "./loadNapCat.js"|' /opt/QQ/resources/app/package.json


COPY ntqq.sh /opt/ntqq.sh
COPY start.sh /opt/start.sh
RUN chmod +x /opt/ntqq.sh \
       && chmod +x /opt/start.sh


WORKDIR /data

ENTRYPOINT  /opt/ntqq.sh & /opt/start.sh

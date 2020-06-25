FROM debian:buster-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y tigervnc-standalone-server wget dwm dmenu stterm
RUN wget -O /usr/local/bin/easy-novnc https://github.com/geek1011/easy-novnc/releases/download/v1.1.0/easy-novnc_linux-64bit && chmod +x /usr/local/bin/easy-novnc

RUN rm -rf /var/lib/apt/lists

COPY Dockerfile /Dockerfile
COPY novnc-usr-local-bin-cmd.sh /usr/local/bin/cmd.sh
CMD ["/usr/local/bin/cmd.sh"]
WORKDIR /root
EXPOSE 8080

# docker build -t novnc
# docker run -d --rm -p 8080:8080 novnc

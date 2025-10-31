FROM debian:12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y curl bash procps iproute2 cron && rm -rf /var/lib/apt/lists/*

COPY cfmonitor.sh /app/cfmonitor.sh
COPY start.sh /app/start.sh
RUN chmod +x /app/cfmonitor.sh /app/start.sh
EXPOSE 7860
ENV API_KEY=""
ENV SERVER_ID=""
ENV WORKER_URL=""

CMD ["/app/start.sh"]

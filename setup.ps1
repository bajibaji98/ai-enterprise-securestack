# === Create Dockerfile for api-service ===
@"
FROM python:3.11-slim
RUN useradd -m -u 10001 appuser
WORKDIR /app
COPY app /app/app
RUN pip install --no-cache-dir fastapi==0.115.2 uvicorn==0.30.6
USER appuser
EXPOSE 7000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "7000"]
"@ | Out-File -FilePath .\api_service\Dockerfile -Encoding utf8

# === Create Dockerfile for edge-proxy ===
@"
FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 443
ENTRYPOINT ["/entrypoint.sh"]
"@ | Out-File -FilePath .\edge_proxy\Dockerfile -Encoding utf8

# === Create entrypoint.sh for edge-proxy ===
@"
#!/bin/sh
set -e
mkdir -p /etc/nginx/certs
if [ ! -f /etc/nginx/certs/server.crt ]; then
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 `
    -subj "/C=US/ST=NA/L=Local/O=SecureStack/OU=Dev/CN=localhost" `
    -keyout /etc/nginx/certs/server.key `
    -out /etc/nginx/certs/server.crt
fi
exec nginx -g 'daemon off;'
"@ | Out-File -FilePath .\edge_proxy\entrypoint.sh -Encoding utf8

# === Create nginx.conf for edge-proxy ===
@"
worker_processes 1;
events { worker_connections 1024; }
http {
  map $http_x_request_id $req_id { default $http_x_request_id; "" $request_id; }
  server {
    listen 443 ssl http2;
    server_name localhost;
    ssl_certificate     /etc/nginx/certs/server.crt;
    ssl_certificate_key /etc/nginx/certs/server.key;

    location = /health { return 200 'OK'; add_header Content-Type text/plain; }
    location / {
      proxy_pass http://api-service:7000;
      proxy_set_header Host $host;
      proxy_set_header X-Request-ID $req_id;
      proxy_set_header X-Forwarded-Proto https;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_read_timeout 15s;
    }
  }
}
"@ | Out-File -FilePath .\edge_proxy\nginx.conf -Encoding utf8

# N8N Deployment

    terraform init
    terraform plan
    terraform apply

    shh -i my_gcp_key.pem ubuntu@<ip>

    cat <<'EOF' > ~/docker-compose.yml
    version: "3.8"

    services:
      postgres:
        image: postgres:15
        container_name: n8n_postgres
        environment:
          - POSTGRES_USER=n8n
          - POSTGRES_PASSWORD=n8npass
          - POSTGRES_DB=n8n
        volumes:
          - postgres_data:/var/lib/postgresql/data
        restart: unless-stopped

      n8n:
        image: n8nio/n8n:latest
        container_name: n8n
        depends_on:
          - postgres
        ports:
          - "5678:5678"
        environment:
          - DB_TYPE=postgresdb
          - DB_POSTGRESDB_HOST=postgres
          - DB_POSTGRESDB_PORT=5432
          - DB_POSTGRESDB_DATABASE=n8n
          - DB_POSTGRESDB_USER=n8n
          - DB_POSTGRESDB_PASSWORD=n8npass
          - N8N_BASIC_AUTH_ACTIVE=true
          - N8N_BASIC_AUTH_USER=admin
          - N8N_BASIC_AUTH_PASSWORD=admin123
          - N8N_HOST=35.222.24.72
          - N8N_PORT=5678
          - N8N_PROTOCOL=https
          - N8N_SSL_CERT=/etc/ssl/certs/n8n.crt
          - N8N_SSL_KEY=/etc/ssl/private/n8n.key
          - NODE_ENV=production
          - GENERIC_TIMEZONE=Asia/Kolkata
          - N8N_SECURE_COOKIE=true
        volumes:
          - n8n_data:/home/node/.n8n
          - /home/ubuntu/certs/n8n.crt:/etc/ssl/certs/n8n.crt:ro
          - /home/ubuntu/certs/n8n.key:/etc/ssl/private/n8n.key:ro
        restart: unless-stopped

    volumes:
      n8n_data:
      postgres_data:
    EOF


    mkdir -p /home/ubuntu/certs

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /home/ubuntu/certs/n8n.key \
    -out /home/ubuntu/certs/n8n.crt \
    -subj "/C=AU/ST=Some-State/L=City/O=MyOrganization/OU=MyUnit/CN=<your-ip>"

    sudo docker-compose up -d

    sudo docker ps





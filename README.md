# N8N Deployment

    terraform init
    terraform plan
    terraform apply

    shh -i my_gcp_key.pem ubuntu@<ip>

    mkdir -p /home/ubuntu/certs

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /home/ubuntu/certs/n8n.key \
    -out /home/ubuntu/certs/n8n.crt \
    -subj "/C=AU/ST=Some-State/L=City/O=MyOrganization/OU=MyUnit/CN=<your-ip>"

    sudo docker-compose up -d

    sudo docker ps





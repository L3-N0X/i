# SSL Certificates Directory

Place your SSL certificates here for HTTPS support.

Example files:
- server.crt (SSL certificate)
- server.key (Private key)
- dhparam.pem (Diffie-Hellman parameters)

Update the nginx configuration to enable SSL by adding:

```nginx
server {
    listen 443 ssl http2;
    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;
    ssl_dhparam /etc/nginx/ssl/dhparam.pem;
    
    # SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # ... rest of server configuration
}
```
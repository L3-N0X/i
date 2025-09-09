# Docker Setup for i File Upload Service

This setup provides a complete containerized file upload service with nginx reverse proxy for authentication and file serving.

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd i
   ```

2. **Create authentication credentials:**
   ```bash
   # Install apache2-utils (if not already installed)
   sudo apt-get install apache2-utils
   
   # Create a new htpasswd file with your username
   htpasswd -c nginx/htpasswd yourusername
   ```

3. **Start the services:**
   ```bash
   docker-compose up -d
   ```

4. **Access the service:**
   - Upload endpoint: `http://localhost/upload` (requires authentication)
   - Uploaded files: `http://localhost/<filename>`
   - Health check: `http://localhost/health`

## Service Overview

### i-upload
- **Port:** 9005 (internal only)
- **Purpose:** Handles file uploads and generates random filenames
- **Environment Variables:**
  - `ROOT`: Directory to save uploaded files (default: `/app/uploads/`)

### nginx
- **Ports:** 80 (HTTP), 443 (HTTPS - if SSL configured)
- **Purpose:** 
  - Reverse proxy for upload authentication
  - Static file server for uploaded content
  - Security headers and file type restrictions

## File Upload

### Using curl:
```bash
# Upload a file
curl -u username:password \
     -F "file=@/path/to/your/file.jpg" \
     http://localhost/upload
```

### Using ShareX:
1. Add a custom uploader in ShareX
2. Set URL to: `http://your-domain/upload`
3. Set authentication to Basic Auth with your username/password
4. Use multipart/form-data with field name "file"

## Configuration

### Changing Upload Directory
Edit `docker-compose.yml` and change the volume mapping:
```yaml
volumes:
  - ./your-custom-directory:/app/uploads
```

### Custom nginx Configuration
Edit `nginx/nginx.conf` to customize:
- Server name
- SSL certificates
- Upload size limits
- Authentication settings

### SSL/HTTPS Setup
1. Place your SSL certificates in `nginx/ssl/`
2. Update `nginx/nginx.conf` to include SSL configuration
3. Update port mappings in `docker-compose.yml`

## Default Credentials
- **Username:** admin
- **Password:** admin

**⚠️ IMPORTANT: Change these default credentials before deploying to production!**

## Monitoring

- **Logs:** `docker-compose logs -f`
- **Status:** `docker-compose ps`
- **Health Check:** `curl http://localhost/health`

## GitHub Container Registry

The image is automatically built and published to GitHub Container Registry when pushing to the main branch. You can use the pre-built image:

```yaml
services:
  i-upload:
    image: ghcr.io/l3-n0x/i:latest
    # ... rest of configuration
```

## Security Considerations

1. Change default authentication credentials
2. Use HTTPS in production
3. Configure firewall rules appropriately
4. Regularly update the nginx and application images
5. Consider file size and type restrictions based on your needs

## Troubleshooting

### Upload fails with 413 error
Increase `client_max_body_size` in nginx configuration.

### Files not appearing
Check that volume mounts are correct and permissions allow writing.

### Authentication not working
Verify htpasswd file format and nginx configuration.
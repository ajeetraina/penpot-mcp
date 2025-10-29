# Docker Deployment Guide for Penpot MCP

This guide provides comprehensive instructions for deploying Penpot MCP Server using Docker.

## 🚀 Quick Start

### Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+ (optional, for compose deployment)
- Penpot account credentials

### Option 1: Using Docker Compose (Recommended)

1. **Clone the repository**
```bash
git clone https://github.com/ajeetraina/penpot-mcp.git
cd penpot-mcp
```

2. **Create environment file**
```bash
cp env.example .env
```

3. **Edit `.env` with your credentials**
```env
PENPOT_API_URL=https://design.penpot.app/api
PENPOT_USERNAME=your_username
PENPOT_PASSWORD=your_password
PORT=5000
DEBUG=false
```

4. **Start the service**
```bash
docker compose up -d
```

5. **View logs**
```bash
docker compose logs -f penpot-mcp
```

6. **Stop the service**
```bash
docker compose down
```

### Option 2: Using Docker CLI

1. **Build the image**
```bash
docker build -t penpot-mcp:latest .
```

2. **Run the container**
```bash
docker run -d \
  --name penpot-mcp-server \
  -e PENPOT_API_URL=https://design.penpot.app/api \
  -e PENPOT_USERNAME=your_username \
  -e PENPOT_PASSWORD=your_password \
  -e PORT=5000 \
  -e DEBUG=false \
  -p 5000:5000 \
  --restart unless-stopped \
  penpot-mcp:latest
```

3. **View logs**
```bash
docker logs -f penpot-mcp-server
```

4. **Stop the container**
```bash
docker stop penpot-mcp-server
docker rm penpot-mcp-server
```

### Option 3: Using Pre-built Image from Docker Hub

```bash
docker run -d \
  --name penpot-mcp-server \
  -e PENPOT_API_URL=https://design.penpot.app/api \
  -e PENPOT_USERNAME=your_username \
  -e PENPOT_PASSWORD=your_password \
  -p 5000:5000 \
  ajeetraina777/penpot-mcp:latest
```

## 🔧 Configuration

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `PENPOT_API_URL` | No | `https://design.penpot.app/api` | Penpot API endpoint |
| `PENPOT_USERNAME` | Yes | - | Your Penpot username |
| `PENPOT_PASSWORD` | Yes | - | Your Penpot password |
| `PORT` | No | `5000` | Server port |
| `DEBUG` | No | `false` | Enable debug logging |

### Volume Mounts

For persistent cache:
```bash
docker run -d \
  -v penpot-cache:/app/cache \
  ...
```

## 🏗️ Advanced Deployment

### Using Docker Secrets (Docker Swarm)

1. **Create secrets**
```bash
echo "your_username" | docker secret create penpot_username -
echo "your_password" | docker secret create penpot_password -
```

2. **Deploy stack**
```yaml
version: '3.8'

services:
  penpot-mcp:
    image: ajeetraina/penpot-mcp:latest
    secrets:
      - penpot_username
      - penpot_password
    environment:
      - PENPOT_USERNAME_FILE=/run/secrets/penpot_username
      - PENPOT_PASSWORD_FILE=/run/secrets/penpot_password
    ports:
      - "5000:5000"

secrets:
  penpot_username:
    external: true
  penpot_password:
    external: true
```

### Health Checks

The container includes a built-in health check:
```bash
docker inspect --format='{{.State.Health.Status}}' penpot-mcp-server
```

### Resource Limits

Recommended resource limits:
```yaml
services:
  penpot-mcp:
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M
```

## 🔐 Security Best Practices

1. **Use Docker Secrets** for production deployments
2. **Run as non-root user** (default: user `penpot`)
3. **Use environment variables** instead of hardcoding credentials
4. **Enable TLS** for production deployments
5. **Regular updates** - Keep the image updated

## 🧪 Testing the Deployment

### Test MCP Server Connection

```bash
# Test if server is running
curl http://localhost:5000/health

# Test MCP protocol
docker exec penpot-mcp-server python -m penpot_mcp.server.client
```

### Run Tests in Container

```bash
docker run --rm penpot-mcp:latest pytest
```

## 📊 Monitoring

### View Logs

```bash
# Docker Compose
docker compose logs -f penpot-mcp

# Docker CLI
docker logs -f penpot-mcp-server

# Last 100 lines
docker logs --tail 100 penpot-mcp-server
```

### Container Stats

```bash
docker stats penpot-mcp-server
```

## 🐛 Troubleshooting

### Container won't start

1. **Check logs**
```bash
docker logs penpot-mcp-server
```

2. **Verify environment variables**
```bash
docker inspect penpot-mcp-server | grep -A 10 "Env"
```

3. **Test credentials manually**
```bash
docker exec -it penpot-mcp-server python test_credentials.py
```

### Connection issues

1. **Check network connectivity**
```bash
docker exec penpot-mcp-server ping -c 4 design.penpot.app
```

2. **Verify API URL**
```bash
docker exec penpot-mcp-server curl -v https://design.penpot.app/api
```

### CloudFlare protection

If you encounter CloudFlare blocks:
1. Open browser to https://design.penpot.app
2. Complete any challenges
3. Restart the container

## 🔄 Updates

### Update to Latest Version

```bash
# Pull latest image
docker pull ajeetraina/penpot-mcp:latest

# Restart with new image
docker compose down
docker compose pull
docker compose up -d
```

### Rebuild from Source

```bash
# Pull latest code
git pull origin main

# Rebuild image
docker compose build --no-cache

# Restart services
docker compose up -d
```

## 📦 Building Multi-Architecture Images

For ARM64 and AMD64 support:

```bash
# Create buildx builder
docker buildx create --name mybuilder --use

# Build and push multi-arch image
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ajeetraina/penpot-mcp:latest \
  --push .
```

## 🌐 Integration with Claude Desktop

Add to your Claude Desktop config:

**macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
**Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "penpot": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "-e", "PENPOT_API_URL=https://design.penpot.app/api",
        "-e", "PENPOT_USERNAME=your_username",
        "-e", "PENPOT_PASSWORD=your_password",
        "ajeetraina/penpot-mcp:latest"
      ]
    }
  }
}
```

## 📝 Example Use Cases

### 1. Local Development

```bash
docker compose -f docker-compose.yml up
```

### 2. Production Deployment

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### 3. CI/CD Pipeline

```yaml
# .github/workflows/deploy.yml
- name: Deploy to Production
  run: |
    docker pull ajeetraina/penpot-mcp:latest
    docker compose up -d
```

## 🤝 Support

For issues or questions:
- GitHub Issues: https://github.com/ajeetraina/penpot-mcp/issues
- Docker Hub: https://hub.docker.com/r/ajeetraina/penpot-mcp

## 📄 License

MIT License - see LICENSE file for details

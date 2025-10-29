# Makefile for Penpot MCP
.PHONY: mcp-server mcp-inspector mcp-server-sse

# Default port for MCP server
PORT ?= 5000
# Default mode is stdio (can be overridden by environment variable MODE)
MODE ?= stdio

# Launch MCP server with configurable mode (stdio or sse)
mcp-server:
	python -m penpot_mcp.server.mcp_server --mode $(MODE)

# Launch MCP server specifically in SSE mode
mcp-server-sse:
	MODE=sse python -m penpot_mcp.server.mcp_server

# Launch MCP inspector - requires the server to be running in sse mode
mcp-inspector:
	npx @modelcontextprotocol/inspector

# Run both server (in sse mode) and inspector (server in background)
all:
	MODE=sse python -m penpot_mcp.server.mcp_server & \
	npx @modelcontextprotocol/inspector

# Docker targets
.PHONY: docker-build docker-run docker-stop docker-logs docker-push docker-compose-up docker-compose-down docker-clean docker-test

# Build Docker image
docker-build:
	docker build -t penpot-mcp:latest .

# Run Docker container
docker-run:
	docker run --rm -it --env-file .env -p $(PORT):$(PORT) penpot-mcp:latest

# Run Docker container in detached mode
docker-run-detached:
	docker run -d --name penpot-mcp-server --env-file .env -p $(PORT):$(PORT) --restart unless-stopped penpot-mcp:latest

# Stop Docker container
docker-stop:
	docker stop penpot-mcp-server || true
	docker rm penpot-mcp-server || true

# View Docker logs
docker-logs:
	docker logs -f penpot-mcp-server

# Push Docker image to Docker Hub
docker-push:
	docker tag penpot-mcp:latest ajeetraina/penpot-mcp:latest
	docker push ajeetraina/penpot-mcp:latest

# Start services with Docker Compose
docker-compose-up:
	docker compose up -d

# Stop services with Docker Compose
docker-compose-down:
	docker compose down

# View Docker Compose logs
docker-compose-logs:
	docker compose logs -f

# Clean up Docker images
docker-clean:
	docker rmi penpot-mcp:latest || true
	docker rmi ajeetraina/penpot-mcp:latest || true

# Test Docker image
docker-test:
	docker run --rm penpot-mcp:latest python -m pytest

# Build multi-architecture image
docker-buildx:
	docker buildx create --name mybuilder --use || true
	docker buildx build --platform linux/amd64,linux/arm64 -t ajeetraina/penpot-mcp:latest --push .

# Shell into running container
docker-shell:
	docker exec -it penpot-mcp-server /bin/bash

# Complete Docker workflow: build, test, and run
docker-all: docker-build docker-test docker-run-detached
	@echo "Penpot MCP Docker container is running"
	@echo "View logs with: make docker-logs"
	@echo "Stop with: make docker-stop"

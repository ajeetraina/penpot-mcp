# Multi-stage build for optimal image size
FROM python:3.12-slim AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy dependency files
COPY pyproject.toml ./
COPY penpot_mcp/__init__.py penpot_mcp/__init__.py

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -e .

# Final stage - minimal runtime image
FROM python:3.12-slim

LABEL maintainer="Ajeet Singh Raina <ajeetraina@gmail.com>"
LABEL description="Penpot MCP Server - AI-powered design workflow automation"
LABEL org.opencontainers.image.source="https://github.com/ajeetraina/penpot-mcp"
LABEL org.opencontainers.image.description="Model Context Protocol server for Penpot"
LABEL org.opencontainers.image.licenses="MIT"

# Install procps for healthcheck (provides pgrep)
RUN apt-get update && apt-get install -y --no-install-recommends \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user for security
RUN useradd -m -u 1000 penpot && \
    mkdir -p /app /app/cache && \
    chown -R penpot:penpot /app

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy application code
COPY --chown=penpot:penpot . .

# Switch to non-root user
USER penpot

# Expose port for MCP server (when running in SSE mode)
EXPOSE 5000

# Health check - check if process is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD pgrep -f "penpot_mcp.server.mcp_server" > /dev/null || exit 1

# Default command - run MCP server in stdio mode
CMD ["python", "-u", "-m", "penpot_mcp.server.mcp_server"]

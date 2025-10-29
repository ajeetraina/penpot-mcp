# Getting Penpot API Credentials

## Overview

Unlike many APIs that use API keys, Penpot uses **username and password authentication** to obtain session tokens. This guide will help you set up your Penpot credentials for the MCP server.

## 🔐 Authentication Methods

Penpot MCP Server supports two authentication methods:

### Method 1: Username and Password (Recommended)

This is the standard authentication method for Penpot.

#### Step 1: Create a Penpot Account

1. Go to [https://penpot.app](https://penpot.app)
2. Click **"Sign up"** or **"Get started"**
3. Choose one of the following options:
   - **Email registration**: Enter your email and create a password
   - **Google OAuth**: Sign up with your Google account
   - **GitLab OAuth**: Sign up with your GitLab account
   - **GitHub OAuth**: Sign up with your GitHub account

#### Step 2: Get Your Credentials

**For Email Registration:**
- **Username**: The email address you used to sign up
- **Password**: The password you created during registration

**For OAuth (Google/GitLab/GitHub):**
If you signed up with OAuth, you'll need to set a password:
1. Log in to Penpot using your OAuth provider
2. Go to **Profile Settings** (click your avatar → Settings)
3. Navigate to **"Password"** section
4. Set a new password for your account
5. Now you can use your email and this password for API authentication

#### Step 3: Configure Environment Variables

Create a `.env` file in your project directory:

```bash
# Copy the example file
cp env.example .env
```

Edit the `.env` file with your credentials:

```env
PENPOT_API_URL=https://design.penpot.app/api
PENPOT_USERNAME=your_email@example.com
PENPOT_PASSWORD=your_password
PORT=5000
DEBUG=false
```

### Method 2: Self-Hosted Penpot Instance

If you're running your own Penpot instance:

```env
PENPOT_API_URL=https://your-penpot-instance.com/api
PENPOT_USERNAME=your_username
PENPOT_PASSWORD=your_password
PORT=5000
DEBUG=false
```

## 🧪 Testing Your Credentials

### Option 1: Using the Test Script

The repository includes a credential testing script:

```bash
# Make sure your .env file is configured
python test_credentials.py
```

Expected output if successful:
```
✅ Credentials are valid!
✅ Successfully authenticated as: Your Name
📊 Found X projects in your account

Projects:
  1. Project Name 1 (ID: xxx-xxx-xxx)
  2. Project Name 2 (ID: xxx-xxx-xxx)
```

### Option 2: Using Docker

```bash
# Test credentials with Docker
docker run --rm -it \
  -e PENPOT_USERNAME=your_email@example.com \
  -e PENPOT_PASSWORD=your_password \
  ajeetraina/penpot-mcp:latest \
  python test_credentials.py
```

### Option 3: Using the MCP Server Directly

```bash
# Start the MCP server with debug mode
DEBUG=true penpot-mcp

# Or with Docker
docker run --rm -it \
  -e PENPOT_USERNAME=your_email@example.com \
  -e PENPOT_PASSWORD=your_password \
  -e DEBUG=true \
  -p 5000:5000 \
  ajeetraina/penpot-mcp:latest
```

## 🔒 Security Best Practices

### 1. Environment Variables (Recommended)

Always use environment variables instead of hardcoding credentials:

```bash
# Good ✅
export PENPOT_USERNAME=your_email@example.com
export PENPOT_PASSWORD=your_password
penpot-mcp

# Bad ❌ - Never hardcode credentials in code
```

### 2. Using .env Files

For local development:

```bash
# Create .env file (already in .gitignore)
cat > .env << EOF
PENPOT_USERNAME=your_email@example.com
PENPOT_PASSWORD=your_password
EOF

# Set proper permissions
chmod 600 .env
```

### 3. Docker Secrets (Production)

For production deployments with Docker Swarm:

```bash
# Create Docker secrets
echo "your_email@example.com" | docker secret create penpot_username -
echo "your_password" | docker secret create penpot_password -

# Use in docker-compose.yml
```

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

secrets:
  penpot_username:
    external: true
  penpot_password:
    external: true
```

### 4. CI/CD Secrets

For GitHub Actions:

1. Go to your repository → Settings → Secrets and variables → Actions
2. Add the following secrets:
   - `PENPOT_USERNAME`
   - `PENPOT_PASSWORD`

### 5. Password Management

- ✅ Use a strong, unique password for Penpot
- ✅ Consider using a password manager
- ✅ Rotate passwords regularly
- ✅ Never commit credentials to version control
- ✅ Use different credentials for development and production

## 🚨 Troubleshooting

### Issue 1: "Authentication Failed"

**Causes:**
- Incorrect username or password
- Account not activated
- CloudFlare protection blocking requests

**Solutions:**

1. **Verify credentials:**
   ```bash
   # Test login through browser first
   # Visit https://design.penpot.app and log in manually
   ```

2. **Check for CloudFlare blocks:**
   ```bash
   # Open browser and visit:
   https://design.penpot.app
   
   # Complete any CloudFlare challenges
   # Then try the MCP server again
   ```

3. **Reset password:**
   - Go to [https://design.penpot.app](https://design.penpot.app)
   - Click "Forgot password?"
   - Follow the reset instructions

### Issue 2: "CloudFlare Protection Detected"

Penpot's cloud service uses CloudFlare protection. To resolve:

1. Open your browser and navigate to [https://design.penpot.app](https://design.penpot.app)
2. Log in to your account
3. Complete any CloudFlare human verification challenges
4. Keep the browser tab open while testing the MCP server
5. The CloudFlare verification usually lasts for a session

### Issue 3: OAuth Users Can't Authenticate

If you signed up with Google/GitHub/GitLab:

1. Log in to Penpot using your OAuth provider
2. Go to Settings → Password
3. Set a password for API access
4. Use your email + new password for authentication

### Issue 4: Self-Hosted Instance Issues

For self-hosted Penpot instances:

```bash
# Verify the API URL is correct
curl https://your-penpot-instance.com/api

# Should return Penpot API information

# Common mistakes:
# ❌ https://your-penpot-instance.com (missing /api)
# ❌ http://your-penpot-instance.com/api (should be https)
# ✅ https://your-penpot-instance.com/api (correct)
```

## 🔍 Understanding Penpot Authentication Flow

The Penpot MCP server follows this authentication flow:

```
1. Client provides username + password
   ↓
2. Server sends POST request to /api/auth/login
   ↓
3. Penpot API validates credentials
   ↓
4. API returns authentication token
   ↓
5. Server stores token for session
   ↓
6. Subsequent API calls use this token
```

### Token Lifecycle

- **Token validity**: Typically valid for the session duration
- **Auto-refresh**: The MCP server handles token refresh automatically
- **Expiration**: Tokens expire after inactivity (usually 24 hours)
- **Re-authentication**: Server automatically re-authenticates if token expires

## 📋 Configuration Examples

### Local Development

```bash
# .env file
PENPOT_API_URL=https://design.penpot.app/api
PENPOT_USERNAME=dev@example.com
PENPOT_PASSWORD=dev_password_here
PORT=5000
DEBUG=true
```

### Production (Docker Compose)

```yaml
version: '3.8'

services:
  penpot-mcp:
    image: ajeetraina/penpot-mcp:latest
    environment:
      - PENPOT_API_URL=https://design.penpot.app/api
      - PENPOT_USERNAME=${PENPOT_USERNAME}
      - PENPOT_PASSWORD=${PENPOT_PASSWORD}
      - PORT=5000
      - DEBUG=false
    env_file:
      - .env.production
    restart: unless-stopped
```

### Claude Desktop Integration

**macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "penpot": {
      "command": "docker",
      "args": [
        "run", "--rm", "-i",
        "-e", "PENPOT_USERNAME=your_email@example.com",
        "-e", "PENPOT_PASSWORD=your_password",
        "ajeetraina/penpot-mcp:latest"
      ]
    }
  }
}
```

**Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "penpot": {
      "command": "docker",
      "args": [
        "run", "--rm", "-i",
        "-e", "PENPOT_USERNAME=your_email@example.com",
        "-e", "PENPOT_PASSWORD=your_password",
        "ajeetraina/penpot-mcp:latest"
      ]
    }
  }
}
```

## 🎯 Quick Reference

| Item | Value |
|------|-------|
| **Penpot Cloud URL** | https://design.penpot.app |
| **API Endpoint** | https://design.penpot.app/api |
| **Authentication Type** | Username + Password (Token-based) |
| **Token Location** | Session-based (handled automatically) |
| **Token Expiry** | ~24 hours of inactivity |
| **Required Scopes** | Full account access (no granular scopes) |

## 📚 Additional Resources

- [Penpot Official Documentation](https://help.penpot.app/)
- [Penpot API Documentation](https://design.penpot.app/api/docs)
- [Penpot GitHub Repository](https://github.com/penpot/penpot)
- [Docker Deployment Guide](./DOCKER.md)
- [MCP Tools Documentation](./MCP_TOOLS.md)

## ❓ FAQ

**Q: Do I need to generate an API key?**
A: No, Penpot uses username/password authentication, not API keys.

**Q: Can I use my OAuth login for the API?**
A: You need to set a password in your Penpot account settings first.

**Q: How often do I need to re-authenticate?**
A: The MCP server handles re-authentication automatically. Tokens typically last 24 hours.

**Q: Is my password stored securely?**
A: The password is used only to obtain an authentication token and should be stored as an environment variable, never in code.

**Q: Can I use multiple Penpot accounts?**
A: Yes, but you'll need separate MCP server instances with different configurations.

**Q: Does the free Penpot account work with the API?**
A: Yes! The free Penpot cloud account has full API access.

---

**Need Help?**
- GitHub Issues: [Report issues](https://github.com/ajeetraina/penpot-mcp/issues)
- Penpot Community: [Join discussions](https://community.penpot.app/)

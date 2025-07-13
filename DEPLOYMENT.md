# Deploying Chimera CMS to Fly.io

## Prerequisites

1. **Fly.io Account**: Sign up at [fly.io](https://fly.io)
2. **flyctl CLI**: Already installed ✅

## Deployment Steps

### 1. Login to Fly.io
```bash
flyctl auth login
```

### 2. Create and Deploy Your App
```bash
# Create the app (this will also create the fly.toml if it doesn't exist)
flyctl create chimera-cms

# Create a PostgreSQL database
flyctl postgres create --name chimera-cms-db --region ord

# Attach the database to your app
flyctl postgres attach --app chimera-cms chimera-cms-db
```

### 3. Set Environment Variables
```bash
# Generate a new secret key for production
SECRET_KEY=$(mix phx.gen.secret)

# Set production secrets
flyctl secrets set SECRET_KEY_BASE="$SECRET_KEY"
flyctl secrets set LIVEVIEW_SIGNING_SALT="$(mix phx.gen.secret 32)"

# Set your admin password (change this!)
flyctl secrets set ADMIN_EMAIL="admin@chimera.com"
flyctl secrets set ADMIN_PASSWORD="your_secure_admin_password"
```

### 4. Deploy Your Application
```bash
flyctl deploy
```

### 5. Check Your Deployment
```bash
# View your app
flyctl open

# Check logs
flyctl logs

# Check status
flyctl status
```

## Post-Deployment

### Access Your CMS
- **Frontend**: `https://chimera-cms.fly.dev`
- **Admin Panel**: `https://chimera-cms.fly.dev/admin`
- **API**: `https://chimera-cms.fly.dev/api/posts`

### Default Admin Credentials
- **Email**: admin@chimera.com
- **Password**: The password you set in ADMIN_PASSWORD secret

### Useful Commands

```bash
# Scale your app
flyctl scale memory 512  # Adjust memory
flyctl scale count 2     # Scale to 2 instances

# Access your database
flyctl postgres connect -a chimera-cms-db

# Run console on your app
flyctl ssh console

# View metrics
flyctl dashboard
```

## Environment Variables

Your app expects these environment variables (set via `flyctl secrets set`):

- `SECRET_KEY_BASE` - Phoenix secret key (64 characters)
- `LIVEVIEW_SIGNING_SALT` - LiveView signing salt (32 characters)
- `DATABASE_URL` - Set automatically by Fly.io when you attach PostgreSQL
- `PHX_HOST` - Set in fly.toml as `chimera-cms.fly.dev`
- `PORT` - Set in fly.toml as `8080`

## Updating Your App

To deploy updates:

```bash
# Make your changes, then:
flyctl deploy
```

## Troubleshooting

### Check Logs
```bash
flyctl logs --app chimera-cms
```

### Health Checks
```bash
flyctl status --app chimera-cms
```

### Database Issues
```bash
# Connect to database
flyctl postgres connect -a chimera-cms-db

# View database logs
flyctl logs --app chimera-cms-db
```

### Rollback
```bash
# List releases
flyctl releases

# Rollback to previous version
flyctl releases rollback <version>
```

## Configuration Files Created

- ✅ `fly.toml` - Fly.io app configuration
- ✅ `Dockerfile` - Production Docker image
- ✅ `rel/overlays/bin/migrate` - Database migration script
- ✅ `lib/chimera_cms/release.ex` - Release utilities
- ✅ `.dockerignore` - Docker build optimization

## Production Considerations

1. **Database Backups**: Fly.io PostgreSQL has automatic backups
2. **SSL**: Enabled automatically by Fly.io
3. **CDN**: Consider using Fly.io's edge network for static assets
4. **Monitoring**: Use `flyctl dashboard` or integrate with monitoring services
5. **Scaling**: Start with 1 instance, scale based on traffic

## Security

- All secrets are managed via `flyctl secrets`
- Database communication is encrypted
- HTTPS is enforced
- Admin interface requires authentication 
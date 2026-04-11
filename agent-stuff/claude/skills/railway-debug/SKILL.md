---
name: railway-debug
description: Check Railway services (api/web) for errors, view logs, and fix deployment issues. Use when deployments fail, services are unhealthy, or you need to investigate production errors.
allowed-tools: Bash(railway *), Read, Grep, Glob
argument-hint: "[service]"
---

# Railway Debug

Check Railway services for errors and fix them.

**Usage**: `/railway-debug` or `/railway-debug [service]` where service is `api`, `web`, or `all`.

## Instructions

### 1. List and check service status

First, check which services are healthy or failed:

```bash
railway service status --all
```

### 2. Investigate Failed Services

For each failed or problematic service, check logs in this order:

**Build logs** (compilation/bundling issues):
```bash
railway logs --service <service> --build --lines 100 --latest
```

**Deployment logs** (runtime errors):
```bash
railway logs --service <service> --lines 100 --latest
```

**Error-specific logs**:
```bash
railway logs --service <service> --lines 50 --filter "@level:error" --latest
```

### 3. Common Error Patterns

#### Web Service (Vite/React)

| Error Pattern | Likely Cause | Fix |
|--------------|--------------|-----|
| `Module not found` | Missing dependency | Check `web/package.json`, run `npm install` |
| `TypeScript error` | Type issue | Run `npx tsc --noEmit` in `web/` |
| `Build failed` | Vite config issue | Check `web/vite.config.ts` |
| `CORS error` | API URL mismatch | Check `VITE_API_URL` env var in Railway |

#### API Service (Rails)

| Error Pattern | Likely Cause | Fix |
|--------------|--------------|-----|
| `Migrations pending` | DB out of sync | Run `railway run bin/rails db:migrate` |
| `Bundler error` | Gem issues | Check `api/Gemfile`, ensure Ruby version matches |
| `SECRET_KEY_BASE` | Missing env var | Set in Railway variables |
| `Database connection` | Postgres URL | Check `DATABASE_URL` is set from Postgres service |

### 4. Fix and Verify

After identifying the issue:

1. Read the relevant source files based on error messages
2. Make necessary code fixes
3. Verify locally before redeploying:
   - For web: `cd web && npm run build`
   - For api: `cd api && bundle exec rspec`

### 5. Redeploy (if requested)

After fixes are verified:
```bash
railway redeploy --service <service>
```

## Service Reference

| Service | Directory | Description |
|---------|-----------|-------------|
| api | `api/` | Rails backend |
| web | `web/` | Vite/React frontend |
| Postgres | - | Database (check connection issues) |

## Environment Variables

### API Service
- `DATABASE_URL` - Should reference the Postgres service
- `RAILS_ENV` - Should be `production`
- `SECRET_KEY_BASE` - Must be set for production
- `RAILS_MASTER_KEY` - If using credentials

### Web Service
- `VITE_API_URL` - API endpoint URL
- `NODE_ENV` - Should be `production` for builds

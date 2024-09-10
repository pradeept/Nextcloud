# Nextcloud - Deployment and Configuration

### Infrastructure (Terraform - Digitalocean)

```
- Droplet Configuration
- Domain configuration
```

### Configuration (Ansible)

```
- Setup
    - User configuration
    - Docker & docker compose installation
    - Copy and setup docker compose

- SSL/TLS
    - Configure nginx with a domain
    - Install cert to the domain

- Firewall
    - Configure firewall for droplet
        // Has to be done after installing cert

- Backup
    - Copy the shell script (nextcloud)
    - Setup cron job automated backups
```

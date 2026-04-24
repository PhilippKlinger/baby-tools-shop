# Baby Tools Shop

This repository contains a Django-based shop application with a Docker setup for local testing and VPS deployment.

The application is designed to run in a containerized environment and to be reachable on port `8025` by default.

## Table of Contents

- [1. Quickstart](#1-quickstart)
- [2. Usage](#2-usage)
- [3. Configuration](#3-configuration)
- [4. Security Notes](#4-security-notes)
- [5. Validation](#5-validation)

---

## 1. Quickstart

Clone the repository and enter the project folder.

```bash
git clone git@github.com:PhilippKlinger/baby-tools-shop.git
cd baby-tools-shop
```

Create a local environment file.

```bash
cp .env.example .env
```

Build the image.

```bash
docker compose build
```

Generate a Django secret key with the container.

```bash
docker compose run --rm web python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

Open `.env`, set `DJANGO_SECRET_KEY`, and review the values listed in the [Configuration](#3-configuration) section.

Start the application.

```bash
docker compose up --build -d
```

Create an admin user.

```bash
docker compose exec web python manage.py createsuperuser
```

Open the application:

```text
http://localhost:${HOST_PORT}
```

Open the admin panel:

```text
http://localhost:${HOST_PORT}/admin/
```

---

## 2. Usage

### Local Docker Usage

Use Docker Desktop or Docker Engine to run the project locally.

Start the stack:

```bash
docker compose up --build -d
```

Stop the stack:

```bash
docker compose down
```

Do not use the following command if you want to keep the database and uploaded files:

```bash
docker compose down -v
```

The local shop is available at:

```text
http://localhost:${HOST_PORT}
```

### VPS Deployment

Clone the repository on the VPS and enter the project folder.

```bash
git clone git@github.com:PhilippKlinger/baby-tools-shop.git
cd baby-tools-shop
```

Create `.env` from the template:

```bash
cp .env.example .env
```

Build the image:

```bash
docker compose build
```

Generate a secret key:

```bash
docker compose run --rm web python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

Update `.env` with a generated `DJANGO_SECRET_KEY` and the deployment-specific values described in the [Configuration](#3-configuration) section.

Start the application:

```bash
docker compose up --build -d
```

Create an admin user:

```bash
docker compose exec web python manage.py createsuperuser
```

Open the shop:

```text
http://<server-ip>:8025
```

### Shop Content

The repository does not include prepared shop content.

To make products visible in the shop:

1. Open the admin panel.
2. Create categories.
3. Upload product images.
4. Create products and assign them to categories.

The Docker setup persists the SQLite database and uploaded media files in a Docker volume. A normal container restart keeps the data.

---

## 3. Configuration

Copy `.env.example` to `.env` and adjust the values below for your target environment.

| Variable | Purpose | Default Value |
| --- | --- | --- |
| `HOST_PORT` | Published host port for Docker Compose. The container still listens on port `8025`. | `8025` |
| `DJANGO_SECRET_KEY` | Secret key for Django. Replace this placeholder before starting the application. | `replace-this-with-a-generated-secret-key` |
| `DJANGO_DEBUG` | Django debug mode. Keep this `False` for the final Docker and VPS setup. | `False` |
| `DJANGO_ALLOWED_HOSTS` | Comma-separated hosts that Django accepts. Change this for your VPS domain or IP. | `localhost,127.0.0.1` |
| `DJANGO_CSRF_TRUSTED_ORIGINS` | Trusted origins including scheme and port. Update this when the host, domain, or port changes. | `http://localhost:8025,http://127.0.0.1:8025` |
| `SQLITE_PATH` | SQLite database file used by the container runtime. Keep this on the mounted `/data` volume for persistence. | `/data/db.sqlite3` |
| `MEDIA_ROOT` | Directory for uploaded media files. Keep this on the mounted `/data` volume for persistence. | `/data/media` |
| `DJANGO_SERVE_MEDIA` | Enables Django media serving for this container-based setup. | `True` |

The container runtime stores persistent data under:

```text
/data/db.sqlite3
/data/media
```

This data is mounted from a Docker volume and remains available after a normal restart.

---

## 4. Security Notes

- Do not commit real `.env` files.
- Do not store SSH keys, passwords, tokens, usernames, or server IP addresses in the repository.
- Keep `DJANGO_DEBUG=False` on the VPS.
- Use a generated `DJANGO_SECRET_KEY`.
- Restrict `DJANGO_ALLOWED_HOSTS` to the required hosts only.
- The container runs as a dedicated non-root user.

---

## 5. Validation

Local validation:

```bash
docker compose up --build -d
docker compose exec web python manage.py createsuperuser
```

Check:

- the shop opens in the browser on `http://localhost:${HOST_PORT}`
- the admin panel opens on `http://localhost:${HOST_PORT}/admin/`
- static files are loaded
- uploaded media files are displayed

VPS validation:

- the application is reachable at `http://<server-ip>:8025` or `http://<server-ip>:${HOST_PORT}` if you changed the host port
- the admin panel works
- product data remains available after:

```bash
docker compose down
docker compose up -d
```

# Baby Tools Shop

This repository contains a Django-based shop application with a Docker setup for local testing and VPS deployment.

The application is designed to run in a containerized environment and to be reachable on port `8025`.

## Table of Contents

- [1. Repository Overview](#1-repository-overview)
- [2. Quickstart](#2-quickstart)
- [3. Usage](#3-usage)
- [4. Configuration](#4-configuration)
- [5. Security Notes](#5-security-notes)
- [6. Validation](#6-validation)

---

## 1. Repository Overview

The most relevant files and folders are:

```text
baby-tools-shop/
├── .dockerignore
├── .env.example
├── .gitignore
├── compose.yml
├── Dockerfile
├── README.md
├── requirements.txt
├── babyshop_app/
│   ├── manage.py
│   ├── babyshop/
│   ├── products/
│   ├── users/
│   └── templates/
└── project_images/
```

Purpose of the repository:

- run the shop with Docker
- keep configuration outside the codebase
- persist database and uploaded media files
- deploy the application to a VPS on port `8025`

---

## 2. Quickstart

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

Open `.env` and set at least the following values:

```text
DJANGO_SECRET_KEY=<generated-secret-key>
DJANGO_DEBUG=False
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1
DJANGO_CSRF_TRUSTED_ORIGINS=http://localhost:8025,http://127.0.0.1:8025
```

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
http://localhost:8025
```

Open the admin panel:

```text
http://localhost:8025/admin/
```

---

## 3. Usage

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
http://localhost:8025
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

Set the VPS-specific values in `.env`:

```text
DJANGO_SECRET_KEY=<generated-secret-key>
DJANGO_DEBUG=False
DJANGO_ALLOWED_HOSTS=<server-ip>
DJANGO_CSRF_TRUSTED_ORIGINS=http://<server-ip>:8025
```

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

## 4. Configuration

The project uses environment variables for configuration.

| Variable | Description |
| --- | --- |
| `DJANGO_SECRET_KEY` | Django secret key for the deployment. |
| `DJANGO_DEBUG` | Use `False` for the final Docker and VPS setup. |
| `DJANGO_ALLOWED_HOSTS` | Comma-separated allowed hosts. |
| `DJANGO_CSRF_TRUSTED_ORIGINS` | Trusted origins including scheme and port. |
| `SQLITE_PATH` | SQLite database path. |
| `MEDIA_ROOT` | Upload directory for media files. |
| `DJANGO_SERVE_MEDIA` | Enables Django media serving in this container-based setup. |

The container runtime stores persistent data under:

```text
/data/db.sqlite3
/data/media
```

This data is mounted from a Docker volume and remains available after a normal restart.

---

## 5. Security Notes

- Do not commit real `.env` files.
- Do not store SSH keys, passwords, tokens, usernames, or server IP addresses in the repository.
- Keep `DJANGO_DEBUG=False` on the VPS.
- Use a generated `DJANGO_SECRET_KEY`.
- Restrict `DJANGO_ALLOWED_HOSTS` to the required hosts only.
- The container runs as a dedicated non-root user.

---

## 6. Validation

Local validation:

```bash
docker compose up --build -d
docker compose exec web python manage.py createsuperuser
```

Check:

- the shop opens in the browser
- the admin panel opens
- static files are loaded
- uploaded media files are displayed

VPS validation:

- the application is reachable at `http://<server-ip>:8025`
- the admin panel works
- product data remains available after:

```bash
docker compose down
docker compose up -d
```

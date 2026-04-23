# Baby Tools Shop

Use this guide to run the Baby Tools Shop Django application locally and deploy it with Docker on a V-Server.

This repository contains the Django source code, Docker setup, environment templates, and project documentation for a small shop application that must be reachable on port `8025`.

## Table of Contents

- [1. Repository Overview](#1-repository-overview)
- [2. Quickstart](#2-quickstart)
- [3. Usage](#3-usage)
- [4. Configuration](#4-configuration)
- [5. Security Notes](#5-security-notes)
- [6. Validation](#6-validation)
- [7. Submission Notes](#7-submission-notes)

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

- run the Django shop locally
- containerize it with Docker
- keep configuration outside the codebase
- deploy it to a VPS on port `8025`

---

## 2. Quickstart

Create a local environment file:

```bash
cp .env.example .env
```

Build the Docker image:

```bash
docker compose build
```

Generate a Django secret key with the container:

```bash
docker compose run --rm web python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

Open `.env` and set at least:

```text
DJANGO_SECRET_KEY=<generated-secret-key>
DJANGO_DEBUG=False
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1
DJANGO_CSRF_TRUSTED_ORIGINS=http://localhost:8025,http://127.0.0.1:8025
```

Start the application:

```bash
docker compose up --build
```

Open the shop:

```text
http://localhost:8025
```

---

## 3. Usage

### Local Django Development

Create and activate a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Install dependencies:

```bash
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

Start Django locally:

```bash
cd babyshop_app
python manage.py migrate
python manage.py runserver
```

Open:

```text
http://127.0.0.1:8000
http://127.0.0.1:8000/admin/
```

Create an admin user if needed:

```bash
python manage.py createsuperuser
```

### Docker Compose

Create `.env` from the template:

```bash
cp .env.example .env
```

Build and start the container:

```bash
docker compose up --build -d
```

Stop it again:

```bash
docker compose down
```

Create an admin user inside the running container:

```bash
docker compose exec web python manage.py createsuperuser
```

The application is available at:

```text
http://localhost:8025
```

### VPS Deployment

Clone the repository on the VPS, create `.env`, generate a secret key, and start the stack with Docker Compose.

For a VPS deployment, set the server-specific values in `.env`:

```text
DJANGO_SECRET_KEY=<generated-secret-key>
DJANGO_DEBUG=False
DJANGO_ALLOWED_HOSTS=<server-ip>
DJANGO_CSRF_TRUSTED_ORIGINS=http://<server-ip>:8025
```

Then start the service:

```bash
docker compose up --build -d
```

Open:

```text
http://<server-ip>:8025
```

### Application Data

The repository does not include ready-made shop content.

To show products in the shop:

1. Create a superuser.
2. Open the admin panel.
3. Create categories.
4. Upload product images.
5. Create products and assign them to categories.

The Docker setup stores the SQLite database and uploaded media files in a persistent volume, so the data remains available after a normal container restart.

---

## 4. Configuration

The project uses environment variables for configuration.

Relevant variables:

| Variable | Description |
| --- | --- |
| `DJANGO_SECRET_KEY` | Django secret key for the deployment. |
| `DJANGO_DEBUG` | Use `True` for local debugging, `False` for the final deployment. |
| `DJANGO_ALLOWED_HOSTS` | Comma-separated allowed hosts. |
| `DJANGO_CSRF_TRUSTED_ORIGINS` | Trusted origins including scheme and port. |
| `SQLITE_PATH` | SQLite database path. |
| `MEDIA_ROOT` | Upload directory for media files. |
| `DJANGO_SERVE_MEDIA` | Enables Django media serving for this container-based setup. |

Local development values can point to the project folders:

```text
SQLITE_PATH=babyshop_app/db.sqlite3
MEDIA_ROOT=babyshop_app/media
```

Docker Compose overrides runtime paths for the container:

```text
SQLITE_PATH=/data/db.sqlite3
MEDIA_ROOT=/data/media
```

The Compose file also uses:

```text
${APP_VERSION:-latest}
```

This keeps the image tag configurable while providing a sensible default.

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
cd babyshop_app
python manage.py check
python manage.py migrate
python manage.py runserver
```

Docker validation:

```bash
docker compose up --build
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

Do not use `docker compose down -v` if you want to keep the database and uploaded files.

---

## 7. Submission Notes

The final submission should include:

- repository link
- pull request link
- a short Loom video
- the deployed application URL on port `8025`

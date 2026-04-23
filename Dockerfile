FROM python:3.12-slim

# Keep the container logs readable and avoid writing Python cache files.
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Default Django configuration for the container runtime.
# Sensitive values should be overridden with environment variables.
ENV DJANGO_SETTINGS_MODULE=babyshop.settings
ENV DJANGO_DEBUG=False
ENV DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1
ENV SQLITE_PATH=/data/db.sqlite3

WORKDIR /app

# Run the application as a dedicated non-root user.
RUN addgroup --system app && adduser --system --ingroup app app

# Install dependencies before copying the app to improve Docker layer caching.
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

COPY babyshop_app/ .

# Static files are collected during the image build.
# Database migrations are applied at container startup against the runtime DB.
RUN mkdir -p /data \
    && python manage.py collectstatic --noinput \
    && chown -R app:app /app /data

USER app

EXPOSE 8025

CMD ["sh", "-c", "python manage.py migrate --noinput && gunicorn --bind 0.0.0.0:8025 babyshop.wsgi:application"]

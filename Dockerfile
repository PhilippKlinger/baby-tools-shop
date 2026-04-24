FROM python:3.12-slim

# Keep the container logs readable and avoid writing Python cache files.
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Run the application as a dedicated non-root user.
RUN addgroup --system app && adduser --system --ingroup app app

# Install dependencies before copying the app to improve Docker layer caching.
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

COPY babyshop_app/ .
COPY entrypoint.sh /entrypoint.sh

# Static files are collected during the image build.
# Database migrations are applied at container startup against the runtime DB.
RUN mkdir -p /data \
    && python manage.py collectstatic --noinput \
    && chown -R app:app /app /data /entrypoint.sh

USER app

EXPOSE 8025

ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["gunicorn", "--bind", "0.0.0.0:8025", "babyshop.wsgi:application"]

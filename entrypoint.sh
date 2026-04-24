#!/bin/sh
set -eu

DB_PATH="${SQLITE_PATH:-/data/db.sqlite3}"
DB_DIR="$(dirname "${DB_PATH}")"

echo "Starting Baby Tools Shop container..."
echo "Checking SQLite path: ${DB_PATH}"

mkdir -p "${DB_DIR}"

if [ ! -w "${DB_DIR}" ]; then
  echo "Database directory is not writable: ${DB_DIR}" >&2
  exit 1
fi

python -c "import os, sqlite3; path = os.environ['SQLITE_PATH']; conn = sqlite3.connect(path); conn.execute('SELECT 1'); conn.close()"

echo "Applying database migrations..."
python manage.py migrate --noinput

echo "Starting application process..."
exec "$@"

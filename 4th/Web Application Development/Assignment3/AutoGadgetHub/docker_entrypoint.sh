#!/bin/sh
set -ex

# Move to application directory
cd /app

# Run database migrations
python manage.py migrate --noinput

# Create Admin User (only if not exists)
if [ -n "$DJANGO_SUPERUSER_EMAIL" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ]; then
  echo "Creating superuser..."
  python manage.py createsuperuser \
    --noinput \
    --email "$DJANGO_SUPERUSER_EMAIL" || true
fi

# Collect static files (if needed for production)
python manage.py collectstatic --noinput || true

# Start Django development server
python manage.py runserver 0.0.0.0:8000
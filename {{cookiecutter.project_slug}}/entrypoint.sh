#!/usr/bin/env bash

DEFAULT_APP_PORT="8000"
DEFAULT_APP_HOST="0.0.0.0"
DEFAULT_APP_GUNICORN_USE="service.wsgi:application"

if command -v nproc > /dev/null; then
    DEFAULT_APP_GUNICORN_WORKERS=$(nproc) || exit 1
else
    DEFAULT_APP_GUNICORN_WORKERS=$(sysctl -n hw.physicalcpu) || exit 1
fi

APP_PORT="${APP_PORT:-$DEFAULT_APP_PORT}"
APP_HOST="${APP_HOST:-$DEFAULT_APP_HOST}"
APP_GUNICORN_USE="${APP_GUNICORN_USE:-$DEFAULT_APP_GUNICORN_USE}"
APP_GUNICORN_WORKERS="${APP_GUNICORN_WORKERS:-$DEFAULT_APP_GUNICORN_WORKERS}"

PROG_NAME=$(basename "$0")

display_help() {
    printf "\n"
    printf "Usage: %s <subcommand> [options]\n\n" "$PROG_NAME"
    printf "Subcommands:\n"
    printf "    migrate                 Run migrations\n"
    printf "    collectstatic           Collect Static Files and exit\n"
    printf "    createsuperuser         Create default super admin user with login 'admin' and password='admin' and exit\n"
    printf "    django                  Run any django command and exit\n"
    printf "    celery                  Run Celery worker\n"
    printf "    serve [gunicorn_use]    Run Gunicorn with [gunicorn_use] or the default wsgi/asgi APP_GUNICORN_USE\n"
    printf "    devserver               Run Django's development server\n"
    printf "\n"
    printf "For help with each subcommand run:\n"
    printf "%s <subcommand> -h|--help\n\n" "$PROG_NAME"
}

run_migrate() {
    django-admin createcachetable || exit 1
    django-admin migrate --noinput || exit 1
}

run_collectstatic() {
    django-admin collectstatic --noinput || exit 1
}

run_createsuperuser() {
    echo "from django.contrib.auth import get_user_model; bool(get_user_model().objects.filter(username='admin').count()) or get_user_model().objects.create_superuser('admin', 'admin@example.com', 'admin')" | django-admin shell || exit 1
}

run_django() {
    django-admin "$@" || exit 1
}

run_celery() {
    rm -f /tmp/celeryd.pid || true
    celery "$APP_CELERY" || exit 1
}

run_serve() {

    # Override APP_GUNICORN_USE if specified
    APP_GUNICORN_USE="${1:-$APP_GUNICORN_USE}"

    printf "Collecting static files: %s\n" "$APP_GUNICORN_USE"
    run_collectstatic || exit 1
    printf "Gunicorn running: %s\n" "$APP_GUNICORN_USE"
    gunicorn -b "$APP_HOST:$APP_PORT" -c /home/app/config/gunicorn.conf.py -w "$APP_GUNICORN_WORKERS" "$APP_GUNICORN_USE" || exit 1
}

run_devserver(){
    django-admin runserver ${APP_HOST}:${APP_PORT}
}


SUBCOMMAND="${1//-/_}"
shift

if [[ -z "$SUBCOMMAND" ]]; then
    display_help
    exit 1
fi

if declare -f "run_$SUBCOMMAND" > /dev/null; then
    "run_$SUBCOMMAND" "$@"
else
    printf "'%s' is not a known command.\n" "$SUBCOMMAND"
    printf "Run '%s --help' for a list of known commands.\n" "$PROG_NAME"
    exit 1
fi

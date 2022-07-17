#!/usr/bin/env sh
set -e

if [ "$(printf %c "$1")" = '-' ]; then
  set -- php /opt/phpdox/phpdox "$@"
elif [ "$1" = "/opt/phpdox/phpdox" ]; then
  set -- php "$@"
elif [ "$1" = "phpdox" ]; then
  set -- php /opt/phpdox/"$@"
fi

exec "$@"
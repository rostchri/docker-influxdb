#!/bin/sh
set -e

# ensure the following environment variables are set. exit script and container if not set.
#test $backend_host
#test $load_balancer_domain
#test $app_servers

# run confd
export CONFD_OPTIONS=${CONFD_OPTIONS:--backend env}
/usr/local/bin/confd -onetime $CONFD_OPTIONS

exec "$@"

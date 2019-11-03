#!/bin/bash
set -e;

compose="docker-compose";

get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     $( cd -P "$( dirname "$SOURCE" )" )
     pwd
}

_COMPOSE_DIR="$(get_script_dir)"

if [ ! -f "${_COMPOSE_DIR}/target.source" ]; then
    echo "No source file found at ${_COMPOSE_DIR}/target.source";
    echo "Try running: ./setup.sh";
    echo "Quiting."
    exit 1;
fi

source "${_COMPOSE_DIR}/target.source";

env="${1}"

shift ;

if [[ ${#env} -lt 3 ]]; then
    echo "please pass the environment type: compose.sh [env] [args]"
fi

if [ ! -f "${COMPOSE_DIR}/docker-compose.${env}.yml" ]; then
     echo "No compose file found: ${COMPOSE_DIR}/docker-compose.${env}.yml"
     echo "Please create the appropriate compose file or use a different environment."
     exit 1;
fi

compose="$compose -f docker-compose.${env}.yml"

export COMPOSE_ENV="$env";

if [ "$1" == "fresh" ]; then 
     $compose down -v && $compose up;
else
     $compose $@;
fi
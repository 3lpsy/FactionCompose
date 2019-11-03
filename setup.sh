#!/bin/bash
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
# first see if they passed in an argument as directory
_FACTION_DIR="";

_DEFAULT_COMPOSE_DIR="$(get_script_dir)"
_COMPOSE_DIR=${COMPOSE_DIR:-$_DEFAULT_COMPOSE_DIR}

if [ -f "${_COMPOSE_DIR}/env.source" ]; then
    echo "Sourcing: ${_COMPOSE_DIR}/env.source";
    source ${_COMPOSE_DIR}/env.source;
fi

if [ ${#1} -gt 0 ]; then
    _FACTION_DIR="$1";
elif [ ${#FACTION_DIR} -lt 0 ]; then 
    _FACTION_DIR="$FACTION_DIR";
else
    _FACTION_DIR="$(dirname ${_COMPOSE_DIR})"
fi

echo "Faction Directory: $_FACTION_DIR";

if [ ! -d "$_FACTION_DIR" ]; then 
    echo "Making $_FACTION_DIR";
    mkdir -p $_FACTION_DIR;
fi

_REPO_OWNER=${REPO_OWNER:-factionc2}
_REPO_BASE_URL="${REPO_BASE_URL:-https://github.com/${_REPO_OWNER}}";
_REPO_PREFIX="${REPO_PREFIX}";
_REPO_BRANCH="${REPO_BRANCH:-master}";

function setup_repo () {
    repo="$1";
    echo "Setting Up Repo: $repo";
    repo_source="${_REPO_BASE_URL}/${_REPO_PREFIX}${repo}";
    repo_dest="${_FACTION_DIR}/$repo";
    echo "Repo Source: $repo_source"
    echo "Repo Destination: $repo_dest";
    echo "Repo Branch: ${_REPO_BRANCH}";
    if [ ! -d "${repo_dest}/.git" ]; then 
        echo "Cloning Repo...";
        git clone -b "$_REPO_BRANCH" "$repo_source" "$repo_dest";
    else
        echo "Destination already exists. Skipping..";
    fi
}

echo "";
echo "Setting Up Repos...";
echo "";
for repo in API Console Core Faction.Common Build-Service-Dotnet; do
    setup_repo ${repo}
    echo "";
done

echo "Repo cloning complete..."
echo ""

echo "Creating source target at: ${_COMPOSE_DIR}/target.source";
echo "export FACTION_DIR=\"${_FACTION_DIR}\"" > "${_COMPOSE_DIR}/target.source";
echo "export COMPOSE_DIR=\"${_COMPOSE_DIR}\"" >> "${_COMPOSE_DIR}/target.source";

echo "You can now run docker composer with: compose.sh [env] [compose options]";

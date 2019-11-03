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

function setup_repo () {
    repo="$1";
    echo "Setting Up Repo: $repo";
    _default_repo_owner="factionc2"
    if [ "$repo" == "Maurader" ]; then 
        _default_repo_owner="maraudershell";
    fi
    _repo_owner=${REPO_OWNER:-$_default_repo_owner}
    _repo_prefix="${REPO_PREFIX}";
    _repo_branch="${REPO_BRANCH:-master}";
    _repo_base_url="${REPO_BASE_URL:-https://github.com/${_repo_owner}}";

    repo_source="${_repo_base_url}/${_repo_prefix}${repo}";
    repo_dest="${_FACTION_DIR}/$repo";

    echo "Repo Source: $repo_source"
    echo "Repo Destination: $repo_dest";
    echo "Repo Branch: ${_repo_branch}";
    if [ ! -d "${repo_dest}/.git" ]; then 
        echo "Cloning Repo...";
        git clone -b "$_repo_branch" "$repo_source" "$repo_dest";
    else
        echo "Destination already exists. Skipping..";
    fi
}

echo "";
echo "Setting Up Repos...";
echo "";
for repo in API Console Core Faction.Common Build-Service-Dotnet Marauder; do
    setup_repo ${repo}
    echo "";
done

echo "Repo cloning complete..."
echo ""

echo "Creating source target at: ${_COMPOSE_DIR}/target.source";
echo "export FACTION_DIR=\"${_FACTION_DIR}\"" > "${_COMPOSE_DIR}/target.source";
echo "export COMPOSE_DIR=\"${_COMPOSE_DIR}\"" >> "${_COMPOSE_DIR}/target.source";

echo "You can now run docker composer with: compose.sh [env] [compose options]";

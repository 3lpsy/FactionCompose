# About

This is a simple Compose project for managing and starting FactionC2 services. It's currently aimed at development and not delopment. The setup.sh script can be used for easy cloning and setting up new environments for testing. The compose.sh is a simple wrapper to allow for customized file locations. If you want to skip the setup and already have the repos cloned you can just do the following to get started manually:

```
$ cp target.source.example target.source
# configure the values appropriately
# don't run setup.sh if doing this
```

## Developing

The goal of this project is to create a seamless development environment where changes to files on hosts are automatically propagated to running services inside the container. For example, if you change the API code, gunicorn should refresh. If you change the Core code, dotnet will restart the service. For the Console code, you have to run 'npm run watchdev' within the Console directory in another console, but otherwise, it'll update.

For this reason, the dev compose project makes heavy use of volumes. You will want to familiarze yourself with what volumes are being used and the related Dockerfiles.

## Setup

**Please run from inside the Compose directory**

If you want to customize your setup without specifying the options on the CLI, you can do the following:

```
$ cp env.source.example env.source
```

Next, open env.source in a text editor and modify or remove the relevant variables.

By default, it will assume the parent of the current directory is the target (FACTION_DIR). You can Specify a target directory to clone repos into with the following:

```
# using environment variables
$ FACTION_DIR=/home/youruser/faction ./setup.sh

# using an argument
$ ./setup.sh /home/youruser/faction
```

If you have all the branches forked, you can clone them instead.

```
$ REPO_OWNER=3lpsy ./setup.sh;
```

If also added a prefix such as "Faction" to all your repo names, you configure that too. These are the commands that I run:

```
$ mkdir -p ~/Development/factionc2;
$ git clone git@github.com:3lpsy/FactionCompose.git ~/Development/factionc2/Compose;
$ cd ~/Development/factionc2/Compose;
$ REPO_BRANCH=development REPO_PREFIX=Faction REPO_OWNER=3lpsy ./setup.sh;
# setup will automatically assume that ~/Development/factionc2 is the FACTION_DIR
```

You can read env.source.example for additional information about options.

## Running

The compose.sh script will pass all options after the env to the docker-compose command. The docker-compose.ENV_NAME.yml file has to exist.

```
FactionCompose: A Compose Project for FactionC2
Usage:
    $ ./compose.sh [env] [compose options]

Examples:
    $ ./compose.sh dev build --no-cache
    $ ./compose.sh dev down -v
    $ ./compose.sh dev up
    $ ./compose.sh dev fresh
```

There is a special command called fresh which is the equivalent of running:

```
$ ./compose.sh dev down -v && ./compose.sh dev up
```

### Firewalld

```
$ firewall-cmd --permanent --zone=trusted --add-interface=factionpub0
# probably optional
$ firewall-cmd --permanent --zone=trusted --add-interface=docker0
```

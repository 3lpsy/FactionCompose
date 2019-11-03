
## Setup

**Please run from inside the Compose directory**

If you want to customize your setup without specifying the options on the CLI, you can do the following: 

```
$ cp env.source.example env.source
```

Next, open env.source in a text editor and modify or remove the relevant variables.

By default, it will assume the parent of the current directory is the target. You can Specify a target directory to clone repos into with the following:
```
# using environment variables
$ FACTION_DIR=/home/youruser/faction ./setup.sh

# using an argument
$ ./setup.sh /home/youruser/faction
```

If you have all the branches forked, you can clone them with setup:

```
$ REPO_OWNER=3lpsy ./setup.sh;
$ REPO_BRANCH=development REPO_PREFIX=Faction REPO_OWNER=3lpsy ./setup.sh;
```

You can read env.source.example for additional information about options.

## Running

The compose.sh script will pass all options after the env to the docker-compose command.

```
$ ./compose.sh [env] [compose options]
$ ./compose.sh dev build --no-cache
$ ./compose.sh dev down -v 
$ ./compose.sh dev up
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

# Skirmish

[![Amber Framework](https://img.shields.io/badge/using-amber_framework-orange.svg)](https://amberframework.org)

This is a project written using [Amber](https://amberframework.org). Enjoy!

## Getting Started

These instructions will get a copy of this project running on your machine for development and testing purposes.

## Prerequisites

This project requires [Crystal](https://crystal-lang.org/)
The version of Crystal used is defined inside `.crystal-version`.
I'd recommend using [crenv](https://github.com/pine/crenv) to install the current version of Crystal, which is as simple as the following.
```
crenv install
```

There are also some other dependencies required for some extensions of Crystal and Amber, as well as PostgresQL.
```
sudo apt install -y postgresql libssl-dev libxml2-dev libyaml-dev libgmp-dev libreadline-dev libevent-dev libsqlite3-dev
```

### Postgres
Unless you've used Postgres before, or know your way around configuring it already, you'll probably want to follow this quick guide to setting up users for development.
```
# start a session as the postgres user
sudo su - postgres

# create a user named skirmish_development
createuser skirmish

# optionally create a user to login to postgres yourself
createuser <username> --pwprompt

# exit the session as postgres
exit
```

To change the authentication with postgres to use a simple password 'trust' authentication method, we'll need to edit the `pg_hba.conf` file.
```
sudo vim /etc/postgresql/9.5/main/pg_hba.conf
```
Replace `md5` with `trust` on the lines for local connections
```
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
```

And finally, ensure the settings for postgres have been applied by restarting the service
```
sudo service postgresql restart
```

## Development

To start your Amber server:

```
shards install                  # install dependencies
shards build                    # build executable binaries
bin/sam db:create @ db:migrate  # create the database and bring it up to speed
bin/amber db seed               # optionally seed the database with some mock data
bin/amber watch                 # start the server and watch for file changes
```

Now you can visit http://localhost:3000/ from your browser.

## Tests

To run the test suite:

```
crystal spec
```

## Contributing

1. Fork it
2. Create your feature branch ( `git checkout -b my-new-feature` )
3. Commit your changes ( `git commit -am 'Add some feature'` )
4. Push to the branch ( `git push origin my-new-feature` )
5. Create a new Pull Request

## Contributors

- [your-github-user](https://github.com/your-github-user) Jordane Lew - creator, maintainer

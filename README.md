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

## Development

To start your Amber server:

1. Install dependencies with `shards install`
2. Build executables with `shards build`
3. Create and migrate your database with `bin/amber db create migrate`. Also see [creating the database](https://docs.amberframework.org/amber/guides/create-new-app#creating-the-database).
4. Start Amber server with `bin/amber watch`

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

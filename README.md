# Booky (API)
[![CircleCI](https://circleci.com/gh/Warshavski/booky-api/tree/master.svg?style=svg)](https://circleci.com/gh/Warshavski/booky-api/tree/master)

Books management application (API)

## Setting up

#### Requirements

- Ruby 2.5.3
- Rails 5.1.6
- Postgresql => 9.5
- Redis 2.8+

#### Installation

**Clone the repo.**
```bash
git clone https://github.com/warshavski/booky-api.git
```

**cd into the directory and install the reqirements.**
```bash
cd booky-api && bundle install
```

**set up config files**
```bash
mv config/secrets.ci.yml config/secrets.yml
mv config/database.ci.yml config/database.yml
mv config/booky.ci.yml config/booky.yml
```

**set up the database**
```bash
rake db:create 
rake db:migrate 
rake db:seed
```

**Start the server**
```bash
rails s
```

#### Running tests

Running all tests.
```bash
bundle exec rspec
```

Running a specific test file
```bash
bundle exec rspec ./spec/path/to/file
```

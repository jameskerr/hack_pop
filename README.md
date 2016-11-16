# HackPop

[![Build Status](https://travis-ci.org/jameskerr/hack_pop.svg?branch=master)](https://travis-ci.org/jameskerr/hack_pop)

## Dependencies

```
mix deps.get
```

## Development DB

Provided you have postgres and the postgres command line tools installed, these commands will get your database up.

```
createdb hack_pop_repo
mix ecto.migrate
```

## Running the server

```
mix run --no-halt
```

## Running the console

```
iex -S mix
```

## Running Tests

```
mix test
```

## Servers

**Build**

* `54.165.31.207`
* `ec2-54-165-31-207.compute-1.amazonaws.com`

**Staging**

* `54.152.78.27`
* `ec2-54-152-78-27.compute-1.amazonaws.com`

**Production**

* `52.201.223.136`
* `ec2-52-201-223-136.compute-1.amazonaws.com`


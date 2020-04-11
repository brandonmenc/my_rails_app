A starting point for Rails development.

## Instructions

You'll probably want to clone the app and rename it:

```
./clone ~/src/new_app
```

This will clone the repo locally with `git` into the directory `~/src/new_app`
and it will rename the app `new_app`. It will also create two branches: `parent`
and `master`, with `master` branching off of `parent`. Do all of your work in
`master` as you normally would. Pull changes from the template into `parent`
and rebase `master` on `parent` as needed.

First time run:

```
make
```

This will build everything and start it up. After this initial build, you can
start and stop at will:

```
make stop
make start
```

The application code is mounted into the container from your local machine so
you don't need to rebuild the docker image every time you make a change, but
if you want to rebuild the docker image:

```
make build
make restart
```

If you install new gems:

```
make bundle-install
```

or npm packages:

```
make yarn-install
```

Drop the db and recreate it:

```
make db-drop
make db-create
```

Get a Rails console:

```
make console
```

Log into a shell:

```
make login
```

If you messed everything up and need to remake everything from scratch:

```
make nuke
make
```

## Overriding ports and other environment variables

Look in [.env](.env)

## MailCatcher

The app is configured to send all emails in development mode through an
instance of [MailCatcher](https://mailcatcher.me) that is started along with
the application when using docker-compose or the Makefile.

You can visit [http://localhost:1080](http://localhost:1080) to view the emails.

# Contributing

If you happened to come across a bug or want to suggest a feature, feel free to [say something](https://github.com/avo-hq/avo/issues/new)!

If you'd like to contribute code, the steps below will help you get up and running.

## Elements naming

`Resource` or `@resource` is an instantiated `Avo::Resource` object.

`resource_name`: Pluralized, machine name, snake cased version of a resource. Ex: `resource_name` for `/avo/resources/team_memberships` path is going to be `TeamMemberships`.

`Model` or `@model`: Active Record `Model` object.

Since v `1.20` (Jan 2022) we started to change the `model` name with `record` where it fits. The `model` should be the class (ex: `User`, `Comment`, etc.) and `record` will be the instantiated model class with data (ex: `user` is a record when doing `user = User.find(1)`).

## Forking & branches

Please fork Avo and create a descriptive branch for your feature or fix. We usually use the `feature/`, `chore/`, or `fix/` branch prefixes. This way, the PR gets automatically labelled.

## Getting your local environment set up

NOTE: We're using `docker-compose` to run Postgres. While we find this incredibly helpful, it's not a requirement, but you'll have to BYOD (Bring Your Own Database).

Once you pull the code down to your machine, modify `spec/dummy/config/database.yml` as appropriate to your environment (no changes needed if you're using Docker).  Do not commit these changes.  From here, running `bin/init` will get you up-and-running.

# Local development

## Running the dummy app

From the root directory you can run `bin/dev` and that will start a foreman process for the rails server, jsbundling and cssbundling. Then, navigate to `localhost:3030` and enjoy the app.

## Seeding the database for local development

Run `AVO_ADMIN_PASSWORD=secret bin/rails db:seed` to seed the database with dummy data and create a user for yourself with the email `avo@avohq.io` and password `secret`.

## Using your fork from another project

You may want to evaluate your changes in the context of a real project.  To do so without publishing your own version of the gem, follow these instructions.

In the other project, change the `Gemfile` entry for `avo` to point to your local clone of this repo.  For example:

```ruby
gem 'avo', path: '../avo'
```

Avo's assets will not show up by default, resulting in 404 errors on `/avo-assets/avo.js` and `/avo-assets/avo.css`. To avoid this, you need to compile the asset bundles, and symlink them into `public/avo-assets`.

Create symlinks for compiled assets into public.  You'll only need to do this once.

```bash
# `cd` into the root directory of this project.
ln -sf $(pwd)/app/assets/builds/avo.js public/avo-assets/avo.js
ln -sf $(pwd)/app/assets/builds/avo.css public/avo-assets/avo.css
```

After that, you'll need to compile the asset bundles any time you make changes to the JS or CSS code:

```bash
yarn build
```

# Running tests

When running tests you have two options. 1. running them on your local database or 2. to use a database in a docker environment.

Run the migration script `bin/rails db:migrate`. Now you'll be able to run the test scripts below:

## Running tests with local database

Copy the `.env.test.sample` (`cp spec/dummy/.env.test.sample spec/dummy/.env.test`) and update it with the proper credentials for your local database. Run the migration script `bin/rails db:migrate`. Now you'll be able to run the test scripts below:

We've set up a few helpers to get you going:

- Run all tests (slow): `bin/test`
- Run unit tests (fast): `bin/test unit`
- Run system tests (slow): `bin/test system`
- Run a particular spec file/test (fast): `bin/test ./spec/features/hq_spec.rb`

## Running tests using the docker container

You may want to run the tests on your docker container. To do that, update your `.env.test` file with valid credentials for the docker setup like below. We do provide a `docker-compose.yml` file for the testing DB, so you can do `docker compose up`, but that's not our preferred method and you might need to do some tweaks. You'll then be able to run the migration script and the testing commands.

```
POSTGRES_HOST=localhost
POSTGRES_PORT=5433
POSTGRES_USERNAME=postgres
POSTGRES_PASSWORD=
```

# Release details

## Update appraisal gemfiles

We use [appraisal](https://github.com/thoughtbot/appraisal) to run tests against multiple versions of rails. When the gemfile gets updated you must also run `bundle exec appraisal install` to update the versioned ones and commit them to the repo.

# Custom JS

In order to be able to test the custom Stimulus integration we need to have some kind of JS content injected in the dummy app. We also need not to have that content present in every Avo installation. That's why we ejected the `_head.html.erb` partial that loads the `avo_custom.js` file from the engine's `build` directory. The build directory is not commited to git so we're all good on that. In order to have that file built and watche we added a `cjs` (short for `custom-js`) process in the `Procfile.dev` (which is used only in development).

# Misc

## Annotate models

To keep track of the schema structure for the models run `annotate --models --exclude fixtures` in the dummy app.

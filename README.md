I migrate [![Build Status](https://travis-ci.org/ifeelgoods/imigrate.svg?branch=master)](https://travis-ci.org/ifeelgoods/imigrate)
====

Run Rails data migrations.

Data migrations are stored in db/data. They act like schema
migrations, except they should be reserved for data migrations.

Problems this gem is solving :
----------------------

### Migrating data using model which has attribute not created in database

Example:

* Migration adding a new attribute to the model User.
* Migration migrating data to populate User models.
* Migration adding a new attribute to the model User.

The second migration will break because the model User now use a new attribute
which will not be created in the database at this time.

Using this gem, you can now run data migrations after executing all schema migrations.

### Using a staging environment using the production database

In this case when we deploy to production, we need to run again migration
of the data because models in production was still not using the last schema.

Example:
 When adding a new attribute to the model user, while begin in staging,
 the production will not create the user as it does not know about it.

Using this gem, you can specify a prefix (`env_prefix`) for the version registered in
the data versioning table. (example: 'staging' or 'production')

### Ensure migration are runnable multiple times

As run migration on staging and in production, this mean migration should
runnable multiple times agains the same database. You can simplify call multiple
times `rake db:data:migrate` to verify migrations are correct.


What's it do?
-------------

Data migrations are stored in db/data. They act like schema
migrations, except they should be reserved for data migrations.
Running any of the provided rake tasks also
creates a data schema table to mirror the usual schema migrations
table to track all the goodness.

Data migrations can be created at the same time as schema migrations,
or independently.

Compatibility
--------------------

Imigrate is tested on Rails 4.1/4.2 and Ruby 1.9.3/2.0/2.1/2.2

Installation
------------
Add the gem to your project

    # Gemfile
    gem 'imigrate'

Then `bundle install` and you are ready to go.

So you know, when you use one of the provide rake tasks, a table
called 'data_migrations' will be created in your database. This
is to mirror the way the standard 'db' rake tasks work.

Usage
-----

### Generating Migrations

You can generate a data migration as you would a schema migration:

    rails g data_migration add_this_to_that

### Specify the a prefix to the data versioning table

    Imigrate.env_prefix = 'staging'

### Rake Tasks

    $> rake -T data
    rake db:migrate:all                  # Migrate schema migration and after data migrations (options: VERSION=x, VERBOSE=false)
    rake db:data:forward                 # Pushes the schema to the next version (specify steps w/ STEP=n)
    rake db:data:migrate                 # Migrate data migrations (options: VERSION=x, VERBOSE=false)
    rake db:data:migrate:down            # Runs the "down" for a given migration VERSION
    rake db:data:migrate:redo            # Rollbacks the database one migration and re migrate up (options: STEP=x, VERSIO...
    rake db:data:migrate:status          # Display status of data migrations
    rake db:data:migrate:up              # Runs the "up" for a given migration VERSION
    rake db:data:rollback                # Rolls the schema back to the previous version (specify steps w/ STEP=n)
    rake db:data:version                 # Retrieves the current schema version number for data migrations


Credits
-------

Inspired from https://github.com/ajvargo/data-migrate


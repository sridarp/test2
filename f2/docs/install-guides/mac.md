# Mac (OSX 10.10) Installation

This guide will walk you through how to install and run Jellyfish-API on **Mac OS X Mavericks (for Development)**.  Generally, this guide would be used for development purposes, but you can run it in production as well.  This will set up the app to run on port 3000. If you want it to run on a different port, you will need to use Apache or Nginx (this doc will not cover that).

## Workspace Setup

##### Install Command Line Tools
Compiling some tools will require that Xcode is installed. We can do that from the command line with the following command.

```shell
xcode-select --install
```

##### Install thoughtbot Laptop Tools
This will install pretty much everything that is needed by Jellyfish (including rbenv, PostgreSQL, etc.)

```shell
curl --remote-name https://raw.githubusercontent.com/thoughtbot/laptop/master/mac
sh mac 2>&1 | tee ~/laptop.log
```

_**Important: Do NOT install rvm, as that will cause conflict with rbenv**_

##### Get thoughtbot dotFiles
```shell
cd ~
git clone git://github.com/thoughtbot/dotfiles.git
env RCRC=$HOME/dotfiles/rcrc rcup
```

##### Clone the Repo
The following command will create a new directory and place the latest code into it.

```shell
git clone https://github.com/boozallen/projectjellyfish.git
```

## Environment Setup
To avoid having to add environment variables we can use a `.env` file locally for development.

_You're welcome to set the variables in your environment but it's recommended to use the file method._

##### Create the .env file
```shell
cd projectjellyfish
touch .env
```

##### Contents of .env file
```
DATABASE_URL=postgres://YOUR_LOCAL_USERNAME:@localhost:5432/jellyfish_development
```

After you have pasted the contents into the `.env` file change `YOUR_LOCAL_USERNAME` to match that of your local account name. If you're unsure of what that name is you can use `whoami` to see it.

## Build the Application

_**From this point on it is assumed you are executing commands within the api directory.**_

##### Ensure tools have been installed
```shell
gem install bundler
```

##### Install dependencies
```shell
bundle install
```

##### Set Environment (OPTIONAL)
Run the following rake commands to set the environment type (development, test, production) and compile assets for that environment. 
```shell
# Where ENVIRONMENT can be development, test, production
RAILS_ENV= ENVIRONMENT
# rake assets:clobber can be used to clear out stale assets
rake assets:precompile
```

## Create the Database
Running this CLI command will create the database for you in PostgreSQL.

```
rake db:create
```

##### Populate the Database
Run the following rake commands. Please note that this
rake task does not create the database or the database user (those will need
to be created based on the DB you are using)

```
rake db:setup
rake db:seed
```

##### Seed with sample data (OPTIONAL)
You only need to run `rake setup:demo` if you are wanting sample data (useful for development).  

```shell
rake setup:demo
```

## Start Server

```shell
rails s
```

## Upkeep Rake Tasks

The following rake commands need to be executed to maintain Jellyfish.

```shell
# Updates the budgets for projects
rake upkeep:update_budgets
# Pull down AWS pricing (not used at the moment)
rake upkeep:get_aws_od_pricing
# Get the status of VM's from ManageIQ
rake upkeep:poll_miq_vms
# Run the delayed job workers (this is what processes the orders to the various systems
rake jobs:work
```

Copyright 2016 Booz Allen Hamilton

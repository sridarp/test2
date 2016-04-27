# RHEL Installation

This guide will walk you through how to install and run Jellyfish on a fresh **Red Hat Enterprise Linux** 7.x (tested up to RHEL 7.1).  
Other distros should work fine, but only RHEL / CenOS 7.x are supported

## System Prep

##### Update System
Update your system (optional, but always a good idea).

```shell
sudo yum update
```

##### Create a Jellyfish User
Note: It is a bad idea to run the application with root privileges.

```shell
sudo useradd jellyfish
```

##### Install Pre-Requisites

```shell
sudo yum -y install git
sudo yum -y install gcc-c++ patch readline readline-devel zlib zlib-devel
sudo yum -y install libyaml-devel libffi-devel openssl-devel make
sudo yum -y install bzip2 autoconf automake libtool bison 
sudo yum -y install sqlite-devel libffi-devel openssl-devel
sudo yum -y install ntp
```

##### Install PostgreSQL Server

Please install PostgreSQL (9.4+) via [PostgreSQL's directions on their website](https://wiki.postgresql.org/wiki/YUM_Installation)

You will need to install all of the following packages

```shell
sudo yum -y install postgresql94-server
sudo yum -y install postgresql94-devel
sudo yum -y install postgresql94-contrib
```

##### Initialize DB on RHEL 7.x
```shell
sudo /usr/pgsql-9.4/bin/postgresql94-setup initdb
```

##### Start PostgreSQL Server and add as a service
```shell
sudo systemctl start postgresql-9.4.service
sudo systemctl enable postgresql-9.4.service
```

## Configure PostgreSQL Server
This section covers how to get PostgreSQL setup.

##### Change to the postgres user
```shell
sudo su - postgres
```

##### Connect to the database server
```shell
psql template1
```

##### Add the jellyfish database user
Replace `JELLYFISH_DB_PASSWORD` with a secure password before executing the following command.

_**template=#** is the prompt and is not part of the command._

```
template1=# CREATE USER jellyfish WITH PASSWORD 'JELLYFISH_DB_PASSWORD';
```

##### Grant SUPERUSER to jellyfish user
```
template1=# ALTER USER jellyfish WITH SUPERUSER;
```

##### Create the database for jellyfish to use
```
template1=# CREATE DATABASE jellyfish_production;
```

##### Grant the jellyfish user access to the jellyfish_production database
```
template1=# GRANT ALL PRIVILEGES ON DATABASE jellyfish_production to jellyfish;
```

##### Quit psql
```
\q
```

##### Exit out of the Postgres user
```
exit
```

##### Edit /var/lib/pgsql/9.4/data/pg_hba.conf
```
sudo vi /var/lib/pgsql/9.4/data/pg_hba.conf
```

Change the following (change '`ident`' to '`md5`'):

```
# IPv4 local connections:
host    all             all             127.0.0.1/32            ident
# IPv6 local connections:
host    all             all             ::1/128                 ident
```
to

```
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
```

#### Restart PostgreSQL
```shell
sudo systemctl restart postgresql-9.4.service
```


#### Change to Jellyfish System Users
```
sudo su - jellyfish
```

#### Install rbenv
Install rbenv as per the [rbenv install guide](https://github.com/sstephenson/rbenv)

#### Install rbenv-build

Install ruby-build as per the [ruby-build install guide](https://github.com/sstephenson/ruby-build)

#### Check out Latest Code

```
cd /home/jellyfish
git clone https://github.com/projectjellyfish/api.git
```

#### Install Ruby
Please install the version of Ruby that is indicated in .ruby-version in the Jellyfish code, and set that as the global version

```
rbenv install "$(cat /home/jellyfish/api/.ruby-version)"
rbenv global "$(cat /home/jellyfish/api/.ruby-version)"
```

#### Install bundler
```
gem install bundler
```

#### Install pg gem
```
gem install pg -v '0.18.3' -- --with-pg-config=/usr/pgsql-9.4/bin/pg_config
```

##### Create Environment Variables

Jellyfish is configured using environment variables.  You can either use "real"
enviromental variables, or use the included dotEnv gem.  It is _**highly**_ 
recommended that you use "real" environment variables in a production 
environment.

Pick one or the other, you CANNOT use both; "real" enviromental variables will
overide the "dotEnv" variables.

##### Option 1 ("Real" Enviromental Variables)

You can get a list of the configuration options from the .env.sample along with
a description of what it does.

```
echo 'export DATABASE_URL=postgres://jellyfish:JELLYFISH_DB_PASSWORD@localhost:5432/jellyfish_production' >> ~/.bash_profile
echo 'export RAILS_ENV=test' >> ~/.bash_profile
```

##### Option 2 ("dotEnv" Enviromental Variables)

Rename the .env.sample file to .env and setup the options in that file.

```shell
mv .env.sample .env
```

## Build the UX

_**From this point on it is assumed you are executing commands within the api directory.**_

##### Install all needed gems

```shell
bundle install
```

##### Populate the Database
Run the following rake commands. Please note that this rake task does not create 
the database or the database user (those will need to be created based on the DB 
you are using)

```shell
rake db:migrate
rake db:seed
```

##### Seed with sample data (OPTIONAL)
You only need to run `rake setup:demo` if you are wanting sample data (useful for development).  

```shell
rake setup:demo
```

The default username and password when using the seed file is:

```
Username: admin@projectjellyfish.org
Password: jellyfish
```


##### Start Server

```shell
rails s
```

##### Setup SSL

If you need to run Jellyfish in a production you should use SSL, please see the 
docs on setting up SSL.

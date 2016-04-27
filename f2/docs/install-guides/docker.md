# Docker Installation

Guide to running API with Docker

## Installing Docker
Please see Docker's installation instructions available here:
https://docs.docker.com/installation/

## Setup

The Dockerfile and docker-compose.yml are the two files that properly configure
Project Jellyfish to run on Docker.  It is highly recommended that you change
the secret keys in the docker-compose.yml file if you are running in production.  
The keys in the file are not secure.

Note: You should use the Docker container boozallen/projectjellyfish:latest

To begin running Project Jellyfish in Docker, check out the code from git.

```
git clone https://github.com/boozallen/projectjellyfish.git
```

Change into that directory, and then type the following:

```
docker-compose up
```

Once the containers are up and running, you will need to populate the database.
To do this, you will need to exec into the running 'web' containers, via this
command

```
docker exec web
```

Once into the container, change into the directory that has the Project
Jellyfish code, and type the following commands:

```
rake db:setup
rake db:seed
rake setup:demo
```

Once this is done successfully, you can disconnect from the container.  At this
point you should be able to login to your Project Jellyfish instance.  Get your
URL by typing:

```
boot2docker ip
```

The application will be running at that returned ip on port 3000.  The default
username and password are:

```
Username: admin@projectjellyfish.org
Password: jellyfish
```

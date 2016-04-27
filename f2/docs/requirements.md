System Requirements
===============

This document outlines system requirements for deploying Project Jellyfish.  
Minimum requirements will largely depend on how servers the system will be
accessing, how much monitoring data is incoming (if you have monitoring
enabled), and how many people are accessing the site via the mobile application
and web application.

### Bare Metal / Traditional Virtual Machine

**Suggested Minimum Configuration (single server)**

* 8 CPU Cores
* 16 GB of RAM
* 500GB of Disk Space

**Suggested Minimum Configuration (Separate DB Server and Web Server)**

Web Server:

* 2 CPU Cores
* 8 GB of RAM
* 40GB of Disk Space

Database (PostgreSQL) Server:

* 4 CPU Cores
* 8 GB of RAM
* 500GB of Disk Space

### Amazon AWS

**Suggested Minimum Configuration (Separate DB Server and Web Server)**

* Web Server: m3.medium
* RDS (PostgreSQL): db.m3.large

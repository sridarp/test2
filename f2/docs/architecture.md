Architecture
============

Project Jellyfish is made up of numerous parts, working in concert to make it as easy to use as possible.



####Jellyfish Core

* The Jellyfish Core, built on the Ruby on Rails framework, combines the API and UX. 
* The API is a fully scalable REST server that powers the Jellyfish UX and Jellyfish Mobile, and is the work horse of Project Jellyfish.
* The UX is an Angular/HTML5 application that provides an andvanced interface for both end-users and administrators.
* For end-users, it acts as a marketplace and self-service portal; for admins, it allows the creation of a catalog of services that they would ike to offer to their end-users.
* _Jellyfish API requires Ruby 2.2.x and PostgreSQL 9.4.x_



####Mobile App

* The app will interface with the Jellyfish Core via the REST API providing basic functionality such as managing rights, accessing the catalog, and monitoring project status.
* While the app cannot do any provisioning of services, it is a great way to manage on the go!



####PostgreSQL Database

* The PostgreSQL Database is where all the data from the API is stored.
* When any command is made by a user, the API makes a call to the database to return the data.



####Configuration Management

* In order to help streamline the deployment and management of the data on the servers that Jellyfish runs on, we use the configuration tool Chef.
* Instead of manually managing our infrastructure environment, Chef automates that management and enables our team to focus on delivering Project Jellyfish.



####Monitoring

* In order to ensure that Jellyfish is properly up and running, we use IT monitoring tools like Sensu and Nagios.
* They monitor the entire Jellyfish ecosystem, and provide us with details to minimize problems that may arise.

# MySQL + Flask Boilerplate Project

This repo contains a boilerplate setup for spinning up 3 Docker containers: 
1. A MySQL 8 container for obvious reasons
1. A Python Flask container to implement a REST API
1. A Local AppSmith Server

## How to setup and start the containers
**Important** - you need Docker Desktop installed

1. Clone this repository.  
1. Create a file named `db_root_password.txt` in the `secrets/` folder and put inside of it the root password for MySQL. 
1. Create a file named `db_password.txt` in the `secrets/` folder and put inside of it the password you want to use for the a non-root user named webapp. 
1. In a terminal or command prompt, navigate to the folder with the `docker-compose.yml` file.  
1. Build the images with `docker compose build`
1. Start the containers with `docker compose up`.  To run in detached mode, run `docker compose up -d`. 
1. Backend will be running on localhost:8001
## How to Connect to MySQL db in DataGrip
1. create new data source
   2. localhost:3200 username: root password: (located in  secrets/db_root_password.txt)

in appsmith > Queries on the left > 
1. GET localhost:4000/p/products
2. connect query to table

API URL:
http://localhost:8001/c/customers
APPSMITH URL:
http://localhost:8080/applications

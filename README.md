# Kelp
## CS3200 Final Project

### Project Overview:
Introducing "Kelp," our innovative platform designed to revolutionize the restaurant review experience. Kelp empowers restaurants to showcase their business by sharing essential information, including operating hours, menus, and locations. Meanwhile, customers can seamlessly rate and review their dining experiences, providing valuable feedback and insights. Health inspectors also have the capability to submit health grades, ensuring transparency and accountability. Moreover, Kelp hosts exciting promotional events, enticing customers to explore new dining establishments and share their feedback on the platform.

In this repo you will find all of the code for the backend of kelp.
If you would like to view the code for the front-end please navigate to the github repository below:
https://github.com/alinageng/kelp_frontend

### How to start this project:
- Open terminal
- Git Clone this repo on your machine
- Make sure to git clone the front end repository (link included above)
- Run `cd kelp`
- Run the command `docker compose build`
- Then run the command `docker compose up -d`
- Once these two commands have been run, navigate to your machine's browser
- Go to http://localhost:8001/re/reviews to verify the backend is running. You should see a Json array of all the reviews on Kelp
- To use the UI, go to http://localhost:8080/applications. You will see kelp_frontend under Apps. Click launch and you should be all set to start using Kelp


PRESENTATION VIDEO:
https://youtu.be/oga2nFuB2rM 


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

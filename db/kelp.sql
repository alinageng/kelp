DROP DATABASE IF EXISTS Kelp;
CREATE DATABASE IF NOT EXISTS Kelp;
USE Kelp;

CREATE TABLE IF NOT EXISTS Customer (
    customer_id int PRIMARY KEY AUTO_INCREMENT,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    email varchar(50) NOT NULL UNIQUE,
    phone int(10),
    member_since datetime DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS KelpAdmin (
    admin_id int PRIMARY KEY AUTO_INCREMENT,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    email varchar(50) NOT NULL UNIQUE,
    phone int(10)
);

CREATE TABLE IF NOT EXISTS Address (
    address_id int PRIMARY KEY AUTO_INCREMENT,
    street varchar(255) NOT NULL,
    city varchar(100) NOT NULL,
    state varchar(50) NOT NULL,
    zip_code int(5) NOT NULL
);

CREATE TABLE IF NOT EXISTS Restaurant (
    restaurant_id int PRIMARY KEY AUTO_INCREMENT,
    restaurant_name varchar(50),
    description text,
    hours text,
    address int,
    FOREIGN KEY (address) REFERENCES  Address (address_id)
    ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS RestaurantOwnerAccount (
    restaurant_owner_id int PRIMARY KEY AUTO_INCREMENT,
    restaurant_id int,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(50) NOT NULL UNIQUE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant (restaurant_id)
    ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS PromotionalEvent (
    promotional_event_id int PRIMARY KEY AUTO_INCREMENT,
    restaurant_id int,
    admin_id int,
    description text,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant (restaurant_id)
    ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (admin_id) REFERENCES KelpAdmin (admin_id)
    ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS HealthInspector (
    inspector_id int PRIMARY KEY AUTO_INCREMENT,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS HealthInspection (
    health_inspection_id int PRIMARY KEY AUTO_INCREMENT,
    inspector_id int,
    restaurant_id int,
    date datetime DEFAULT NOW(),
    grade char NOT NULL,
    FOREIGN KEY (inspector_id) REFERENCES HealthInspector (inspector_id)
    ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant (restaurant_id)
    ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS RestaurantReview (
    restaurant_review_id int PRIMARY KEY AUTO_INCREMENT,
    customer_id int,
    restaurant_id int,
    description text,
    rating tinyint(1) NOT NULL,
    date datetime DEFAULT NOW(),
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id)
    ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (restaurant_id) REFERENCES  Restaurant (restaurant_id)
    ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS MenuItemReview (
    menu_item_review_id int PRIMARY KEY AUTO_INCREMENT,
    menu_item_id int,
    customer_id int,
    restaurant_id int,
    description text,
    rating tinyint(1) NOT NULL,
    date datetime DEFAULT NOW(),
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id)
    ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (restaurant_id) REFERENCES  Restaurant (restaurant_id)
    ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS Menu (
    menu_id int PRIMARY KEY AUTO_INCREMENT,
    restaurant_id int,
    menu_type varchar(25),
    FOREIGN KEY (restaurant_id) REFERENCES  Restaurant (restaurant_id)
    ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS MenuItem (
    menu_item_id int PRIMARY KEY AUTO_INCREMENT,
    menu_id int,
    name varchar(50),
    price int,
    FOREIGN KEY (menu_id) REFERENCES Menu (menu_id)
    ON UPDATE cascade ON DELETE restrict
);
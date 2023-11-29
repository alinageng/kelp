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

INSERT INTO Address VALUES (default, 'Parker Street', 'Boston', 'MA', 02115),
                           (default, '5th Ave', 'New York City', 'NY', 10001);

INSERT INTO Customer VALUES (default, 'Alina', 'Geng', 'geng.a@northeastern.edu', 123456789, default),
                            (default, 'Eden', 'Gugsa', 'gugsa.e@northeastern.edu', 234567891, default);



INSERT INTO  HealthInspector VALUES (default, 'John', 'Smith', 'john.smith@gmail.com'),
                                    (default, 'Sponge', 'Bob', 'sponge.bob@gmail.com');

INSERT INTO KelpAdmin VALUES (default, 'Patrick', 'Star', 'patrick.star@gmail.com', 34567892),
                             (default, 'Squidward', 'Tentacles', 'squidward.tentacles@gmail.com', 45678923);

INSERT INTO Restaurant VALUES (default, 'Cheesecake Factory', 'The Cheesecake Factory is a renowned American restaurant
chain celebrated for its expansive menu featuring over 250 dishes, including pasta, seafood, and steaks. The highlight
is its diverse selection of decadent cheesecakes. The restaurant offers a comfortable yet upscale ambiance, making it a
popular choice for a wide range of occasions. Known for quality ingredients and made-from-scratch cooking,
The Cheesecake Factory provides a delightful dining experience.', '10am - 10pm', 1),
                           (default, 'Gong Cha', 'Gong Cha, a global bubble tea franchise from Taiwan, is celebrated for
its high-quality and customizable drinks. With a diverse menu featuring signature pearls, customers can personalize
their beverages. Known for a modern and vibrant atmosphere, Gong Cha is a popular choice for tea enthusiasts worldwide.',
                            '12pm - 11pm', 2);

INSERT INTO RestaurantOwnerAccount VALUES (default, 1, 'Sandy', 'Cheeks', 'sandy.cheeks@gmail.com'),
                                          (default, 2, 'Mr. Krabs', '', 'mrkrabs@gmail.com');

INSERT INTO RestaurantReview VALUES (default, 6, 1, 'Fantastic experience at The Cheesecake Factory! Delicious Chicken
Alfredo, and the Oreo Dream Extreme Cheesecake was a highlight. Great ambiance and service. Highly recommend!', 5, default),
                                 (default, 5, 2, 'Love Gong Cha! Amazing bubble tea with customizable options. Perfect
pearls, refreshing tea, and a modern vibe. A go-to spot for a great bubble tea experience!', 4, default);


INSERT INTO  HealthInspection VALUES (default, 1, 1, default, 'A'),
                                    (default, 2, 2, default, 'B');

INSERT INTO Menu VALUES (default, 1, 'Entree'),
                        (default, 2, 'Drinks');

INSERT INTO MenuItem VALUES (default, 1, 'Salmon', 23.99),
                            (default, 2, 'Lavender Lemonade', 3.99);

INSERT INTO MenuItemReview VALUES (default, 1, 5, 1, 'Tried the salmon, and it was fantastic! Perfectly cooked with
great seasoning and a delightful presentation. A top choice for seafood lovers!', 4, default),
                               (default, 2, 6, 2, 'Loved the lavender lemonade! Refreshing twist with a subtle floral
note. Perfectly balanced and delicious.', 4, default);

INSERT INTO PromotionalEvent VALUES (default, 1, 1, 'Kelp Exclusive Event! Enjoy a 20% discount on us. Join for a night
of food, drinks, and surprises as a thank you to our amazing Kelp community.'),
                                 (default, 2, 2, 'Unlock a remarkable 40% discount at our exclusive Kelp Event!')




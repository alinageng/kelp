-- This file is to bootstrap a database for the CS3200 project.

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith
-- data source creation.
drop database kelp_db;
create database kelp_db;

grant all privileges on cool_db.* to 'webapp'@'%';
flush privileges;

use kelp_db;

CREATE TABLE IF NOT EXISTS Customer (
    customer_id int PRIMARY KEY AUTO_INCREMENT,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    email varchar(50) NOT NULL UNIQUE,
    phone varchar(10),
    member_since datetime DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS KelpAdmin (
    admin_id int PRIMARY KEY AUTO_INCREMENT,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    email varchar(50) NOT NULL UNIQUE,
    phone varchar(10)
);

CREATE TABLE IF NOT EXISTS Address (
    address_id int PRIMARY KEY AUTO_INCREMENT,
    street varchar(255) NOT NULL,
    address_line_2 varchar(255),
    city varchar(100) NOT NULL,
    `state` varchar(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Restaurant (
    restaurant_id int PRIMARY KEY AUTO_INCREMENT,
    restaurant_name varchar(50),
    description text,
    hours text,
    address int,
    FOREIGN KEY (address) REFERENCES Address (address_id)
    ON UPDATE cascade ON DELETE cascade
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

CREATE TABLE IF NOT EXISTS MenuItem (
    menu_item_id int PRIMARY KEY AUTO_INCREMENT,
    name varchar(50),
    menu_type varchar(25)
);

CREATE TABLE IF NOT EXISTS Menu (
    menu_id int PRIMARY KEY AUTO_INCREMENT,
    restaurant_id int,
    menu_item_id int,
    price int,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant (restaurant_id)
    ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (menu_item_id) REFERENCES MenuItem (menu_item_id)
    ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS MenuItemReview (
    menu_item_review_id int PRIMARY KEY AUTO_INCREMENT,
    menu_item_id int,
    review_id int,
    description text,
    rating tinyint(1) NOT NULL,
    FOREIGN KEY (menu_item_id) REFERENCES MenuItem (menu_item_id)
    ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (review_id) REFERENCES  RestaurantReview (restaurant_review_id)
    ON UPDATE cascade ON DELETE cascade
);


INSERT INTO Address (street, address_line_2, city, state) VALUES
('123 Main St', NULL, 'Anytown', 'CA'),
('456 Elm St', 'Apt 101', 'Sometown', 'NY'),
('789 Oak St', NULL, 'Othertown', 'TX'),
('111 Pine St', 'Suite 5', 'Yourtown', 'FL'),
('222 Maple St', NULL, 'Smalltown', 'WA'),
('333 Cedar St', 'Unit B', 'Theirtown', 'IL'),
('444 Birch St', 'Floor 3', 'Hometown', 'GA'),
('555 Walnut St', NULL, 'Anothertown', 'MI'),
('666 Spruce St', 'Building C', 'Somewhere', 'OH'),
('777 Ash St', NULL, 'Nowhere', 'PA'),
('888 Chestnut St', 'Unit 7', 'Everywhere', 'MA'),
('999 Fir St', NULL, 'Otherwhere', 'CO'),
('1010 Sycamore St', 'Suite 12', 'Anyplace', 'NC'),
('1212 Poplar St', NULL, 'Newtown', 'AZ'),
('1313 Pineapple St', 'Floor 4', 'Randomtown', 'NV'),
('1414 Orange St', 'Unit 3A', 'Differenttown', 'LA'),
('1515 Lemon St', NULL, 'Unknowntown', 'VA'),
('1616 Lime St', 'Apt 205', 'Middletown', 'MO'),
('1717 Grape St', NULL, 'Sometowntwo', 'WI'),
('1818 Cherry St', 'Building E', 'Othertowntwo', 'OK'),
('1919 Banana St', 'Suite 9', 'Overthere', 'AL'),
('2020 Apple St', NULL, 'Nowheretwo', 'OR'),
('2121 Peach St', 'Floor 1', 'Heretown', 'TN'),
('2222 Pear St', NULL, 'Thistown', 'UT'),
('2323 Plum St', 'Unit 20', 'Thatplace', 'ID'),
('2424 Blueberry St', NULL, 'Hereandthere', 'NE'),
('2525 Raspberry St', 'Suite 8', 'Anywheretown', 'KS'),
('2626 Blackberry St', 'Apt 301', 'Everywheretown', 'IA'),
('2727 Strawberry St', NULL, 'Somewheretown', 'AR'),
('2828 Cranberry St', 'Building F', 'Overtheretown', 'NH'),
('2929 Watermelon St', NULL, 'Somewheretwo', 'MS'),
('3030 Cantaloupe St', 'Floor 2', 'Anotherplace', 'WY'),
('3131 Honeydew St', NULL, 'Otherplacetwo', 'NM'),
('3232 Kiwi St', 'Unit 15', 'Nowherethree', 'MT'),
('3333 Mango St', NULL, 'Somewherethree', 'SD'),
('3434 Papaya St', 'Apt 101', 'Lastplace', 'ND'),
('3535 Pine St', NULL, 'Endtown', 'RI'),
('3636 Oak St', 'Building G', 'Startingtown', 'CT'),
('3737 Elm St', NULL, 'Ontown', 'MD'),
('3838 Maple St', 'Suite 10', 'Undertown', 'DE'),
('3939 Cedar St', NULL, 'Thistownthree', 'VT'),
('4040 Birch St', 'Floor 5', 'Thatplacefour', 'HI'),
('4141 Walnut St', NULL, 'Overhere', 'DC'),
('4242 Spruce St', 'Unit 25', 'Overthere', 'WV'),
('4343 Ash St', NULL, 'Anothertownfive', 'ME'),
('4444 Chestnut St', 'Building H', 'Heretwo', 'NH'),
('4545 Fir St', NULL, 'Overtherefive', 'ID'),
('4646 Sycamore St', 'Suite 18', 'Nowhereseven', 'NE'),
('4747 Poplar St', NULL, 'Thistowneight', 'WY'),
('4848 Pineapple St', 'Floor 6', 'Overherenine', 'KS'),
('4949 Orange St', NULL, 'Overthereeight', 'IA'),
('5050 Lemon St', 'Apt 401', 'Anothertownnine', 'AR');


insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (1, 'Ivonne', 'Le Clercq', 'ileclercq0@slashdot.org', '9151011168', '2023-07-16 19:33:30');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (2, 'Crosby', 'Scotti', 'cscotti1@foxnews.com', '7642169285', '2022-03-02 14:47:53');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (3, 'Valentine', 'Munns', 'vmunns2@vistaprint.com', '7964900005', '2022-04-12 22:10:44');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (4, 'Norina', 'Piddock', 'npiddock3@blogger.com', '3751288788', '2022-10-14 15:17:05');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (5, 'Marisa', 'Whitloe', 'mwhitloe4@artisteer.com', '7793299551', '2022-11-02 10:48:21');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (6, 'Bev', 'Jerg', 'bjerg5@nytimes.com', '2927234695', '2023-07-18 08:16:20');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (7, 'Anstice', 'Olek', 'aolek6@cbsnews.com', '6257726136', '2022-03-19 18:36:42');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (8, 'Maxwell', 'Mankor', 'mmankor7@goo.ne.jp', '9579722098', '2022-07-23 15:29:14');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (9, 'Celinda', 'Peye', 'cpeye8@is.gd', '2232734826', '2023-10-08 06:51:52');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (10, 'Trace', 'Farrear', 'tfarrear9@nationalgeographic.com', '1002243915', '2022-05-27 04:05:40');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (11, 'Pammi', 'Behne', 'pbehnea@nationalgeographic.com', '8498676767', '2023-08-07 15:31:48');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (12, 'Tobie', 'Seligson', 'tseligsonb@rediff.com', '2413421321', '2023-06-01 09:54:08');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (13, 'Rennie', 'Blyth', 'rblythc@si.edu', '9414769730', '2023-10-17 00:25:43');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (14, 'Alyssa', 'Kennefick', 'akennefickd@hostgator.com', '7229339375', '2022-11-14 14:54:25');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (15, 'Tandy', 'Ropkins', 'tropkinse@zimbio.com', '2074590442', '2023-08-08 05:31:25');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (16, 'Sybille', 'Laurance', 'slaurancef@webnode.com', '1604292569', '2023-03-06 16:39:21');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (17, 'Farand', 'Sydney', 'fsydneyg@imgur.com', '3412018434', '2023-07-04 08:01:22');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (18, 'Eugene', 'Ramelot', 'erameloth@thetimes.co.uk', '3015075796', '2023-05-08 10:25:18');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (19, 'Angelina', 'Watson-Brown', 'awatsonbrowni@google.de', '6151723738', '2022-04-13 20:26:25');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (20, 'Martin', 'Donne', 'mdonnej@mozilla.com', '7645445999', '2023-05-28 17:43:46');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (21, 'Owen', 'Dolan', 'odolank@oracle.com', '1214174545', '2022-03-24 23:35:07');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (22, 'Sonya', 'Caldicott', 'scaldicottl@npr.org', '5614486470', '2022-11-04 04:24:11');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (23, 'Janine', 'Allnutt', 'jallnuttm@about.me', '9834994942', '2023-07-12 00:44:52');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (24, 'Darla', 'Kosiada', 'dkosiadan@xrea.com', '2642535898', '2023-03-18 20:10:46');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (25, 'Trish', 'Gash', 'tgasho@a8.net', '5841974653', '2022-03-13 02:46:35');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (26, 'Sanderson', 'Galey', 'sgaleyp@dot.gov', '2993768046', '2022-08-17 19:20:40');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (27, 'Ilysa', 'Gummow', 'igummowq@europa.eu', '9814996346', '2022-10-19 04:16:46');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (28, 'Carilyn', 'Emanuel', 'cemanuelr@senate.gov', '3416687053', '2023-11-08 06:59:44');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (29, 'Morgen', 'Feavyour', 'mfeavyours@cnet.com', '9858387423', '2022-08-31 21:33:45');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (30, 'Latia', 'Bengochea', 'lbengocheat@posterous.com', '1024380960', '2023-11-25 06:58:39');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (31, 'Elisha', 'Cowterd', 'ecowterdu@friendfeed.com', '3581372689', '2022-05-08 09:29:39');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (32, 'Rodrique', 'Pointer', 'rpointerv@people.com.cn', '6168428141', '2023-07-27 12:41:05');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (33, 'Den', 'Moan', 'dmoanw@google.pl', '6934632669', '2022-11-12 01:46:58');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (34, 'Katherine', 'Halston', 'khalstonx@yahoo.co.jp', '3348923605', '2023-02-14 23:46:23');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (35, 'Sampson', 'Edworthye', 'sedworthyey@nytimes.com', '8506512647', '2022-11-24 06:59:39');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (36, 'Gussy', 'Cherrett', 'gcherrettz@alexa.com', '9012391464', '2022-04-18 02:11:40');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (37, 'Carlynn', 'Sollon', 'csollon10@so-net.ne.jp', '7961746933', '2022-12-01 22:23:50');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (38, 'Trace', 'Frenchum', 'tfrenchum11@blog.com', '9387008884', '2022-08-27 14:23:38');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (39, 'Loise', 'Nairns', 'lnairns12@bbc.co.uk', '8153144291', '2022-05-29 19:39:39');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (40, 'Jeana', 'Broadwell', 'jbroadwell13@gov.uk', '4701963580', '2023-06-30 03:42:46');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (41, 'Julee', 'Cabble', 'jcabble14@shop-pro.jp', '2267468466', '2023-08-31 07:48:39');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (42, 'Melonie', 'Lynett', 'mlynett15@hugedomains.com', '3419051079', '2022-12-12 21:05:34');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (43, 'Minnie', 'Stockey', 'mstockey16@cloudflare.com', '8924451871', '2022-07-17 06:37:59');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (44, 'Dedra', 'Haysey', 'dhaysey17@alibaba.com', '7096495543', '2023-04-21 19:21:32');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (45, 'Dalton', 'Baillie', 'dbaillie18@youtube.com', '2157407121', '2023-06-26 17:29:38');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (46, 'Joel', 'Lilleyman', 'jlilleyman19@histats.com', '3567342127', '2023-04-07 19:11:25');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (47, 'Rickey', 'Murrhaupt', 'rmurrhaupt1a@jiathis.com', '3718436186', '2022-12-18 06:37:15');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (48, 'Timi', 'Roskruge', 'troskruge1b@ucsd.edu', '6492235322', '2023-03-11 18:14:10');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (49, 'Helsa', 'Gourlay', 'hgourlay1c@wired.com', '1278856874', '2023-04-20 23:31:35');
insert into Customer (customer_id, first_name, last_name, email, phone, member_since) values (50, 'Chuck', 'Letixier', 'cletixier1d@ehow.com', '2184074586', '2023-09-06 13:35:25');

INSERT INTO MenuItem (name, menu_type) VALUES
('Cheeseburger', 'Burgers'),
('Caesar Salad', 'Salads'),
('Margherita Pizza', 'Pizzas'),
('Chocolate Cake', 'Desserts'),
('Iced Tea', 'Beverages'),
('French Fries', 'Appetizers'),
('Spaghetti Bolognese', 'Pasta'),
('Greek Salad', 'Salads'),
('BBQ Ribs', 'Entrees'),
('Tiramisu', 'Desserts'),
('Lemonade', 'Beverages'),
('Onion Rings', 'Appetizers'),
('Sushi Platter', 'Sushi'),
('Caprese Salad', 'Salads'),
('Steak', 'Entrees'),
('Apple Pie', 'Desserts'),
('Cappuccino', 'Beverages'),
('Mozzarella Sticks', 'Appetizers'),
('Fish and Chips', 'Seafood'),
('Chicken Alfredo', 'Pasta'),
('Nachos', 'Appetizers'),
('Pasta Primavera', 'Pasta'),
('Fruit Salad', 'Salads'),
('Hot Dog', 'Sandwiches'),
('Club Sandwich', 'Sandwiches'),
('Pancakes', 'Breakfast'),
('Milkshake', 'Beverages'),
('Garlic Bread', 'Appetizers'),
('Shrimp Scampi', 'Seafood'),
('Cobb Salad', 'Salads'),
('Tacos', 'Mexican'),
('Lasagna', 'Pasta'),
('Brownie Sundae', 'Desserts'),
('Espresso', 'Beverages'),
('Buffalo Wings', 'Appetizers'),
('Vegetable Stir Fry', 'Vegetarian'),
('Ice Cream Cone', 'Desserts'),
('Lobster Roll', 'Seafood'),
('Margarita', 'Beverages'),
('Beef Stir Fry', 'Meat'),
('Fried Chicken', 'Chicken'),
('Fajitas', 'Mexican'),
('Pad Thai', 'Asian'),
('Cheesecake', 'Desserts'),
('Mimosa', 'Beverages'),
('Veggie Burger', 'Vegetarian'),
('Clam Chowder', 'Soups'),
('Churros', 'Desserts'),
('Cinnamon Roll', 'Breakfast'),
('Fried Rice', 'Asian'),
('Garden Salad', 'Salads'),
('Hamburger', 'Burgers'),
('Pesto Pasta', 'Pasta'),
('Donuts', 'Desserts'),
('Eggplant Parmesan', 'Vegetarian'),
('Green Tea', 'Beverages'),
('Quesadilla', 'Mexican'),
('Macaroni and Cheese', 'Pasta'),
('Tuna Salad', 'Salads'),
('Hot Chocolate', 'Beverages'),
('Pho', 'Asian'),
('Soda', 'Beverages'),
('Ramen', 'Asian'),
('Waffles', 'Breakfast'),
('Pulled Pork Sandwich', 'Sandwiches'),
('Croissant', 'Breakfast'),
('Mussels', 'Seafood'),
('Baklava', 'Desserts'),
('Arnold Palmer', 'Beverages'),
('Caramel Popcorn', 'Snacks'),
('Biscuits and Gravy', 'Breakfast'),
('Poke Bowl', 'Asian'),
('Key Lime Pie', 'Desserts'),
('Bubble Tea', 'Beverages'),
('Chicken Caesar Wrap', 'Sandwiches'),
('Smoothie', 'Beverages'),
('Calamari', 'Seafood'),
('Guacamole', 'Mexican'),
('French Toast', 'Breakfast'),
('Chili', 'Soups'),
('Salmon and Asparagus Foil Packets','Entrees'),
('Caprese Pesto Stuffed Chicken','Entrees'),
('Caprese Chicken Sandwich','Entrees'),
('Vegetable Paella','Entrees'),
('Maple Dijon Glazed Pork Tenderloin','Entrees'),
('Chimichurri Marinated Grilled Steak','Entrees'),
('Shrimp and Andouille Sausage Jambalaya','Entrees'),
('Chicken Enchiladas with Green Chili Sauce','Entrees'),
('Spicy Cajun Shrimp Pasta','Entrees'),
('Roasted Red Pepper and Goat Cheese Stuffed Chicken','Entrees');



INSERT INTO Restaurant (restaurant_name, description, hours, address) VALUES
('Mamas Kitchen', 'Homestyle cooking at its best!', 'Mon-Sat: 8am-9pm, Sun: 9am-8pm', 2),
('Pasta Paradise', 'Italian delicacies served daily.', 'Mon-Fri: 11:30am-10pm, Sat-Sun: 12pm-9pm', 7),
('Brew Haven', 'Craft beers and good times!', 'Mon-Sat: 4pm-12am, Sun: 2pm-10pm', 12),
('Garden Grille', 'Fresh and organic farm-to-table meals.', 'Daily: 10am-8pm', 17),
('The Pancake Place', 'Fluffy pancakes for breakfast enthusiasts.', 'Mon-Sun: 7am-3pm', 22),
('Fiesta Mexicana', 'Authentic Mexican cuisine.', 'Tue-Sun: 11am-10pm', 27),
('Bella Napoli', 'Savor the taste of Naples.', 'Daily: 12pm-11pm', 32),
('The Noodle House', 'Noodles from all around the world!', 'Mon-Sat: 11am-9pm, Sun: 12pm-8pm', 37),
('Smokehouse BBQ', 'Slow-smoked barbecue goodness.', 'Wed-Sun: 12pm-9pm', 42),
('Fisherman’s Catch', 'Fresh seafood served with a view.', 'Daily: 11:30am-10pm', 47),
('Veggie Delight', 'A haven for vegetarian delights.', 'Mon-Sun: 10am-7pm', 3),
('The Steakhouse', 'Juicy steaks cooked to perfection.', 'Tue-Sat: 5pm-10pm', 8),
('The Curry Pot', 'Spice up your day with flavorful curries.', 'Mon-Sun: 11:30am-9:30pm', 13),
('Sip & Savor Café', 'Where every sip and bite delights!', 'Mon-Fri: 8am-7pm, Sat-Sun: 9am-5pm', 18),
('Burger Joint', 'Serving classic burgers since 1985.', 'Mon-Sun: 11am-10pm', 23),
('Tropical Taste', 'Island-inspired dishes for a tropical vibe.', 'Wed-Sun: 12pm-8pm', 28),
('Slice of Heaven', 'Every slice is a taste of heaven!', 'Daily: 11am-9pm', 33),
('Café Parisienne', 'Bonjour! French cuisine at its finest.', 'Tue-Sun: 10am-10pm', 38),
('Wrap It Up', 'Wraps and rolls for on-the-go meals.', 'Mon-Fri: 10am-6pm, Sat: 11am-5pm', 43),
('Diner Deluxe', 'Classic diner fare with a modern twist.', 'Mon-Sun: 7am-10pm', 48),
('Ramen House', 'Slurp-worthy bowls of authentic ramen.', 'Tue-Sat: 11:30am-10pm, Sun: 12pm-9pm', 4),
('Tandoori Nights', 'Tantalizing tandoori flavors.', 'Mon-Sun: 12pm-11pm', 9),
('Crispy Crust Pizzeria', 'Crunchy crusts and savory toppings!', 'Mon-Sun: 11am-10pm', 14),
('Tea Time Corner', 'A cozy spot for tea enthusiasts.', 'Mon-Fri: 9am-6pm, Sat-Sun: 10am-4pm', 19),
('Nacho Nation', 'Where nachos reign supreme!', 'Mon-Sat: 12pm-11pm, Sun: 1pm-9pm', 24),
('Sushi Sensation', 'Sensational sushi rolls for every taste.', 'Tue-Sun: 11:30am-10pm', 29),
('BBQ Pitstop', 'Fueling your barbecue cravings!', 'Wed-Sun: 12pm-8pm', 34),
('Wok Wonders', 'Wok-tossed wonders from Asia.', 'Mon-Sat: 11am-9pm, Sun: 12pm-7pm', 39),
('Pita Palace', 'Freshly baked pitas filled with goodness.', 'Mon-Sun: 10am-8pm', 44),
('Soup Spoon', 'Comfort in a bowl - soups for every soul.', 'Mon-Fri: 11am-7pm, Sat: 12pm-5pm', 49),
('Pancake Pantry', 'A pantry full of pancake delights.', 'Mon-Sun: 7am-4pm', 5),
('Taste of Thailand', 'Journey through the flavors of Thailand.', 'Tue-Sun: 12pm-10pm', 10),
('Bakery Bliss', 'Freshly baked goodness every day!', 'Mon-Sun: 8am-6pm', 15),
('Tempting Tacos', 'Tantalizing tacos in every variety.', 'Mon-Sat: 11am-10pm, Sun: 12pm-9pm', 20),
('Smoothie Shack', 'Blend of health and deliciousness!', 'Mon-Sun: 9am-8pm', 25),
('Café Roma', 'Italian café with a charming ambiance.', 'Tue-Sun: 9am-11pm', 30),
('Cheeseburger Paradise', 'Where cheeseburgers rule!', 'Mon-Sun: 11am-9pm', 35),
('Rice n Spice', 'A fusion of rice and spice!', 'Mon-Sat: 12pm-10pm, Sun: 1pm-9pm', 40),
('Taste of India', 'A diverse palette of Indian flavors.', 'Tue-Sun: 11:30am-10pm', 45),
('Bagel Bliss', 'Every bagel-lover’s paradise.', 'Mon-Sun: 6am-4pm', 50),
('Chopstick Charm', 'Chinese delicacies to charm your taste buds.', 'Mon-Sat: 11am-9pm, Sun: 12pm-8pm', 6),
('Taco Time', 'Tacos for any time of the day!', 'Mon-Sun: 10am-8pm', 11),
('Café Mocha', 'Where coffee meets delight!', 'Mon-Fri: 7am-8pm, Sat-Sun: 8am-6pm', 16),
('Hot Dog Haven', 'A paradise for hot dog enthusiasts.', 'Mon-Sun: 11am-7pm', 21),
('Sizzle n Spice', 'Where sizzle meets spice!', 'Tue-Sun: 12pm-11pm', 26),
('The Spice Emporium', 'A culinary journey through spices!', 'Tue-Sun: 12pm-10pm', 1),
('Sushi Central', 'Fresh sushi served daily.', 'Mon-Sat: 11:30am-9pm, Sun: 12pm-8pm', 31),
('Taco Haven', 'Tacos for every mood!', 'Mon-Fri: 10am-8pm, Sat-Sun: 11am-9pm', 36),
('Mamma Mia Pizzeria', 'Authentic Italian pizzas made with love.', 'Daily: 11am-10pm', 41),
('The Green Bowl', 'Healthy bowls for a nutritious meal!', 'Mon-Sun: 9am-7pm', 46);


INSERT INTO Menu (restaurant_id, menu_item_id, price) VALUES
(9, 32, 13),
(33, 62, 27),
(20, 47, 16),
(46, 15, 21),
(50, 76, 25),
(6, 61, 18),
(31, 40, 30),
(3, 8, 22),
(18, 26, 19),
(38, 51, 24),
(49, 6, 28),
(16, 44, 17),
(7, 53, 23),
(40, 29, 21),
(11, 67, 26),
(34, 18, 29),
(13, 78, 27),
(27, 9, 15),
(48, 35, 20),
(1, 55, 12),
(12, 75, 25),
(25, 14, 20),
(8, 64, 14),
(44, 5, 18),
(50, 22, 23),
(5, 75, 17),
(30, 45, 30),
(2, 11, 21),
(18, 28, 19),
(37, 54, 26),
(49, 8, 27),
(16, 73, 22),
(6, 12, 24),
(21, 52, 28),
(40, 32, 16),
(9, 70, 29),
(33, 21, 25),
(13, 79, 30),
(26, 10, 18),
(46, 36, 22),
(3, 58, 15),
(7, 23, 19),
(31, 43, 26),
(19, 31, 23),
(45, 16, 28),
(50, 77, 20),
(4, 63, 24),
(29, 46, 27),
(1, 7, 18),
(17, 29, 20),
(36, 56, 29),
(48, 9, 30),
(15, 74, 16),
(5, 60, 21),
(39, 33, 25),
(10, 71, 26),
(32, 24, 17),
(14, 80, 22),
(28, 13, 19),
(47, 37, 23),
(2, 59, 28),
(7, 17, 27),
(31, 47, 24),
(19, 34, 18),
(45, 19, 25),
(50, 78, 29),
(4, 65, 30),
(29, 48, 20),
(1, 8, 14),
(17, 30, 22),
(36, 57, 19),
(48, 10, 26),
(15, 75, 23),
(5, 61, 28),
(39, 34, 21),
(10, 72, 27),
(32, 25, 24),
(14, 81, 29),
(28, 14, 16),
(47, 38, 18),
(2, 60, 27),
(7, 18, 23),
(31, 48, 19),
(19, 35, 25),
(45, 20, 30),
(50, 79, 22),
(4, 66, 28),
(29, 49, 24),
(1, 9, 16),
(17, 31, 20),
(36, 58, 29),
(48, 11, 30),
(15, 76, 25),
(5, 62, 18),
(39, 35, 26),
(10, 73, 22),
(32, 26, 19),
(14, 82, 27),
(28, 15, 23),
(47, 39, 28),
(2, 61, 20),
(7, 19, 25),
(31, 49, 24),
(19, 36, 21),
(45, 21, 29),
(50, 80, 26),
(4, 67, 30),
(29, 50, 18),
(1, 10, 22),
(17, 32, 19),
(36, 59, 27),
(48, 12, 26),
(15, 77, 23),
(5, 63, 24),
(39, 36, 20),
(10, 74, 28),
(32, 27, 29),
(14, 83, 25),
(28, 16, 18),
(47, 40, 27),
(2, 62, 21),
(7, 20, 19),
(31, 50, 26),
(19, 37, 28),
(45, 22, 23),
(50, 81, 30),
(4, 68, 24),
(29, 51, 25),
(1, 11, 18),
(17, 33, 22),
(36, 60, 27),
(48, 13, 29),
(15, 78, 24),
(5, 64, 20),
(39, 37, 26),
(10, 75, 30),
(32, 28, 28),
(14, 84, 22),
(28, 17, 21),
(47, 41, 19),
(2, 63, 27),
(7, 21, 25),
(31, 51, 23),
(19, 38, 30),
(45, 23, 22),
(50, 82, 28),
(4, 69, 26),
(29, 52, 18),
(1, 12, 27),
(17, 34, 21),
(36, 61, 29),
(48, 14, 25),
(15, 79, 20),
(5, 65, 29),
(39, 38, 24),
(10, 76, 23),
(32, 29, 22),
(14, 85, 28),
(28, 18, 26),
(47, 42, 19),
(2, 64, 27),
(7, 22, 20),
(31, 52, 28),
(19, 39, 25),
(45, 24, 29),
(50, 83, 24),
(4, 70, 18),
(29, 53, 22),
(1, 13, 29),
(17, 35, 26),
(36, 62, 23),
(48, 15, 27),
(15, 80, 25),
(5, 66, 19),
(39, 39, 28),
(10, 77, 30),
(32, 30, 24),
(14, 86, 21),
(28, 19, 22),
(47, 43, 27),
(2, 65, 20),
(7, 23, 29),
(31, 53, 25),
(19, 40, 18),
(45, 25, 26),
(50, 84, 23),
(4, 71, 28),
(29, 54, 22),
(1, 14, 24),
(17, 36, 27),
(36, 63, 19),
(48, 16, 22),
(15, 81, 25),
(5, 67, 29),
(39, 40, 23),
(10, 78, 28),
(32, 31, 20),
(14, 87, 26),
(28, 20, 22),
(47, 44, 25),
(2, 66, 27),
(7, 24, 21),
(31, 54, 29),
(19, 41, 26),
(45, 26, 24),
(50, 85, 19),
(4, 72, 23),
(29, 55, 28),
(1, 15, 25),
(17, 37, 18),
(36, 64, 27),
(48, 17, 22),
(15, 82, 29),
(5, 68, 30),
(39, 41, 23),
(10, 79, 25),
(32, 32, 27),
(14, 88, 21),
(28, 21, 26),
(47, 45, 28),
(2, 67, 22),
(7, 25, 24),
(31, 55, 19),
(19, 42, 20),
(45, 27, 29),
(50, 86, 28),
(4, 73, 26),
(29, 56, 21),
(1, 16, 27),
(17, 38, 28),
(36, 65, 23),
(48, 18, 25),
(15, 83, 22),
(5, 69, 29),
(39, 42, 20),
(10, 80, 24),
(32, 33, 27),
(14, 89, 28),
(28, 22, 21),
(47, 46, 25),
(2, 68, 28),
(7, 26, 30),
(31, 56, 23),
(19, 43, 18),
(45, 28, 26),
(50, 87, 22),
(4, 74, 25),
(29, 57, 21),
(1, 17, 28),
(17, 39, 23),
(36, 66, 26),
(48, 19, 20),
(15, 84, 29),
(5, 70, 22),
(39, 43, 27),
(10, 81, 23),
(32, 34, 19),
(14, 90, 28),
(28, 23, 27),
(47, 47, 20),
(2, 69, 29),
(7, 27, 25),
(31, 57, 21),
(19, 44, 28),
(45, 29, 23),
(50, 88, 26),
(4, 75, 22),
(29, 58, 27),
(1, 18, 20),
(17, 40, 22),
(36, 67, 29),
(48, 20, 25),
(15, 85, 28),
(5, 71, 21),
(39, 44, 24),
(10, 82, 19),
(32, 35, 28),
(28, 24, 23),
(47, 48, 22),
(2, 70, 30),
(7, 28, 25),
(31, 58, 26),
(19, 45, 19),
(45, 30, 28),
(50, 89, 24),
(4, 76, 23),
(29, 59, 19),
(1, 19, 26),
(17, 41, 27),
(36, 68, 20),
(48, 21, 22),
(15, 86, 29),
(5, 72, 25),
(39, 45, 30),
(10, 83, 24),
(32, 36, 27),
(28, 25, 28),
(47, 49, 21),
(2, 71, 24),
(7, 29, 20),
(31, 59, 30),
(19, 46, 22),
(45, 31, 27),
(50, 90, 25),
(4, 77, 19),
(29, 60, 23),
(1, 20, 28),
(17, 42, 25),
(36, 69, 21),
(48, 22, 29),
(15, 87, 22),
(5, 73, 24),
(39, 46, 30),
(10, 84, 27),
(32, 37, 25),
(28, 26, 22),
(47, 50, 20),
(2, 72, 26),
(7, 30, 29),
(31, 60, 23),
(19, 47, 28),
(45, 32, 25),
(4, 78, 22),
(29, 61, 24),
(1, 21, 27),
(17, 43, 22),
(36, 70, 28),
(48, 23, 20),
(15, 88, 26),
(5, 74, 30),
(39, 47, 21),
(10, 85, 29);


insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (27, 23, 'praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed', 2, '2023-04-09 09:30:27');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (49, 40, 'dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus', 1, '2023-02-19 06:39:01');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (26, 15, 'etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum', 1, '2023-08-09 01:39:40');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (25, 7, 'lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus', 2, '2023-02-15 19:28:21');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (49, 1, 'erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus', 1, '2023-05-17 14:27:56');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (8, 8, 'amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti', 2, '2022-12-11 09:00:06');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (22, 23, 'donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis', 1, '2023-03-25 07:02:31');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (25, 3, 'rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede', 5, '2023-11-26 20:16:40');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (26, 13, 'nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus', 1, '2023-08-06 15:01:59');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (25, 30, 'amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus', 4, '2023-06-26 04:14:13');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (40, 47, 'diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam', 4, '2023-01-20 04:19:38');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (36, 22, 'dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus', 4, '2023-08-22 10:23:16');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (36, 37, 'quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id', 1, '2023-11-21 00:43:01');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (18, 22, 'platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales', 2, '2022-12-21 18:58:47');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (49, 49, 'nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae', 5, '2023-07-26 16:34:55');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (35, 14, 'pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate', 1, '2023-02-23 07:21:08');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (36, 22, 'sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non', 5, '2023-03-06 03:10:48');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (32, 15, 'ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim', 1, '2023-06-03 06:40:28');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (14, 38, 'ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue', 1, '2023-03-24 20:48:51');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (34, 7, 'accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet', 1, '2023-11-20 13:07:51');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (13, 6, 'quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit', 1, '2023-03-20 16:25:21');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (29, 4, 'odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac', 5, '2023-05-12 11:24:25');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (44, 19, 'eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna', 3, '2023-11-03 16:28:53');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (23, 25, 'eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing', 4, '2022-12-12 18:06:36');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (21, 15, 'nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede', 5, '2023-10-13 08:26:26');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (26, 19, 'nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio', 4, '2023-02-09 07:48:00');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (25, 7, 'luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla', 2, '2023-04-09 09:32:52');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (7, 25, 'eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere', 3, '2023-11-26 21:42:24');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (31, 37, 'convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat', 3, '2023-01-16 11:30:31');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (41, 41, 'imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse', 3, '2023-10-18 19:14:25');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (41, 23, 'erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed', 3, '2023-08-04 14:37:38');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (11, 12, 'interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus', 2, '2023-02-02 00:43:04');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (21, 35, 'vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum', 5, '2023-05-03 20:48:51');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (50, 42, 'erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus', 1, '2023-03-15 15:05:10');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (20, 21, 'tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi', 1, '2023-08-31 01:36:37');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (22, 43, 'accumsan felis ut at dolor quis odio consequat varius integer', 3, '2023-05-11 02:38:35');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (13, 38, 'lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus', 5, '2023-06-05 06:38:31');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (46, 16, 'metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero', 5, '2023-04-03 08:08:24');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (41, 26, 'in est risus auctor sed tristique in tempus sit amet sem fusce', 1, '2023-10-16 03:27:08');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (7, 27, 'augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris', 1, '2023-03-23 02:16:50');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (11, 42, 'ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu', 2, '2022-12-22 23:28:19');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (21, 42, 'felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis', 3, '2023-04-12 23:53:07');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (18, 34, 'neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec', 4, '2022-12-15 04:05:18');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (3, 20, 'ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus', 4, '2023-08-09 17:11:18');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (38, 5, 'lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui', 5, '2022-12-25 05:56:38');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (37, 37, 'nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet', 2, '2023-09-02 02:29:03');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (45, 7, 'purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer', 3, '2023-10-13 19:27:15');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (24, 43, 'aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce', 1, '2023-05-19 02:32:45');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (41, 7, 'erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at', 3, '2023-07-30 14:55:12');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (4, 10, 'nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat', 3, '2023-02-05 05:37:38');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (6, 6, 'pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum', 5, '2023-01-02 12:43:42');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (33, 16, 'orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis', 2, '2023-08-06 02:03:59');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (43, 49, 'eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed', 1, '2023-09-05 09:26:58');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (22, 4, 'vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem', 1, '2023-05-26 18:39:39');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (2, 9, 'ullamcorper augue a suscipit nulla elit ac nulla sed vel', 1, '2023-04-27 06:40:46');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (48, 1, 'lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in', 1, '2022-12-05 19:15:44');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (18, 37, 'eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non', 1, '2023-05-04 01:02:45');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (43, 30, 'vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget', 2, '2023-06-21 22:06:53');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (42, 9, 'erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis', 2, '2023-12-03 04:35:36');
insert into RestaurantReview (customer_id, restaurant_id, description, rating, date) values (49, 3, 'nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur', 1, '2023-05-03 11:26:21');


insert into MenuItemReview (menu_item_id, review_id, description, rating) values (11, 57, 'est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (56, 53, 'duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (13, 38, 'id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (47, 13, 'libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (22, 60, 'est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (69, 21, 'cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (21, 48, 'hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (14, 13, 'morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (89, 5, 'mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (81, 44, 'vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (61, 40, 'magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (40, 36, 'pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (58, 60, 'eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (19, 3, 'ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (85, 25, 'nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (15, 16, 'lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (25, 47, 'cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (47, 60, 'nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (14, 1, 'consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (24, 31, 'sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (43, 1, 'ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (75, 47, 'lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (32, 14, 'neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (17, 50, 'vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (25, 19, 'in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (10, 3, 'dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (51, 6, 'neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (80, 32, 'porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (24, 39, 'vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (58, 30, 'id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (44, 36, 'volutpat dui maecenas tristique est et tempus semper est quam', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (17, 60, 'nulla justo aliquam quis turpis eget elit sodales scelerisque mauris', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (47, 46, 'vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (67, 45, 'mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (62, 8, 'malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (10, 32, 'interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (82, 37, 'ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (42, 36, 'orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (88, 54, 'accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (40, 53, 'consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (2, 21, 'felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (21, 29, 'curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (16, 27, 'luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (86, 55, 'ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (22, 7, 'accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (32, 40, 'imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (78, 42, 'pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (17, 38, 'id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (30, 7, 'luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (24, 47, 'pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (32, 9, 'parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (25, 13, 'in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (64, 27, 'nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (5, 33, 'sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (41, 54, 'nisi at nibh in hac habitasse platea dictumst aliquam augue quam', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (68, 5, 'rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (54, 33, 'pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (37, 32, 'lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (42, 43, 'ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (70, 23, 'quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (73, 42, 'risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (59, 38, 'augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (14, 36, 'nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (77, 39, 'parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (88, 21, 'nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (40, 38, 'ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (47, 20, 'non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (75, 7, 'ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (16, 51, 'magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (78, 16, 'accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (33, 32, 'nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (64, 38, 'morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (45, 59, 'orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (71, 33, 'molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (48, 5, 'in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (19, 54, 'ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (22, 44, 'orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (53, 14, 'sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (14, 39, 'in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (15, 33, 'augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (17, 13, 'mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (51, 36, 'est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (87, 59, 'magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (44, 47, 'orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (81, 11, 'vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (1, 2, 'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (35, 58, 'amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (25, 9, 'mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (55, 54, 'id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (1, 10, 'tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (81, 37, 'risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (57, 2, 'viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (69, 8, 'primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (31, 31, 'curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (69, 21, 'sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (36, 10, 'in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (57, 36, 'justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (32, 55, 'ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (66, 4, 'enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (22, 13, 'ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (25, 31, 'fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (8, 27, 'aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (18, 6, 'montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (19, 42, 'curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (43, 40, 'id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (50, 34, 'dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (50, 19, 'sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (38, 47, 'lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (76, 33, 'mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (36, 31, 'porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (2, 58, 'id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (72, 16, 'vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (43, 39, 'metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (14, 47, 'fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (7, 42, 'nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (29, 45, 'orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (71, 35, 'mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam tristique', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (42, 1, 'accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (68, 42, 'vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (13, 10, 'et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (1, 50, 'volutpat dui maecenas tristique est et tempus semper est quam pharetra magna', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (29, 40, 'nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (76, 7, 'in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (13, 40, 'lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (64, 13, 'purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (27, 41, 'nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam tristique tortor eu', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (30, 35, 'euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (32, 27, 'curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (90, 28, 'ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (18, 17, 'curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (2, 55, 'luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (4, 31, 'non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (51, 58, 'cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (45, 38, 'nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (81, 50, 'praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (38, 36, 'luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (11, 13, 'quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (59, 2, 'adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (61, 23, 'nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (59, 57, 'elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (38, 18, 'nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (57, 24, 'viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (85, 32, 'nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (65, 4, 'iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (61, 1, 'convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (58, 16, 'in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (15, 53, 'pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (90, 41, 'et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (27, 43, 'sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (32, 31, 'pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (30, 12, 'curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (64, 39, 'cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (50, 59, 'tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (32, 40, 'habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (51, 3, 'pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (61, 11, 'lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (54, 49, 'sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (80, 2, 'leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (74, 38, 'mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (79, 40, 'et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (5, 26, 'mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (6, 48, 'erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (34, 59, 'ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (71, 51, 'at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (55, 7, 'nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (71, 25, 'neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (75, 49, 'dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (15, 11, 'nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (42, 21, 'turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (89, 60, 'a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (64, 47, 'amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (47, 14, 'enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (1, 30, 'diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (26, 13, 'urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (6, 54, 'sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (20, 23, 'sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (22, 37, 'ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (9, 18, 'ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (53, 18, 'quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (67, 28, 'aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (18, 38, 'eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (88, 31, 'mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (50, 10, 'nunc purus phasellus in felis donec semper sapien a libero nam dui proin', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (74, 42, 'eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (47, 29, 'nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in', 2);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (15, 26, 'semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo', 5);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (84, 30, 'elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (10, 50, 'mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (41, 53, 'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (64, 26, 'lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (66, 48, 'mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (43, 15, 'massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (77, 4, 'pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (27, 44, 'rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (77, 56, 'aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (56, 7, 'ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam', 1);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (26, 27, 'luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (14, 40, 'augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet', 3);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (55, 43, 'vivamus tortor duis mattis egestas metus aenean fermentum donec ut', 4);
insert into MenuItemReview (menu_item_id, review_id, description, rating) values (83, 26, 'cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue', 3);

INSERT INTO HealthInspector (inspector_id, first_name, last_name, email) VALUES
(default, 'Anatole', 'Ramlot', 'aramlot0@slideshare.net'),
(default, 'Chris', 'Mylechreest', 'cmylechreest1@theguardian.com'),
(default, 'Claudette', 'Cooke', 'ccooke2@tripod.com'),
(default, 'Kaylil', 'Hasloch', 'khasloch3@umn.edu'),
(default, 'Bea', 'McAnalley', 'bmcanalley4@wufoo.com'),
(default, 'Jacky', 'Terry', 'jterry5@163.com'),
(default, 'Nealson', 'Denholm', 'ndenholm6@t-online.de'),
(default, 'Meryl', 'Poyser', 'mpoyser7@phpbb.com'),
(default, 'Kathleen', 'Kirby', 'kkirby8@vistaprint.com'),
(default, 'Clayton', 'Kornacki', 'ckornacki9@gizmodo.com'),
(default, 'Randolf', 'Vine', 'rvinea@furl.net'),
(default, 'Vonnie', 'Bolte', 'vbolteb@cnn.com'),
(default, 'Lyle', 'Yitzhak', 'lyitzhakc@cpanel.net'),
(default, 'Tobit', 'Fantini', 'tfantinid@blogtalkradio.com'),
(default, 'Lexie', 'Meiklam', 'lmeiklame@parallels.com'),
(default, 'Idette', 'Mercy', 'imercyf@patch.com'),
(default, 'Herold', 'Inglesant', 'hinglesantg@youtube.com'),
(default, 'Kinny', 'Jahnel', 'kjahnelh@deviantart.com'),
(default, 'Jacquelin', 'Imm', 'jimmi@opensource.org'),
(default, 'Codi', 'Pales', 'cpalesj@mediafire.com'),
(default, 'Richardo', 'Bestar', 'rbestark@mtv.com'),
(default, 'Frederica', 'Felten', 'ffeltenl@comcast.net'),
(default, 'Giles', 'Kubes', 'gkubesm@fda.gov'),
(default, 'Rubina', 'Pergens', 'rpergensn@miitbeian.gov.cn'),
(default, 'Tedman', 'Dooher', 'tdoohero@trellian.com'),
(default, 'Felizio', 'Tyrwhitt', 'ftyrwhittp@dyndns.org'),
(default, 'Gerard', 'Poyntz', 'gpoyntzq@dion.ne.jp'),
(default, 'Dougie', 'Osmon', 'dosmonr@reuters.com'),
(default, 'Jacenta', 'Mattiazzo', 'jmattiazzos@soundcloud.com'),
(default, 'Noemi', 'Paxeford', 'npaxefordt@go.com'),
(default, 'Nichol', 'Hulance', 'nhulanceu@amazon.co.uk'),
(default, 'Flora', 'Harlowe', 'fharlowev@usda.gov'),
(default, 'Tab', 'Jumont', 'tjumontw@opensource.org'),
(default, 'Roxy', 'Semarke', 'rsemarkex@bluehost.com'),
(default, 'Nicolis', 'Tattersdill', 'ntattersdilly@yelp.com'),
(default, 'Bendicty', 'McPeck', 'bmcpeckz@mit.edu'),
(default, 'Eveleen', 'Got', 'egot10@oracle.com'),
(default, 'Charity', 'Bould', 'cbould11@stumbleupon.com'),
(default, 'Evangeline', 'Morit', 'emorit12@i2i.jp'),
(default, 'Maressa', 'Tweedlie', 'mtweedlie13@ask.com'),
(default, 'Arlette', 'Benettolo', 'abenettolo14@mashable.com'),
(default, 'Kit', 'Mowbray', 'kmowbray15@ca.gov'),
(default, 'Arlena', 'Clampett', 'aclampett16@jugem.jp'),
(default, 'Langston', 'Jehan', 'ljehan17@weibo.com'),
(default, 'Rubetta', 'Evamy', 'revamy18@diigo.com'),
(default, 'Vanessa', 'Parsons', 'vparsons19@goodreads.com'),
(default, 'Carolann', 'Tweedie', 'ctweedie1a@zdnet.com'),
(default, 'Blair', 'Irnys', 'birnys1b@list-manage.com'),
(default, 'Torre', 'Larkkem', 'tlarkkem1c@sina.com.cn'),
(default, 'Ernst', 'Jordeson', 'ejordeson1d@google.pl'),
(default, 'Minta', 'Drewell', 'mdrewell1e@google.co.uk'),
(default, 'Silvano', 'Mathiot', 'smathiot1f@linkedin.com'),
(default, 'Candis', 'Faussett', 'cfaussett1g@salon.com'),
(default, 'Petronella', 'Fishe', 'pfishe1h@deliciousdays.com'),
(default, 'Daphne', 'Aizikovitch', 'daizikovitch1i@eventbrite.com'),
(default, 'Jerry', 'McKeller', 'jmckeller1j@chicagotribune.com'),
(default, 'Maurizio', 'Shepcutt', 'mshepcutt1k@pinterest.com'),
(default, 'Kate', 'Dearnley', 'kdearnley1l@fema.gov'),
(default, 'Immanuel', 'Gandley', 'igandley1m@parallels.com'),
(default, 'Nikolia', 'Ellerker', 'nellerker1n@sitemeter.com'),
(default, 'Shaylyn', 'Petrusch', 'spetrusch1o@theguardian.com'),
(default, 'Annnora', 'Crumbie', 'acrumbie1p@yellowpages.com');


insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (23, 11, '2022-05-03 22:17:33', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (2, 34, '2023-01-03 11:54:54', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (48, 15, '2022-02-27 03:35:25', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (1, 10, '2023-08-26 15:44:30', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (23, 13, '2022-02-15 12:15:31', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (53, 44, '2022-06-02 05:21:50', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (32, 12, '2021-10-18 02:56:25', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (34, 24, '2022-04-04 13:51:41', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (14, 9, '2023-03-23 01:46:06', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (10, 12, '2022-07-10 17:01:43', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (41, 6, '2022-01-20 09:59:41', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (33, 21, '2023-06-18 01:54:09', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (17, 10, '2021-12-29 21:18:28', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (22, 12, '2022-11-22 07:47:32', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (58, 10, '2023-03-08 11:55:32', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (6, 7, '2023-08-10 12:55:02', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (54, 29, '2022-02-25 19:38:04', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (1, 13, '2023-10-01 12:20:17', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (53, 4, '2022-04-17 10:11:43', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (6, 34, '2022-03-22 13:11:08', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (49, 46, '2022-10-14 16:30:16', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (52, 2, '2022-09-05 15:54:01', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (23, 29, '2023-10-17 14:52:32', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (54, 6, '2023-06-01 08:51:44', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (15, 8, '2023-09-14 09:00:48', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (43, 17, '2022-01-01 22:02:05', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (19, 24, '2023-04-01 09:48:13', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (61, 30, '2021-12-18 05:49:50', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (32, 18, '2022-09-28 22:15:37', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (12, 48, '2022-03-26 07:18:20', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (6, 27, '2021-10-05 17:48:08', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (34, 2, '2021-11-13 17:34:38', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (31, 10, '2023-05-25 02:24:22', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (32, 49, '2023-03-10 19:50:55', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (61, 47, '2022-09-19 20:08:50', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (36, 6, '2023-05-29 00:23:14', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (44, 10, '2022-08-31 11:36:20', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (43, 10, '2023-07-02 00:19:47', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (58, 38, '2022-02-17 20:56:15', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (15, 36, '2021-12-11 08:12:57', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (28, 11, '2023-02-17 19:00:59', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (19, 48, '2022-02-03 05:46:57', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (1, 27, '2023-08-20 18:39:27', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (38, 35, '2022-12-24 06:07:41', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (15, 50, '2022-07-23 16:28:35', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (18, 17, '2023-11-04 14:19:47', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (27, 3, '2022-10-01 23:15:45', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (52, 39, '2023-10-27 01:54:59', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (52, 38, '2022-02-10 12:18:44', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (33, 11, '2023-08-09 19:27:32', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (21, 30, '2023-09-02 14:32:56', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (38, 42, '2022-11-09 01:50:48', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (51, 12, '2023-03-11 11:04:52', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (4, 22, '2022-11-02 17:55:48', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (15, 24, '2023-03-02 13:53:53', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (16, 40, '2023-10-16 23:00:15', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (10, 11, '2023-02-07 01:18:10', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (20, 16, '2023-08-16 21:23:05', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (19, 18, '2023-04-06 14:50:05', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (31, 48, '2021-12-21 16:28:25', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (53, 10, '2022-10-16 00:17:52', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (44, 49, '2023-07-24 19:29:25', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (25, 12, '2023-06-19 17:11:11', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (9, 15, '2022-04-28 05:26:20', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (34, 13, '2022-05-25 18:44:51', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (36, 3, '2023-01-06 03:26:43', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (48, 16, '2022-10-30 01:58:52', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (33, 2, '2022-12-02 17:16:32', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (25, 36, '2023-01-19 10:37:56', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (6, 28, '2023-09-14 07:06:10', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (40, 26, '2022-04-04 02:00:25', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (25, 45, '2023-09-29 14:23:38', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (20, 22, '2022-10-28 02:15:39', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (15, 31, '2021-10-15 11:18:58', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (28, 32, '2023-06-20 18:45:06', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (14, 7, '2022-09-26 21:22:57', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (29, 46, '2023-08-26 03:59:40', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (46, 21, '2022-10-07 02:14:26', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (39, 14, '2023-02-14 19:59:35', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (44, 27, '2022-02-27 18:42:22', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (48, 39, '2023-01-03 16:30:30', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (39, 27, '2022-04-09 13:17:53', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (49, 44, '2022-02-17 07:40:43', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (32, 5, '2022-09-09 00:36:47', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (62, 37, '2023-10-06 01:03:04', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (45, 32, '2022-03-17 02:16:53', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (3, 37, '2022-10-11 06:51:42', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (52, 24, '2023-05-18 20:15:11', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (14, 39, '2021-11-19 23:03:40', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (9, 6, '2022-06-22 09:40:54', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (10, 32, '2023-06-07 09:56:07', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (8, 14, '2023-10-23 08:26:08', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (23, 26, '2022-04-03 09:14:21', 'B');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (61, 43, '2023-01-30 18:21:15', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (39, 5, '2023-06-04 17:24:28', 'F');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (39, 5, '2023-02-15 11:03:22', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (47, 25, '2023-09-30 21:42:29', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (10, 45, '2023-02-14 01:03:43', 'A');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (15, 23, '2022-04-12 22:33:38', 'C');
insert into HealthInspection (inspector_id, restaurant_id, date, grade) values (47, 49, '2023-12-03 17:26:21', 'B');


INSERT INTO KelpAdmin (admin_id, first_name, last_name, email, phone) VALUES
(default,'Corrinne','Greenway','cgreenway0@japanpost.jp','9898905189'),
(default,'Tamqrah','O''Doghesty','todoghesty1@umn.edu','5525073251'),
(default,'Anne','Aishford','aaishford2@icq.com','7693308652'),
(default,'Alair','Tackley','atackley3@walmart.com','2980512197'),
(default,'Fax','Sweeny','fsweeny4@cloudflare.com','6028179741'),
(default,'Aidan','Dyton','adyton5@wordpress.com','4244642860'),
(default,'Cherice','Gorden','cgorden6@posterous.com','7861871668'),
(default,'Viviene','Losebie','vlosebie7@google.co.uk','8675288635'),
(default,'Liana','Gabby','lgabby8@cbc.ca','4887374044'),
(default,'Bernete','Oak','boak9@drupal.org','3188795457'),
(default,'Cordelie','Anmore','canmorea@ebay.com','9334713115'),
(default,'Anselm','Henfre','ahenfreb@bravesites.com','5043302441'),
(default,'Job','Winter','jwinterc@webeden.co.uk','9685807711'),
(default,'Langsdon','Noone','lnooned@barnesandnoble.com','7834589641'),
(default,'Kile','Malkin','kmalkine@123-reg.co.uk','7437052836'),
(default,'Everett','Chapier','echapierf@si.edu','7372118651'),
(default,'Nikolai','Maleney','nmaleneyg@e-recht24.de','3814376905'),
(default,'Zoe','Kember','zkemberh@discuz.net','7270272354'),
(default,'Sonni','Burdis','sburdisi@altervista.org','4992900518'),
(default,'Nita','Barton','nbartonj@ca.gov','3873973212'),
(default,'Bevin','Maitland','bmaitlandk@booking.com','9809763989'),
(default,'Phedra','Huckel','phuckell@miibeian.gov.cn','5455992881'),
(default,'Kerry','Eisikovitsh','keisikovitshm@w3.org','5216241445'),
(default,'Morgan','Radford','mradfordn@squidoo.com','8686692258'),
(default,'Jemie','Grollmann','jgrollmanno@businessinsider.com','8928295250'),
(default,'Hulda','Acutt','hacuttp@seesaa.net','4190386702'),
(default,'Mattie','Weller','mwellerq@google.cn','2265991770'),
(default,'Moira','Stockdale','mstockdaler@ezinearticles.com','7510182065'),
(default,'Kristopher','Auston','kaustons@answers.com','8620355993'),
(default,'Isaiah','Peert','ipeertt@oakley.com','2008174918'),
(default,'Esmeralda','Peploe','epeploeu@dedecms.com','3154301178'),
(default,'Zacharia','Miller','zmillerv@t-online.de','6508671328'),
(default,'Rivy','Jarret','rjarretw@unicef.org','1110754253'),
(default,'Tandi','Pigott','tpigottx@icq.com','4122443232'),
(default,'Gertrude','Dedden','gdeddeny@dedecms.com','8559514600'),
(default,'Noemi','Coalbran','ncoalbranz@netscape.com','7677476176'),
(default,'Charlton','Bench','cbench10@list-manage.com','2691846232'),
(default,'Saundra','Kaasmann','skaasmann11@zimbio.com','9448668383'),
(default,'Zea','Hugenin','zhugenin12@cdc.gov','6053947045'),
(default,'Caprice','Delacoste','cdelacoste13@tmall.com','7497345698'),
(default,'Felisha','Cogin','fcogin14@wikispaces.com','3359902452'),
(default,'Merrel','MacConnechie','mmacconnechie15@mysql.com','4456263498'),
(default,'Clayson','Dearman','cdearman16@vk.com','3854495540'),
(default,'Sheff','Caley','scaley17@photobucket.com','7075634048'),
(default,'Lonny','Gladwish','lgladwish18@pbs.org','1695331830'),
(default,'Nathanil','O''Cosgra','nocosgra19@aboutads.info','3602301244'),
(default,'Yul','Kendell','ykendell1a@npr.org','2265758433'),
(default,'Norrie','Povlsen','npovlsen1b@independent.co.uk','5441776074'),
(default,'Humberto','Ciccotti','hciccotti1c@quantcast.com','1410268252'),
(default,'Norby','Chisnall','nchisnall1d@storify.com','1018875087'),
(default,'Karry','Cota','kcota1e@ameblo.jp','3477292233'),
(default,'Sherwood','Lechmere','slechmere1f@free.fr','9795679956'),
(default,'Fabiano','Traviss','ftraviss1g@apache.org','9306173093'),
(default,'Kiele','Rahl','krahl1h@vkontakte.ru','9928874497'),
(default,'Consolata','Elverston','celverston1i@mac.com','1968315400'),
(default,'Marita','Jodlkowski','mjodlkowski1j@phpbb.com','4453191693'),
(default,'Vallie','Inger','vinger1k@163.com','4362560617'),
(default,'Levon','Suttie','lsuttie1l@linkedin.com','5656202986'),
(default,'Lizbeth','McIlwrath','lmcilwrath1m@meetup.com','8117927850'),
(default,'Jannel','Carnell','jcarnell1n@bizjournals.com','2730894867'),
(default,'Osbert','Flay','oflay1o@fastcompany.com','3830591711'),
(default,'Harriet','Dowglass','hdowglass1p@e-recht24.de','5185612118'),
(default,'Cale','Cayford','ccayford1q@chicagotribune.com','1219159549'),
(default,'Elaine','Twining','etwining1r@walmart.com','5132114897'),
(default,'Bogey','Cornils','bcornils1s@chicagotribune.com','4249888510');


insert into PromotionalEvent (restaurant_id, admin_id, description) values (7, 10, 'integer pede justo lacinia eget tincidunt eget');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (3, 41, 'vivamus vestibulum sagittis sapien cum sociis natoque penatibus');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (16, 3, 'nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (13, 34, 'ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (41, 55, 'suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (18, 35, 'sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (32, 6, 'suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (33, 5, 'massa donec dapibus duis at velit eu');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (30, 46, 'odio odio elementum eu interdum eu tincidunt in');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (33, 42, 'blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (43, 4, 'id mauris vulputate elementum nullam varius');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (41, 51, 'curabitur at ipsum ac tellus semper interdum mauris ullamcorper');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (7, 31, 'ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (11, 10, 'nec sem duis aliquam convallis nunc proin at turpis a pede posuere');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (50, 15, 'purus aliquet at feugiat non pretium');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (10, 30, 'hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (48, 39, 'neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (36, 43, 'orci vehicula condimentum curabitur in libero ut massa volutpat');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (12, 33, 'donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (36, 5, 'eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (45, 25, 'in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (45, 35, 'eleifend pede libero quis orci');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (44, 33, 'at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (32, 62, 'purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (29, 21, 'quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (41, 47, 'sapien cum sociis natoque penatibus et magnis dis parturient');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (43, 38, 'vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (9, 21, 'elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (9, 65, 'suscipit nulla elit ac nulla sed vel enim sit');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (18, 7, 'semper porta volutpat quam pede lobortis ligula sit amet eleifend pede');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (42, 59, 'rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (34, 62, 'cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (50, 51, 'cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (11, 60, 'eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (16, 64, 'mollis molestie lorem quisque ut erat curabitur');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (39, 23, 'vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (25, 58, 'semper porta volutpat quam pede lobortis');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (8, 5, 'pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (45, 27, 'pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (2, 28, 'odio cras mi pede malesuada');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (39, 14, 'mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (1, 53, 'amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (49, 17, 'cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (24, 43, 'et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (9, 24, 'tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (15, 44, 'ultrices posuere cubilia curae nulla dapibus dolor');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (6, 51, 'sodales scelerisque mauris sit amet eros suspendisse accumsan tortor');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (44, 25, 'faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (39, 61, 'porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (33, 35, 'ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (45, 60, 'duis aliquam convallis nunc proin at turpis');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (10, 10, 'rutrum ac lobortis vel dapibus at');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (27, 1, 'eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (13, 65, 'sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (34, 8, 'est congue elementum in hac habitasse');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (22, 29, 'rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (50, 17, 'ut nunc vestibulum ante ipsum primis in faucibus orci');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (47, 49, 'ut at dolor quis odio consequat varius integer ac leo pellentesque');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (45, 2, 'sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (15, 25, 'tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (41, 19, 'feugiat non pretium quis lectus suspendisse');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (7, 65, 'fusce lacus purus aliquet at feugiat non');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (15, 13, 'non sodales sed tincidunt eu felis fusce posuere felis sed');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (26, 6, 'eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (23, 8, 'in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (27, 60, 'mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (44, 31, 'ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (28, 22, 'elit sodales scelerisque mauris sit');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (31, 16, 'platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (20, 32, 'non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (22, 47, 'ut erat curabitur gravida nisi at nibh in');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (37, 43, 'adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (3, 9, 'ut nulla sed accumsan felis');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (41, 24, 'ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (30, 58, 'sapien cursus vestibulum proin eu mi');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (2, 50, 'erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (29, 51, 'ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (18, 14, 'etiam vel augue vestibulum rutrum rutrum neque aenean auctor');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (37, 51, 'lectus aliquam sit amet diam');
insert into PromotionalEvent (restaurant_id, admin_id, description) values (49, 39, 'tellus nulla ut erat id mauris vulputate elementum nullam varius nulla');


INSERT INTO RestaurantOwnerAccount VALUES
(default, 1, 'Washington', 'Yukhnev', 'wyukhnev0@shinystat.com'),
(default, 2, 'Philippine', 'Laville', 'plaville1@bloomberg.com'),
(default, 3, 'Adriaens', 'Daspar', 'adaspar2@bravesites.com'),
(default, 4, 'Nert', 'Awcock', 'nawcock3@gizmodo.com'),
(default, 5, 'Tami', 'Van Hove', 'tvanhove4@yelp.com'),
(default, 6, 'Ingelbert', 'Farrent', 'ifarrent5@imdb.com'),
(default, 7, 'Alonzo', 'Quarterman', 'aquarterman6@hugedomains.com'),
(default, 8, 'Lenka', 'Lugg', 'llugg7@digg.com'),
(default, 9, 'Waly', 'Lowbridge', 'wlowbridge8@so-net.ne.jp'),
(default, 10, 'Elihu', 'Poupard', 'epoupard9@etsy.com'),
(default, 11, 'Valentino', 'MacConnechie', 'vmacconnechiea@nih.gov'),
(default, 12, 'Damiano', 'Tregidga', 'dtregidgab@walmart.com'),
(default, 13, 'Karlotta', 'Frisdick', 'kfrisdickc@cnbc.com'),
(default, 14, 'Orazio', 'Jozsika', 'ojozsikad@bloglines.com'),
(default, 15, 'Giorgi', 'Mulhall', 'gmulhalle@odnoklassniki.ru'),
(default, 16, 'Whitney', 'Crimes', 'wcrimesf@a8.net'),
(default, 17, 'Dorine', 'Koppel', 'dkoppelg@freewebs.com'),
(default, 18, 'Efrem', 'Hartropp', 'ehartropph@opera.com'),
(default, 19, 'Klarika', 'Fetterplace', 'kfetterplacei@amazonaws.com'),
(default, 20, 'Sully', 'Poltone', 'spoltonej@ameblo.jp'),
(default, 21, 'Cornela', 'Lait', 'claitk@etsy.com'),
(default, 22, 'Damon', 'Pitbladdo', 'dpitbladdol@spotify.com'),
(default, 23, 'Carlee', 'Whyborn', 'cwhybornm@ihg.com'),
(default, 24, 'Ruperto', 'Sculley', 'rsculleyn@squarespace.com'),
(default, 25, 'Augustin', 'Sandford', 'asandfordo@ask.com'),
(default, 26, 'Amara', 'Berrick', 'aberrickp@domainmarket.com'),
(default, 27, 'Dredi', 'Hibling', 'dhiblingq@google.fr'),
(default, 28, 'Ardith', 'Yeld', 'ayeldr@parallels.com'),
(default, 29, 'Cary', 'Fermin', 'cfermins@opensource.org'),
(default, 30, 'Averill', 'Chantler', 'achantlert@dailymotion.com'),
(default, 31, 'Carson', 'Jaskiewicz', 'cjaskiewiczu@360.cn'),
(default, 32, 'Rebekah', 'Attac', 'rattacv@surveymonkey.com'),
(default, 33, 'Norah', 'Cristofaro', 'ncristofarow@bing.com'),
(default, 34, 'Susann', 'Gammons', 'sgammonsx@geocities.com'),
(default, 35, 'Cleon', 'Shilleto', 'cshilletoy@tuttocitta.it'),
(default, 36, 'Valeda', 'Kinig', 'vkinigz@amazon.com'),
(default, 37, 'Amelita', 'Pesic', 'apesic10@example.com'),
(default, 38, 'Pat', 'Lamport', 'plamport11@columbia.edu'),
(default, 39, 'Myriam', 'Lyst', 'mlyst12@apache.org'),
(default, 40, 'Ugo', 'Skeldinge', 'uskeldinge13@wikispaces.com'),
(default, 41, 'Aurilia', 'McGairl', 'amcgairl14@last.fm'),
(default, 42, 'Efren', 'Toone', 'etoone15@technorati.com'),
(default, 43, 'Alasteir', 'Atcock', 'aatcock16@cyberchimps.com'),
(default, 44, 'Nicky', 'Medford', 'nmedford17@msu.edu'),
(default, 45, 'Trumann', 'Creer', 'tcreer18@tinyurl.com'),
(default, 46, 'June', 'Trood', 'jtrood19@joomla.org'),
(default, 47, 'Elliott', 'Yeudall', 'eyeudall1a@webs.com'),
(default, 48, 'Edd', 'Castelli', 'ecastelli1b@forbes.com'),
(default, 49, 'Pavel', 'Kelsow', 'pkelsow1c@unblog.fr'),
(default, 50, 'Gorden', 'Adhams', 'gadhams1d@ask.com');
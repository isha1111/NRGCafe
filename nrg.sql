CREATE DATABASE nrg;

\c nrg

CREATE TABLE dishes(
  id serial4 PRIMARY KEY,
  name VARCHAR(50),
  description VARCHAR(500),
  price VARCHAR(5),
  photo VARCHAR(900),
  dish_type_id VARCHAR(10)
);

CREATE TABLE dish_types(
  id serial4 PRIMARY KEY,
  dish_type VARCHAR(10)
);

CREATE TABLE users(
  id serial4 PRIMARY KEY,
  username VARCHAR(10) NOT NULL,
  email VARCHAR(20) NOT NULL,
  password_digest VARCHAR(100) NOT NULL
);

-- CREATE TABLE orders(
--   id serial4 PRIMARY KEY,
--   user_username VARCHAR(10) NOT NULL,
--   dish_names VARCHAR(500) NOT NULL
-- );
CREATE TABLE orders(
  id serial4 PRIMARY KEY,
  user_username VARCHAR(10) NOT NULL,
  time VARCHAR(40)
);

CREATE TABLE dish_orders(
  id serial4 PRIMARY KEY,
  dish_id INTEGER,
  order_id INTEGER
);

CREATE TABLE reservations(
  id serial4 PRIMARY KEY,
  user_id INTEGER DEFAULT 0,
  name VARCHAR(20),
  email VARCHAR(50),
  phone VARCHAR(20),
  people VARCHAR(2),
  date TIMESTAMP
);

INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Spaghetti Chilli Prawns','Spaghetti with prawns salmon and parmeson crisps','16.90','','3');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Fettucine Chicken Avocado','Fettucine with Chicken,avocado and parmeson crisps','14.50','','3');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Big Breakfast','Eggs, Toast, Hashbrown, sausage, Tomato, Mush, Bacon, and Beans','16.90','','1');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Plain Toast','two piece of toast with butter/jam/vegimite','4.50','','1');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Fruit Toast','two piece of Raisin toast with butter/jam/vegimite','5.50','','1');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Fish & Chips','Fish with chips and salad','16.50','','3');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Chicken Parmigiana','Parmigiana with chips and salad','16.50','','3');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Fruit Bowl','Fresh fruits with yoghurt','8.50','','1');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Spanish Eggs','Bacon Chorizo Beans with spices and eggs','16.50','','1');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Kids fish chips','fish with chips','8.50','','5');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Chicken and veg soup','soup','9.50','','2');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Pumpkin soup','soup','9.50','','2');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Garden Salad','soup','12.50','','4');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Greek Salad','Veggeies with feeta and dressing','13.50','http://thedeluxerestaurant.com/wp-content/uploads/2013/11/Salad.jpg','4');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Chicken Avocade Salad','Veggeies with chicken and avocado','15.50','https://www.liverdoctor.com/wp-content/uploads/2015/04/chicken-pumpkin-salad-w-660x330.jpg','4');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Kids Pancake','Pancake with maple syrup and ice cream','8.50','http://www.cookrepublic.com/images/photojournal/pancakes03.jpg','5');
INSERT INTO dish_types (dish_type) VALUES ('breakfast');
INSERT INTO dish_types (dish_type) VALUES ('starter');
INSERT INTO dish_types (dish_type) VALUES ('lunch');
INSERT INTO dish_types(dish_type) VALUES ('salad');
INSERT INTO dish_types(dish_type) VALUES ('kids');

UPDATE dishes SET photo = '/img/garden-salad.jpg' where name = 'Garden Salad';
UPDATE dishes SET photo = '/img/pumpkin-soup.jpg' where name = 'Pumpkin soup';
UPDATE dishes SET photo = '/img/chicken-soup.jpg' where name = 'Chicken and veg soup';
UPDATE dishes SET photo = '/img/fish-chips.jpg' where name = 'Kids fish chips';
UPDATE dishes SET photo = '/img/spanish-eggs.jpg' where name = 'Spanish Eggs';
UPDATE dishes SET photo = '/img/fruit-bowl.jpg' where name = 'Fruit Bowl';
UPDATE dishes SET photo = '/img/parmigiana.jpg' where name = 'Chicken Parmigiana';
UPDATE dishes SET photo = '/img/fruit-toast.jpg' where name = 'Fruit Toast';
UPDATE dishes SET photo = '/img/fFettucine-Chicken-Avocado.jpg' where name = 'Fettucine Chicken Avocado';
UPDATE dishes SET photo = '/img/Spaghetti-Chilli-Prawns.jpg' where name = 'Spaghetti Chilli Prawns';
UPDATE dishes SET photo = '/img/Big-Breakfast.jpg' where name = 'Big Breakfast';
UPDATE dishes SET photo = '/img/Fish-Chips.jpg' where name = 'Fish & Chips';

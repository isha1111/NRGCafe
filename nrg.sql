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
  username VARCHAR(10),
  email VARCHAR(20),
  password_digest VARCHAR(10)
);

INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Spaghetti Chilli Prawns','Spaghetti with prawns salmon and parmeson crisps','16.90','','3');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Fettucine Chicken Avocado','Fettucine with Chicken,avocado and parmeson crisps','14.50','','3');
INSERT INTO dishes(name,description,price,photo,dish_type_id) VALUES ('Big Breakfast','Eggs, Toast, Hashbrown, sausage, Tomato, Mush, Bacon, and Beans','16.90','','3');
INSERT INTO dish_types (dish_type) VALUES ('breakfast');
INSERT INTO dish_types (dish_type) VALUES ('starter');
INSERT INTO dish_types (dish_type) VALUES ('lunch');
INSERT INTO dish_types(dish_type) VALUES ('salad');
INSERT INTO dish_types(dish_type) VALUES ('kids');

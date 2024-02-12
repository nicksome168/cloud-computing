CREATE DATABASE cnainventory;
\c cnainventory;
CREATE TABLE inventory (
    id serial PRIMARY KEY,
    name VARCHAR(50),
    quantity INTEGER,
    date DATE NOT NULL DEFAULT NOW()::date
);
\dt;
INSERT INTO inventory (id, name, quantity) VALUES (1, 'yogurt', 200);
INSERT INTO inventory (id, name, quantity) VALUES (2, 'milk', 100);
SELECT * FROM inventory;
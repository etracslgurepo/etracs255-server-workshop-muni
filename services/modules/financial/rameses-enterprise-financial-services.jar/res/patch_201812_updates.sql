ALTER TABLE itemaccount ADD COLUMN hidefromlookup INT;
UPDATE itemaccount SET hidefromlookup = 0;
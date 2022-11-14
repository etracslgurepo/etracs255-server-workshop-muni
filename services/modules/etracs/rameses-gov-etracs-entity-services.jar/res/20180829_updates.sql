ALTER TABLE entityjuridical ADD COLUMN administrator_objid varchar(50);
ALTER TABLE entityjuridical ADD COLUMN administrator_address_objid varchar(50);
ALTER TABLE entityjuridical RENAME COLUMN administrator_address administrator_address_text varchar(255);

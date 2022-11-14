

ALTER TABLE entity ADD COLUMN state VARCHAR(10);
UPDATE entity SET state='ACTIVE';
ALTER TABLE `entity` ADD INDEX `ix_state` (`state`);

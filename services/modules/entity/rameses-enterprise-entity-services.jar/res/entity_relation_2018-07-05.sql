CREATE TABLE IF NOT EXISTS `entity_relation_type` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `gender` varchar(1) DEFAULT NULL,
  `inverse_any` varchar(50) DEFAULT NULL,
  `inverse_male` varchar(50) DEFAULT NULL,
  `inverse_female` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

DROP TABLE IF EXISTS entity_relation
;

CREATE TABLE IF NOT EXISTS `entity_relation` (
  `objid` varchar(50) NOT NULL,
  `entity_objid` varchar(50) DEFAULT NULL,
  `relateto_objid` varchar(50) DEFAULT NULL,
  `relation_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_sender_receiver` (`entity_objid`,`relateto_objid`),
  KEY `ix_entity_objid` (`entity_objid`),
  KEY `ix_relateto_objid` (`relateto_objid`),
  KEY `ix_relation_objid` (`relation_objid`),
  CONSTRAINT `fk_entity_relation_relation` FOREIGN KEY (`relation_objid`) REFERENCES `entity_relation_type` (`objid`),
  CONSTRAINT `fk_entity_relation_entity_objid` FOREIGN KEY (`entity_objid`) REFERENCES `entity` (`objid`),
  CONSTRAINT `fk_entity_relation_relation_objid` FOREIGN KEY (`relateto_objid`) REFERENCES `entity` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`)
VALUES
  ('AUNT','F','NEPHEW/NIECE','NEPHEW','NIECE'),
  ('BROTHER','M','SIBLING','BROTHER','SISTER'),
  ('COUSIN',NULL,'COUSIN','COUSIN','COUSIN'),
  ('DAUGHTER','F','PARENT','FATHER','MOTHER'),
  ('FATHER','M','CHILD','SON','DAUGHTER'),
  ('GRANDDAUGHTER','F','GRANDPARENT','GRANDFATHER','GRANDMOTHER'),
  ('GRANDSON','M','GRANDPARENT','GRANDFATHER','GRANDMOTHER'),
  ('HUSBAND','M','SPOUSE','SPOUSE','WIFE'),
  ('MOTHER','F','CHILD','SON','DAUGHTER'),
  ('NEPHEW','M','UNCLE/AUNT','UNCLE','AUNT'),
  ('NIECE','F','UNCLE/AUNT','UNCLE','AUNT'),
  ('SISTER','F','SIBLING','BROTHER','SISTER'),
  ('SON','M','PARENT','FATHER','MOTHER'),
  ('SPOUSE',NULL,'SPOUSE','HUSBAND','WIFE'),
  ('UNCLE','M','NEPHEW/NIECE','NEPHEW','NIECE'),
  ('WIFE','F','SPOUSE','HUSBAND','SPOUSE')
;

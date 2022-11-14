DROP VIEW daily_collection;
CREATE VIEW daily_collection AS 
SELECT 
  objid,
  YEAR(dtposted) AS `year`,
  MONTH(dtposted) AS `month`,
  DAY(dtposted) AS `day`,
  DATE_FORMAT(dtposted, '%Y-%m-%d') AS txndate,
  liquidatingofficer_name AS liquidatingofficer,
  amount,
  posted 
FROM liquidation;
alter table sys_usergroup_member add column `state` varchar(10) NULL after `objid`;
UPDATE sys_usergroup_member SET state='DRAFT';
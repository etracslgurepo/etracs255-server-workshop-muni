[deleteCompleted]
delete from rpt_syncdata 
where not exists (select * from rpt_syncdata_item where parentid = rpt_syncdata.objid)
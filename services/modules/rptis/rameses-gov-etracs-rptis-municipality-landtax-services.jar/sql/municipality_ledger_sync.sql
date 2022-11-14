[getLedgersForSync]
select * from zzztmp_rptledgers_forsync_with_province

[clearLedgersForSync]
delete from zzztmp_rptledgers_forsync_with_province

[deleteLedger]
delete from zzztmp_rptledgers_forsync_with_province where objid = $P{objid}
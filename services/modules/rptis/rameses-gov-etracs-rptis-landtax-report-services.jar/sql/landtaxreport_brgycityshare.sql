[getBarangays]
select 
	b.indexno as brgyindex, 
	b.name as brgyname,
	0 as basictotal,
	0 as basic30,
	0 as brgyshare,
	0 as commonshare
from barangay b
order by b.indexno 

[getCollectionsByBarangay]
select   
	b.indexno as brgyindex, 
	b.name as brgyname,
	sum(rs.amount) as basictotal,
	sum(case when rs.sharetype = 'barangay' then rs.amount else 0 end) as basic30,
	0 as brgyshare,
	0 as commonshare
from remittance rem 
	inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
	inner join cashreceipt cr on cr.remittanceid = rem.objid 
	inner join rptpayment rp on cr.objid = rp.receiptid 
	inner join rptpayment_share rs on rp.objid = rs.parentid
	left join rptledger rl on rp.refid = rl.objid 
	left join barangay b on rl.barangayid = b.objid 
where ${filter} 
	and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
	and rs.revperiod <> 'advance' 
	and rs.revtype in ('basic', 'basicint')
group by b.indexno, b.name
order by b.indexno



[getBarangayMainShare]
select   
	b.indexno as brgyindex, 
	b.name as brgyname,
	sum(rs.amount) as brgyshare
from remittance rem 
	inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
	inner join cashreceipt cr on cr.remittanceid = rem.objid 
	inner join rptpayment rp on cr.objid = rp.receiptid 
	inner join rptpayment_share rs on rp.objid = rs.parentid
	left join rptledger rl on rp.refid = rl.objid 
	left join barangay b on rl.barangayid = b.objid 
where ${filter} 
	and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
	and rs.sharetype = 'barangay'
	and rs.revperiod <> 'advance' 
	and rs.revtype in ('basic', 'basicint')
	and (rs.iscommon is null or rs.iscommon <> 1 ) 
group by b.indexno, b.name

[getBarangayCommonShare]
select   
	b.indexno as brgyindex, 
	b.name as brgyname,
	sum(rs.amount) as commonshare
from remittance rem 
	inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
	inner join cashreceipt cr on cr.remittanceid = rem.objid 
	inner join rptpayment rp on cr.objid = rp.receiptid 
	inner join rptpayment_share rs on rp.objid = rs.parentid
	inner join itemaccount ia on rs.item_objid = ia.objid 
	left join barangay b on ia.org_objid = b.objid 
where ${filter} 
	and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
	and rs.sharetype = 'barangay'
	and rs.revperiod <> 'advance' 
	and rs.revtype in ('basic', 'basicint')
	and rs.iscommon = 1 
group by b.indexno, b.name

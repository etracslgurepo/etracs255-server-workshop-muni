[getPayments]
select 
  owner_name,
  tdno,
  classification,
  rputype,
  barangay,
  sum(amount) as amount 
from vw_real_property_payment
where ${filter}
and year = $P{year}
and voided = 0
group by 
  owner_name,
  tdno,
  classification,
  rputype,
  barangay
order by owner_name, tdno
[getList]
SELECT * FROM business_change_log 
WHERE applicationid=$P{applicationid}
ORDER BY dtfiled DESC

[getListByBusiness]
SELECT * FROM business_change_log 
WHERE businessid=$P{businessid}
ORDER BY dtfiled DESC

#businessname
[updateBusinessname]
UPDATE business SET businessname=$P{businessname} WHERE objid=$P{businessid}

#tradename
[updateBusinessTradename]
UPDATE business SET tradename=$P{tradename} WHERE objid=$P{businessid}

[updateApplicationTradename]
UPDATE business_application SET tradename=$P{tradename} WHERE objid=$P{applicationid}

[updateChildApplicationTradename]
UPDATE business_application SET tradename=$P{tradename} WHERE parentapplicationid=$P{applicationid}

#business address
[updateBusinessBusinessAddress]
UPDATE business SET 
	address_objid=$P{addressid}, address_text=$P{addresstext} 
WHERE objid=$P{businessid}	

[updateApplicationBusinessAddress]
UPDATE business_application SET 
	businessaddress=$P{addresstext} 
WHERE objid=$P{applicationid}

[updateChildApplicationBusinessAddress]
UPDATE business_application SET 
	businessaddress=$P{addresstext} 
WHERE parentapplicationid=$P{applicationid}

#contact
[updateBusinessContact]
UPDATE business SET mobileno=$P{mobileno},
phoneno=$P{phoneno},
email=$P{email} WHERE objid=$P{businessid}

#change owner
[changeBusinessOwnerName]
UPDATE business SET 
	owner_name=$P{ownername}, owner_objid=$P{ownerid}, 
	orgtype=$P{orgtype}, owner_address_text=$P{owneraddress}, 
	owner_address_objid=$P{owneraddressid}
WHERE objid=$P{businessid}

[changeApplicationOwnerName]
UPDATE business_application SET 
	ownername=$P{ownername} 
WHERE objid=$P{applicationid}

[changeChildApplicationOwnerName]
UPDATE business_application SET 
	ownername=$P{ownername} 
WHERE parentapplicationid=$P{applicationid}

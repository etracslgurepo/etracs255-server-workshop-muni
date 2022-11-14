package rptis.landtax.actions;

import com.rameses.rules.common.*;
import rptis.landtax.facts.*;



public class AddShare implements RuleActionHandler {
	def request
	def em_mapping 
	def numSvc

	/* params:
	*      - billitem, orgclass, orgid, payableparentacct, expr, rate
	*/		
	public void execute(def params, def drools) {
		def payableaccts = getPayableAccounts(params)
		payableaccts.each{pa -> 
			def share = createShare(params, pa)
			if (params.billitem.discount > 0){
				share.discount = numSvc.roundA(params.billitem.discount * params.rate.decimalValue, 4)
			}
			params.billitem.addShare(share)
			request.shares << share 
		}
	}

	def getPayableAccounts(params){
		def p = [:]
		p.parentid = params.payableparentacct.key
		p.orgclass = params.orgclass 
		p.orgid = (params.orgid ? params.orgid : '%')
		return em_mapping.where('parent_objid = :parentid and org_objid like :orgid and org_class like :orgclass', p).list() 
	}

	def createShare(params, payableacct){
		def billitem = params.billitem.toMap()
		def amtdue = params.amtdue.decimalValue
		return [
			revtype 	: billitem.revtype,
			revperiod	: billitem.revperiod,
			refitem     : params.billitem.account.toMap(),
			sharetype 	: payableacct.org.class,
			payableitem : payableacct.item,
			amount 		: numSvc.roundA(amtdue * params.rate.decimalValue, 4),
			discount 	: 0,
		]
	}
}	

package rptis.landtax.actions;

import com.rameses.rules.common.*;
import rptis.landtax.facts.*;

public class SplitByQtr implements RuleActionHandler {
	def numSvc 
	def request

	public void execute(def params, def drools) {
		def item = params.rptledgeritem
		def amtpaid = item.amtpaid 

		drools.retract(item)
		request.facts.remove(item)
		request.items.remove(item.entity)

		def qtrlyvalues = buildQtrlyValues(item)

		for( int qtr=1; qtr<=4; qtr++){
			def qifact = createLedgerItemFact(item, qtr, qtrlyvalues[qtr])
			if (amtpaid >= qifact.amount){
				amtpaid -= qifact.amount 
			}
			else {
				if (amtpaid > 0){
					qifact.amtpaid = amtpaid 
					qifact.amtdue = qifact.amount - amtpaid
					amtpaid = 0
				}
				request.facts << qifact 
				request.items << qifact.entity 
				drools.insert(qifact)
			}
		}
	}

	def buildQtrlyValues(item){
		def amount13 = numSvc.round(item.amount / 4)
		def amount4 = numSvc.round(item.amount - (amount13 * 3))

		def qv = []
		qv[0] = [amount:amount13]
		qv[1] = [amount:amount13]
		qv[2] = [amount:amount13]
		qv[3] = [amount:amount13]
		qv[4] = [amount:amount4]
		return qv 
	}

	def createLedgerItemFact(item, qtr, qtrav){
		def entity = item.entity.clone();
		entity.qtr = qtr 
		
		def qi = new RPTLedgerItemFact(item.ledger, entity)
		qi.amount = qtrav.amount
		qi.amtpaid = 0
		qi.amtdue = qtrav.amount
		qi.interest = 0
		qi.discount = 0
		qi.qtrly = true
		return qi 
	}
}
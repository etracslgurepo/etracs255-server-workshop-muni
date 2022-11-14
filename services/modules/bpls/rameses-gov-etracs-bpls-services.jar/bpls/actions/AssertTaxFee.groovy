package bpls.actions;

import com.rameses.rules.common.*;
import bpls.facts.*;



public class AssertTaxFee implements RuleActionHandler {
	def ruleSvc;
	def request;

	public void execute(def type, def drools) {
		def facts = request.facts;
		def taxfees = request.taxfees;
		def taxfeefacts = request.taxfeefacts;
		def testlist = [];

		for(it in taxfeefacts) {
			def bt = new TaxFeeAccount();
			bt.objid = it.objid;
			bt.acctid = it.account.objid;
			if(it.lob?.objid) {
				//find the LOB
				bt.lob = facts.find{ z-> (z instanceof bpls.facts.LOB) && z.lobid==it.lob.objid };
			} 
			bt.name = it.account.title;
			bt.amount = it.amount;
			bt.type = it.taxfeetype;
			bt.assessedvalue = it.assessedvalue;
			bt.data = it;
			bt.highest = false;
			bt.lowest = false;
			bt.tag = it.tag; 
			bt.flag = it.flag;
			testlist << bt;
			facts << bt;
		}

		//mark the highest and lowest taxfees. reset first all
		def slist = facts.findAll{it instanceof bpls.facts.TaxFeeAccount}.findAll{it.lob?.objid!=null}; 
		slist.each { 
			it.highest = false;
			it.lowest = false;		
		}

		def grps = slist.groupBy{ [it.acctid ] };
		grps.each {k,v->
			v.max{ it.amount }.highest = true;	
			v.min{ it.amount }.lowest = true;	
		};

		/*
		if( request.phasename == 'postsummary') {
			facts.findAll{it instanceof bpls.facts.TaxFeeAccount}.each {
				println it.name + " " + it.amount + " highest->"+it.highest + " lowest->"+it.lowest;
			}		
		}
		*/
	}
}
package rptis.landtax.actions

import com.rameses.rules.common.*
import enterprise.facts.*;
import rptis.landtax.facts.*
import treasury.facts.*;
import treasury.utils.ItemAccountUtil

public class AddBillItem implements RuleActionHandler {
	def request
	def em_mapping
	def em_org  

	public void execute(def params, def drools) {
		def taxsummary = params.taxsummary
		params.revtype = params.taxsummary.revtype
		params.revperiod = params.taxsummary.revperiod 

		// add tax account
		if (taxsummary.amount > 0){
			def billitem = createBillItem(params, params.revtype)
			billitem.amount = taxsummary.amount - taxsummary.discount
			billitem.discount = taxsummary.discount
			request.facts << billitem 
			request.billitems << billitem.toMap()
		}

		// add penalty account
		if (taxsummary.interest > 0){
			def billitem = createBillItem(params, params.revtype+'int')
			billitem.amount = taxsummary.interest
			request.facts << billitem 
			request.billitems << billitem.toMap()
		}
	}

	def createBillItem(params, revtype){
		def billitem = new RPTBillItem()
		billitem.account = getAccount(params, revtype)
		billitem.revtype = revtype
		billitem.revperiod = params.revperiod
		billitem.sharetype = billitem.account.org.type.toLowerCase()
		billitem.amount = 0
		billitem.discount = 0
		billitem.share = 0 
		billitem.sharedisc = 0 
		return billitem 
	}

	def getAccount(params, revtype){
		def org = em_org.select('objid,name,orgclass,root').find([root:1]).first()
		if (!org) throw new Exception('AddBillItem [ERROR]: root org is not set.')
		
		params.revtype = revtype

		def p = [org_objid:org.objid]
		p.item_tag = 'rpt_' + params.revtype + '_' + params.revperiod
		def mapping = em_mapping.find(p).first()
		if (!mapping) {
			def s = params.revperiod + ' ' + params.revtype 
			throw new Exception('Item account for  ' + s + ' for ' + org.name + ' is not defined.')
		}

		def acct = new Account()
		acct.fund = createFund(mapping)
		acct.objid = mapping.item.objid 
		acct.code = mapping.item.code
		acct.title = mapping.item.title 
		acct.sortorder = 0
		acct.org = createOrg(org)

		def parentacct = new Account()
		parentacct.fund = createFund(mapping)
		parentacct.objid = mapping.parent.objid 
		parentacct.code = mapping.parent.code
		parentacct.title = mapping.parent.title 
		parentacct.sortorder = 0
		parentacct.org = createOrg(org)
		acct.parentaccount = parentacct 
		return acct 
	}

	def createFund(mapping){
		return new Fund(objid: mapping.item.fund.objid, code: mapping.item.fund.code, title: mapping.item.fund.title)
	}

	def createOrg(org){
		new Org(orgid: org.objid, type: org.orgclass.toLowerCase(), root: (org.root == 1))
	}
}	


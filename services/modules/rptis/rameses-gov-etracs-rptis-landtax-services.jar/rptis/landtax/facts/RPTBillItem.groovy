package rptis.landtax.facts;

import treasury.facts.Account

public class RPTBillItem
{
    Account account 
    String revtype
    String revperiod 
    String sharetype 
    Double amount 
    Double discount
    Double share 
    Double sharedisc 

    def entity

    String getAcctid(){
        return account.objid 
    }

    String getParentacctid(){
        return account?.parentaccount?.objid
    }

    public void addShare(share){
        entity.share += share.amount 
        entity.sharedisc += share.discount 
    }

    def toMap(){
        if (!entity){
        	entity = [:]
        	entity.item = account.toMap()
        	entity.revtype = revtype
        	entity.revperiod = revperiod 
        	entity.sharetype = sharetype 
        	entity.amount = amount 
            entity.discount = discount 
            entity.share = share 
        	entity.sharedisc = sharedisc
        }
    	return entity
    }
}

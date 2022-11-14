package treasury.utils;

import treasury.facts.*;
import enterprise.facts.*;
import enterprise.utils.*;

public class FactBuilder {
	
	VariableInfoProvider variableInfoProvider = new DefaultVariableInfoProvider();
	BillItemProvider billItemProvider = new BillItemProvider();
	
	def facts = [];	


	//resultHandler requires two arguments
	RuleOutputHandler outputHandler;

	/*
	public VariableInfo getInfoFact( def o ) {
		return new VariableInfo( o );
	}	

	public BillItem getBillItemFact( def o ) {
		return new BillItem(o);
	}

	public Requirement getRequirementFact(def o) {
		return new Requirement(o);
	}
	*/

	public void addInfos( def infos ) {
		if(!infos) return;
		infos.each { info ->
			facts <<  variableInfoProvider.createFact(info) ;
		}
	}

	public void addBillItems( def billitems ) {
		if(!billitems) return;
		billitems.each { billitem ->
			facts <<  billItemProvider.createFact(billitem) ;
		}
	}

}
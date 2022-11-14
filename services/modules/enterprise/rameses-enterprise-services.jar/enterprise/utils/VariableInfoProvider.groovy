package enterprise.utils;

import enterprise.facts.*;

public abstract class VariableInfoProvider {

	abstract String getSchemaName();

	public def createFact(dd) {
		def cf = null;	
		if(dd.datatype == "integer") {
			if(!createIntegerFact) createIntegerFact = { new enterprise.facts.IntegerInfo() };
			cf = createIntegerFact();
		}
		else if(dd.datatype == "decimal") {
			if(!createDecimalFact) createDecimalFact = { new enterprise.facts.DecimalInfo() };
			cf = createDecimalFact();
		}
		else if(dd.datatype == "boolean") {
			if(!createBooleanFact) createBooleanFact = { new enterprise.facts.BooleanInfo() };
			cf = createBooleanFact();
		}
		else if(dd.datatype == "string") {
			if(!createStringFact) createStringFact = { new enterprise.facts.StringInfo() };
			cf = createStringFact();
		}
		else if(dd.datatype == "date") {
			if(!createDateFact) createDateFact = { new enterprise.facts.DateInfo() };
			cf = createDateFact();
		}
		else if(dd.datatype == "string_array") {
			if(!createStringArrayFact) createStringArrayFact = { new enterprise.facts.StringArrayInfo() };
			cf = createStringArrayFact();
		}
		else {
			if(!createObjectFact) 
				throw new Exception("createObjectFact not implemented " + dd.datatype );
			cf = createObjectFact();
		}
		
		//copy the data of the fact;
		cf.copy(dd);
		return cf;
	};

	def createDecimalFact;
	def createIntegerFact ;
	def createBooleanFact;
	def createStringFact;
	def createStringArrayFact;
	def createDateFact;
	def createObjectFact;

}
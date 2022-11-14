package bpls.actions;

import java.rmi.server.*;

public abstract class AbstractBusinessInfoAction {
	
	def BV;
	String infotype;

	def getInfo( def entity, def newinfos, def lob, def attrid, def val, def phase ) {
		//check first if info already exists. test is a list
		def test = null;
		if( !lob ) {
			test = entity.infos.findAll{ it.lob?.objid == null && it.attribute.objid == attrid };
			if(!test) {
				test = newinfos.findAll{it.lob?.objid==null && it.attribute.objid == attrid };
			}	
		}
		else {
			test = entity.infos.findAll{ it.lob?.objid!=null && it.lob.objid == lob.objid && it.attribute.objid == attrid };
			if(!test) {
				test =  newinfos.findAll{ it.lob?.objid!=null && it.lob.objid == lob.objid && it.attribute.objid == attrid };
			}
		}

		if(test) return null;
			
		def info = [objid:"BPINFO"+new UID()];
		info.phase = phase;
		info.infotype = infotype;
		info.attribute = BV.read( [objid: attrid ] );
		//remove desc, state and system.
		info.attribute.remove("description");
		info.attribute.remove("state");
		info.attribute.remove("system");

		if(lob) {
			info.lob = [objid:lob.objid, name:lob.name];
		}

		info.datatype = info.attribute.datatype;
		if(val) {
			String datatype = info.attribute.datatype;
			switch(datatype) {
				case "integer":
					info.value = val.intValue;
					break;
				case "decimal":
					info.value = val.doubleValue;
					break;
				case "string":	
					info.value = val.stringValue;
					break;
				case "boolean":	
					info.value = val.booleanValue;
					break;

				case "date":	
					info.value = val.dateValue;
					break;

			}
		}			
		newinfos << info;
		return info;
	}




}
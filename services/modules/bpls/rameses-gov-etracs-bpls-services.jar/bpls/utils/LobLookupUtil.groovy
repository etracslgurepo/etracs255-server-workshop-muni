package bpls.utils;

import com.rameses.rules.common.*;
import com.rameses.osiris3.common.*;
import com.rameses.util.*;
import treasury.facts.*;

class LobLookupUtil {

	private def map = [:];
	private def lobMap = [:];
	private def svc;

	public def lookup( def lobid) {
		if(svc==null) {
			svc = EntityManagerUtil.lookup( "lob" );
		}
		if( ! map.containsKey(lobid)) {
			def m = svc.find( [objid: lobid] ).first();	
			if( !m ) throw new Exception("Lob not found in lob " + lobid);
			map.put(lobid, m );
		}
		return map.get(lobid);		
	}
 
	public def createLobFact(def id) {
		if(!lobMap.containsKey(id)) {
			def a = lookup( id );
			def lob = new LOB( objid: a.objid, lobid: , name: a.name, classification: );
			lob.attributes 


			/*
		    BPApplication application;
		    String objid; 			
		    String lobid;			
		    String name;
		    String classification;
		    String attributes;
		    String assessmenttype;
		    */
		}
		return lobMap.get( id );
	}


}
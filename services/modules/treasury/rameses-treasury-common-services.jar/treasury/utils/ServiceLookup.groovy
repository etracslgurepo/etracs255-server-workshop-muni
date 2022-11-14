package treasury.utils;

import com.rameses.osiris3.core.TransactionContext;
import com.rameses.osiris3.xconnection.XConnection;

public class ServiceLookup {

	public static def create(String serviceName, String connection ) {
		def txn = TransactionContext.getCurrentContext();
        def ac = txn.getContext();	
		def xconn = ac.getResource(XConnection.class, connection );
		return xconn.create(serviceName, [:] );
	}


}	
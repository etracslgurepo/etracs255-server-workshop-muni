package jasper;
import com.rameses.io.*;

public class MasterTemplateProvider {

	public def getUrl() {
		return getClass().getResource("blank.jrxml");	
	}

	public def getBytes() {
		def io = new IOStream();
		return io.toByteArray( getClass().getResourceAsStream("blank.jrxml") );
	}

} 

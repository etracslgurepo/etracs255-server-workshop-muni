package bpls.facts;

public class SysVariable {
    
    String objid;
    LOB lob;
    String name;
    String stringvalue;
    int intvalue;
    boolean booleanvalue;
    double decimalvalue;
    
    /** Creates a new instance of SysVariable */
    public SysVariable() {
    }
    
    public SysVariable(String datatype, Object value) {
        if(value == null) return;
        datatype = datatype.toLowerCase();
        if( datatype == "decimal" ) {
            decimalvalue = Double.parseDouble(value+"");
        } 
        else if(datatype == "integer") {
            intvalue =  Integer.parseInt(value+"");
        } 
        else if( datatype == "boolean") {
            String v = value.toString().toLowerCase().trim();
            if(v == "1" || v == "true") {
                booleanvalue = true;
            } 
            else {
                booleanvalue = false;
            }
        } 
        else if(datatype.startsWith("string")) {
            stringvalue = (String)value;
        }
    }
    
}

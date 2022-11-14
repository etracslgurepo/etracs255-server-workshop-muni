package bpls.facts;

public class BusinessInfo {
    
    BPApplication application;
    String objid;
    LOB	lob;
    String name;
    String stringvalue;
    int intvalue;
    boolean booleanvalue;
    double decimalvalue;
    int year;   //this is for late renewal support
    int qtr;    //this is for qtr support for LGUs who report qtr gross for new business.
    
    /** Creates a new instance of BusinessInfo */
    public BusinessInfo() {
    }
    
    public BusinessInfo(String datatype, Object value) {
        if(value == null) return;
        datatype = datatype.toLowerCase();
        if( datatype.equals("decimal") ) {
            setDecimalvalue( Double.parseDouble(value+"") );
        }
        else if(datatype.equals("integer")) {
            setIntvalue( Integer.parseInt(value+"") );
        }
        else if( datatype.equals("boolean")) {
            String v = value.toString().toLowerCase().trim();
            if(v.equals("1") || v.equals("true")) {
                v = "true";
            }
            else {
                v = "false";
            }
            setBooleanvalue( Boolean.parseBoolean(v));
        }
        else if(datatype.startsWith("string")) {
            setStringvalue( (String)value );
        } 
        
    }
    
    
    
}

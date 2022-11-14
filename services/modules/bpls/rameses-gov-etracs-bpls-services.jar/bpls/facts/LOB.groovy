package bpls.facts;

public class LOB {
    
    BPApplication application;
    String objid; 			
    String lobid;			
    String name;
    String classification;
    String attributes;
    String assessmenttype;

    String psicid;
    String psicdesc;
    
    public LOB() {
    }


    public void printInfo() {
        println "*** LOB Fact ***"
        println "  objid     = " + this.objid;
        println "  lobid     = " + this.lobid;
        println "  psic id   = " + this.psicid;  
        println "  psic desc = " + this.psicdesc;  
        println "  assessment type = " + this.assessmenttype;  
    }

}

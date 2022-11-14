package rptis.facts;

public class RPU {
    String      objid                
    String      rputype              
    Integer     ry                   
    String      classificationid     
    String      exemptiontypeid      
    Boolean     taxable              
    Double      totalareaha          
    Double      totalareasqm         
    Double      totalbmv             
    Double      totalmv              
    Double      totalav              
    Double      swornamount          
    Boolean     useswornamount    
    String      txntype
    Integer     effectivityyear 

    Classification classification

    //data reference
    def entity 

    public RPU() {
    }

    public RPU( rpu ) {
        this.entity             = rpu
        this.objid              = rpu.objid
        this.rputype            = rpu.rputype
        this.ry                 = rpu.ry
        this.classificationid   = rpu.classification.objid
        this.exemptiontypeid    = rpu.exemptiontype?.objid
        this.taxable            = rpu.taxable
        this.totalareaha        = rpu.totalareaha
        this.totalareasqm       = rpu.totalareasqm
        this.totalbmv           = rpu.totalbmv
        this.totalmv            = rpu.totalmv
        this.totalav            = rpu.totalav
        this.swornamount        = rpu.swornamount
        this.useswornamount     = rpu.useswornamount
        this.classification     = new Classification(rpu.classification?.objid);
        this.txntype            = rpu.txntype?.objid 
        this.effectivityyear    = rpu.effectivityyear
    }

    void setTotalareaha( totalareaha ){
        this.totalareaha = totalareaha
        entity.totalareaha = totalareaha
    }

    void setTotalareasqm( totalareasqm ){
        this.totalareasqm = totalareasqm
        entity.totalareasqm = totalareasqm
    }

    void setTotalbmv( totalbmv ){
        this.totalbmv = totalbmv
        entity.totalbmv = totalbmv
    }

    void setTotalmv( totalmv ){
        this.totalmv = totalmv
        entity.totalmv = totalmv
    }

    void setTotalav( totalav ){
        this.totalav = totalav
        entity.totalav = totalav
    }
}

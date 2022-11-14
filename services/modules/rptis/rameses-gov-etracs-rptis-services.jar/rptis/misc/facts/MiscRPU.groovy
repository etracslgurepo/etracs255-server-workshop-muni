package rptis.misc.facts;

import rptis.facts.*;
import java.math.*;

public class MiscRPU
{
    String objid 
    String classificationid
    String actualuseid 
    Double basemarketvalue
    Double marketvalue
    Double assesslevel
    Double assessedvalue
    Boolean useswornamount 
    Double swornamount

    //data reference
    def entity    

    public MiscRPU(){}

    public MiscRPU(miscrpu){
        this.entity  = miscrpu
        this.objid = miscrpu.objid 
        this.classificationid = miscrpu.classification.objid 
        this.actualuseid = miscrpu.actualuse.objid 
        this.useswornamount = miscrpu.useswornamount
        this.swornamount = miscrpu.swornamount
        setBasemarketvalue(0.0)
        setMarketvalue(0.0)
        setAssesslevel(0.0)
        setAssessedvalue(0.0)      
    }

    void setBasemarketvalue(basemarketvalue){
        this.basemarketvalue = basemarketvalue
        entity.totalbmv = new BigDecimal(basemarketvalue+'')
    }

    void setMarketvalue(marketvalue){
        this.marketvalue = marketvalue
        entity.totalmv = new BigDecimal(marketvalue+'')
    }

    void setAssesslevel(assesslevel){
        this.assesslevel = assesslevel
        entity.assesslevel = new BigDecimal(assesslevel+'')
    }

    void setAssessedvalue(assessedvalue){
        this.assessedvalue = assessedvalue
        entity.totalav = new BigDecimal(assessedvalue+'')
    }

}


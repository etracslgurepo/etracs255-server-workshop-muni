package rptis.mach.facts;

import rptis.facts.*;
import java.math.*;

public class MachineDetail{
    MachineActualUse machuse 

    Double basemarketvalue
    Double depreciationvalue
    Double marketvalue
    Double assesslevel
    Double assessedvalue
    Double swornamount
    Boolean useswornamount 
    Boolean taxable
    Double depreciation 

    //data reference
    def entity    

    public MachineDetail(){}

    public MachineDetail(machusefact, md){
        this.machuse = machusefact
        this.entity  = md 
        this.swornamount = md.swornamount
        this.useswornamount = md.useswornamount
        this.taxable = md.taxable
        this.depreciation = md.depreciation
        setBasemarketvalue(md.basemarketvalue)
        setDepreciationvalue(md.depreciationvalue)
        setMarketvalue(md.marketvalue)
        setAssesslevel(md.assesslevel)
        setAssessedvalue(md.assessedvalue)
    }

    void setBasemarketvalue( basemarketvalue ){
        this.basemarketvalue = basemarketvalue
        entity.basemarketvalue = new BigDecimal(basemarketvalue+'')
    }

     void setDepreciationvalue( depreciationvalue ){
        this.depreciationvalue = depreciationvalue
        entity.depreciationvalue = new BigDecimal(depreciationvalue+'')
    }

    void setMarketvalue( marketvalue ){
        this.marketvalue = marketvalue
        entity.marketvalue = new BigDecimal(marketvalue+'')
    }

    void setAssesslevel( assesslevel ){
        this.assesslevel = assesslevel
        entity.assesslevel = new BigDecimal(assesslevel+'')
    }

    void setAssessedvalue( assessedvalue ){
        this.assessedvalue = assessedvalue
        entity.assessedvalue = new BigDecimal(assessedvalue+'')
    }

}


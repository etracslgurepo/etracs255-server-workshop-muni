package rptis.bldg.facts;

import java.math.*;

public class BldgUse
{
    String          objid 
    BldgStructure   bldgstructure
    String          actualuseid 
    Boolean         fixrate
    Double          basevalue
    Double          area
    Double          basemarketvalue
    Double          depreciationvalue
    Double          adjustment
    Double          adjfordepreciation
    Double          marketvalue
    Double          assesslevel
    Double          assessedvalue
    Double          swornamount
    Boolean         useswornamount 
    Boolean         taxable  
    

    //data ref
    def entity

    public BldgUse(){}

    public BldgUse(bldgstructure, bu){
        this.entity             = bu
        this.bldgstructure      = bldgstructure
        this.objid              = bu.objid 
        this.actualuseid        = bu.actualuse?.objid 
        this.swornamount        = bu.swornamount
        this.useswornamount     = bu.useswornamount
        this.taxable            = bu.taxable

        this.fixrate = false;
        if ( bu.actualuse && (bu.actualuse?.fixrate == 1 || bu.actualuse?.fixrate == true))
            this.fixrate = true 

        setAssesslevel(0.0)
        if (this.fixrate && bu.actualuse?.rate > 0.0)
            setAssesslevel(bu.actualuse?.rate)

        setBasevalue(bu.basevalue)

        setArea(0.0)
        setBasemarketvalue(0.0)
        setDepreciationvalue(0.0)
        setAdjustment(0.0)
        setAdjfordepreciation(0.0)
        setMarketvalue(0.0)
        setAssessedvalue(0.0)
        
    }

    void setBasevalue(basevalue){
        this.basevalue = basevalue
        entity.basevalue = new BigDecimal(basevalue+'')
    }

    void setArea(area){
        this.area = area
        entity.area = new BigDecimal(area+'')
    }

    void setBasemarketvalue(basemarketvalue){
        this.basemarketvalue = basemarketvalue
        entity.basemarketvalue = new BigDecimal(basemarketvalue+'')
    }

    void setDepreciationvalue(depreciationvalue){
        this.depreciationvalue = depreciationvalue
        entity.depreciationvalue = new BigDecimal(depreciationvalue+'')
    }

    void setAdjustment(adjustment){
        this.adjustment = adjustment
        entity.adjustment = new BigDecimal(adjustment+'')
    }

    void setAdjfordepreciation(adjfordepreciation){
        this.adjfordepreciation = adjfordepreciation
        entity.adjfordepreciation = new BigDecimal(adjfordepreciation+'')
    }

    void setMarketvalue(marketvalue){
        this.marketvalue = marketvalue
        entity.marketvalue = new BigDecimal(marketvalue+'')
    }

    void setAssesslevel(assesslevel){
        this.assesslevel = assesslevel
        entity.assesslevel = new BigDecimal(assesslevel+'')
    }

    void setAssessedvalue(assessedvalue){
        this.assessedvalue = assessedvalue
        entity.assessedvalue = new BigDecimal(assessedvalue+'')
    }

}
package rptis.planttree.facts;

import rptis.facts.*;
import java.math.*;

public class PlantTreeDetail 
{
    rptis.facts.RPU rpu;
    String actualuseid
    String classificationid
    Double productive
    Double nonproductive
    Double areacovered
    Double unitvalue
    Double basemarketvalue
    Double adjustment
    Double adjustmentrate
    Double marketvalue
    Double assesslevel
    Double assessedvalue 
    Boolean taxable 

    //data reference
    def entity    

    public PlantTreeDetail(){}

    public PlantTreeDetail(rpufact, ptd){
        this.rpu = rpufact 
        this.entity = ptd;
        ptd.assesslevel = ptd.actualuse?.rate 
        this.actualuseid = ptd.actualuse?.objid
        this.classificationid = ptd.actualuse?.classification?.objid
        this.productive = ptd.productive
        this.nonproductive = ptd.nonproductive
        this.areacovered = ptd.areacovered
        this.unitvalue = ptd.unitvalue
        this.basemarketvalue = ptd.basemarketvalue
        this.adjustment = ptd.adjustment
        this.adjustmentrate = ptd.adjustmentrate
        this.taxable = true 
        setMarketvalue(ptd.marketvalue)
        setAssesslevel(ptd.assesslevel)
        setAssessedvalue(ptd.assessedvalue)
    }

    public void setBasemarketvalue(basemarketvalue){
        this.basemarketvalue = basemarketvalue
        entity.basemarketvalue = basemarketvalue
    }
    public void setAdjustment(adjustment){
        this.adjustment = adjustment
        entity.adjustment = adjustment
    }
    public void setAdjustmentrate(adjustmentrate){
        this.adjustmentrate = adjustmentrate
        entity.adjustmentrate = adjustmentrate
    }
    public void setMarketvalue(marketvalue){
        this.marketvalue = marketvalue
        entity.marketvalue = marketvalue
    }
    public void setAssesslevel(assesslevel){
        this.assesslevel = assesslevel
        entity.assesslevel = assesslevel
    }
    public void setAssessedvalue(assessedvalue){
        this.assessedvalue = assessedvalue
        entity.assessedvalue = assessedvalue
    }
}

package rptis.misc.facts;

import rptis.facts.*;
import java.math.*;

public class MiscItem{
    Double basemarketvalue
    Double depreciation
    Double depreciatedvalue
    Double marketvalue
    Double assesslevel
    Double assessedvalue
    Boolean taxable

    //data reference
    def miscrpu 
    def entity    

    public MiscItem(){}

    public MiscItem(miscrpu, miscitem){
        this.miscrpu = miscrpu
        this.entity  = miscitem 
        this.depreciation = miscitem.depreciation 
        this.taxable = miscitem.taxable
        
        setBasemarketvalue(miscitem.basemarketvalue)
        setDepreciatedvalue(miscitem.depreciatedvalue)
        setMarketvalue(miscitem.marketvalue)
        setAssesslevel(miscitem.assesslevel)
        setAssessedvalue(miscitem.assessedvalue)
    }

    void setBasemarketvalue( basemarketvalue ){
        this.basemarketvalue = basemarketvalue
        entity.basemarketvalue = new BigDecimal(basemarketvalue+'')
    }

     void setDepreciatedvalue( depreciatedvalue ){
        this.depreciatedvalue = depreciatedvalue
        entity.depreciatedvalue = new BigDecimal(depreciatedvalue+'')
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


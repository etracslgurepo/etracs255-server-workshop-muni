package rptis.land.facts;

import rptis.facts.*;
import rptis.planttree.facts.*;
import java.math.*;

public class LandDetail {
    rptis.facts.RPU rpu
    Classification classification      
    Classification specificclassification      
    String classificationid             
    String  objid                
    Double  striprate       
    String  areatype
    Double  area     
    Double  areasqm              
    Double  areaha               
    Double  basevalue            
    Double  unitvalue            
    Boolean taxable              
    Double  basemarketvalue      
    Double  adjustment           
    Double  landvalueadjustment  
    Double  actualuseadjustment  
    Double  marketvalue          
    Double  assesslevel          
    Double  assessedvalue    

    //data reference
    def entity    

    public LandDetail(){}

    public LandDetail(rpufact, ld){
        this.rpu = rpufact
        this.classification = new Classification(ld.specificclass?.classification?.objid)
        this.specificclassification = new Classification(ld.specificclass?.classification?.objid)
        this.classificationid = ld.specificclass?.classification?.objid
        this.entity = ld
        this.entity.areatype = ld.specificclass.areatype 

        this.objid              = ld.rpu
        this.striprate          = ld.striprate
        this.areatype           = ld.areatype
        this.area               = ld.area
        this.areasqm            = ld.areasqm
        this.areaha             = ld.areaha
        this.basevalue          = ld.basevalue
        this.unitvalue          = ld.unitvalue
        this.taxable            = ld.taxable
        this.basemarketvalue    = ld.basemarketvalue
        this.adjustment         = ld.adjustment
        this.landvalueadjustment = ld.landvalueadjustment
        this.actualuseadjustment = ld.actualuseadjustment

        setMarketvalue(0.0)
        setAssesslevel(0.0)
        setAssessedvalue(0.0)

    }

    void setAreasqm( areasqm ){
        this.areasqm = areasqm
        entity.areasqm = new BigDecimal(areasqm+'')
    }

    void setAreaha( areaha ){
        this.areaha = areaha
        entity.areaha = new BigDecimal(areaha+'')
    }

    void setBasevalue( basevalue ){
        this.basevalue = basevalue
        entity.basevalue = basevalue
    }

    void setUnitvalue( unitvalue ){
        this.unitvalue = unitvalue
        entity.unitvalue = new BigDecimal(unitvalue+'')
    }

    void setTaxable( taxable ){
        this.taxable = taxable
        entity.taxable = taxable
    }

    void setBasemarketvalue( basemarketvalue ){
        this.basemarketvalue = basemarketvalue
        entity.basemarketvalue = new BigDecimal(basemarketvalue+'')
    }

    void setAdjustment( adjustment ){
        this.adjustment = adjustment
        entity.adjustment = new BigDecimal(adjustment+'')
    }

    void setLandvalueadjustment( landvalueadjustment ){
        this.landvalueadjustment = landvalueadjustment
        entity.landvalueadjustment = new BigDecimal(landvalueadjustment+'')
    }

    void setActualuseadjustment( actualuseadjustment ){
        this.actualuseadjustment = actualuseadjustment
        entity.actualuseadjustment = new BigDecimal(actualuseadjustment+'')
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

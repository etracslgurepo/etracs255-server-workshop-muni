package rptis.facts;
import java.math.*;

public class RPUAssessment
{
    String objid
    String rpuid
    String rputype
    String classificationid
    String actualusecode
    String actualuseid
    Double areasqm
    Double areaha
    Double marketvalue
    Double exemptedmarketvalue
    Double assesslevel
    Double assessedvalue
    Boolean taxable

    // data ref 
    def entity 

    public RPUAssessment(){}

    public RPUAssessment(entity){
        this.entity = entity
        this.objid = entity.objid 
        this.rpuid = entity.rpuid 
        this.rputype = entity.rputype
        this.classificationid = entity.classificationid
        this.actualuseid = entity.actualuseid
        this.actualusecode = entity.actualusecode
        this.taxable = (entity.taxable == null ? true : entity.taxable)

        
        setAreasqm(entity.areasqm)
        setAreaha(entity.areaha)
        setMarketvalue(entity.marketvalue)
        if (entity.exemptedmarketvalue == null ) entity.exemptedmarketvalue = 0.0
        if (entity.assesslevel == null) entity.assesslevel = 0.0 
        setExemptedmarketvalue(entity.exemptedmarketvalue)
        setAssesslevel(entity.assesslevel)
        setAssessedvalue(entity.assessedvalue)
    }


    void setAreasqm(areasqm){
        this.areasqm = areasqm
        entity.areasqm = new BigDecimal(areasqm+'')
    }

    void setAreaha(areaha){
        this.areaha = areaha
        entity.areaha = new BigDecimal(areaha+'')
    }

    void setMarketvalue( marketvalue ){
        this.marketvalue = marketvalue
        entity.marketvalue = new BigDecimal(marketvalue+'')
    }

    void setExemptedmarketvalue( exemptedmarketvalue ){
        this.exemptedmarketvalue = exemptedmarketvalue
        entity.exemptedmarketvalue = new BigDecimal(exemptedmarketvalue+'')
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

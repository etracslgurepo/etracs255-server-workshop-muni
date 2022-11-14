package rptis.bldg.facts;
import java.math.*;

public class BldgRPU 
{
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

    Double      basevalue
    Integer     yrappraised
    Integer     yrcompleted
    Integer     yroccupied
    Integer     bldgage
    Integer     effectiveage
    Integer     floorcount
    Double      depreciation
    Double      depreciationvalue
    Double      totaladjustment
    Double      percentcompleted
    Double      assesslevel
    Boolean     condominium
    String      bldgclass
    Boolean     predominant
    Boolean     fixrate
    String      cdurating 

    //data reference
    def entity 

    public BldgRPU() {
    }

    public BldgRPU( rpu ) {
        this.entity             = rpu
        this.ry                 = rpu.ry
        this.classificationid   = rpu.classification?.objid
        this.exemptiontypeid    = rpu.exemptiontype?.objid
        this.taxable            = rpu.taxable
        this.swornamount        = rpu.swornamount
        this.useswornamount     = rpu.useswornamount
        this.basevalue          = rpu.basevalue
        this.yrappraised        = rpu.yrappraised
        this.yrcompleted        = rpu.yrcompleted
        this.yroccupied         = rpu.yroccupied
        this.bldgage            = rpu.bldgage
        this.effectiveage       = rpu.effectiveage
        this.floorcount         = rpu.floorcount
        this.percentcompleted   = rpu.percentcompleted
        this.assesslevel        = rpu.assesslevel
        this.condominium        = rpu.condominium
        this.bldgclass          = rpu.bldgclass
        this.cdurating          = rpu.cdurating 

        setTotalareaha(0.0)
        setTotalareasqm(0.0)
        setTotalbmv(0.0)
        setTotalmv(0.0)
        setTotalav(0.0)
        setTotaladjustment(0.0)
        setPredominant(false)
        setDepreciation(rpu.depreciation)
        setDepreciationvalue(0.0)

        this.fixrate = false;
        if ( rpu.bldgassesslevel && (rpu.bldgassesslevel.fixrate == 1 || rpu.bldgassesslevel.fixrate == true))
            this.fixrate = true 

        setAssesslevel(0.0)
        if (this.fixrate && rpu.bldgassesslevel?.rate > 0.0)
            setAssesslevel(rpu.bldgassesslevel.rate)
    }

    void setTotalareaha( totalareaha ){
        this.totalareaha = totalareaha
        entity.totalareaha = new BigDecimal(totalareaha+'')
    }

    void setTotalareasqm( totalareasqm ){
        this.totalareasqm = totalareasqm
        entity.totalareasqm = totalareasqm
    }

    void setTotalbmv( totalbmv ){
        this.totalbmv = totalbmv
        entity.totalbmv = new BigDecimal(totalbmv+'')
    }

    void setTotalmv( totalmv ){
        this.totalmv = totalmv
        entity.totalmv = new BigDecimal(totalmv+'')
    }

    void setTotalav( totalav ){
        this.totalav = totalav
        entity.totalav = new BigDecimal(totalav+'')
    }

    void setBasevalue( basevalue ){
        this.basevalue = basevalue
        entity.basevalue = new BigDecimal(basevalue+'')
    }

    void setBldgage( bldgage ){
        this.bldgage = bldgage
        entity.bldgage = bldgage
    }

    void setEffectiveage( effectiveage ){
        this.effectiveage = effectiveage
        entity.effectiveage = effectiveage
    }

    void setDepreciation( depreciation ){
        this.depreciation = depreciation
        entity.depreciation = new BigDecimal(depreciation+'')
    }

    void setDepreciationvalue( depreciationvalue ){
        this.depreciationvalue = depreciationvalue
        entity.depreciationvalue = new BigDecimal(depreciationvalue+'');
    }

    void setTotaladjustment( totaladjustment ){
        this.totaladjustment = totaladjustment
        entity.totaladjustment = new BigDecimal(totaladjustment+'')
    }

    void setAssesslevel( assesslevel ){
        this.assesslevel = assesslevel
        entity.assesslevel = new BigDecimal(assesslevel+'')
    }

    void setPredominant(predominant){
        this.predominant = predominant
        entity.predominant = (predominant ? 1 : 0)
    }

}

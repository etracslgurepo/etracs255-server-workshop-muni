package rptis.bldg.facts;
import java.math.*;

public class BldgFloor
{
    String objid 
    BldgUse bldguse
    Double area
    Double storeyrate
    Double basevalue
    Double unitvalue
    Double basemarketvalue
    Double adjustment
    Double marketvalue

    //data reference
    def entity

    public BldgFloor(){}

    public BldgFloor(bldguse, bf){
        this.bldguse        = bldguse
        this.entity         = bf
        this.objid          = bf.objid 
        this.area           = bf.area
        this.storeyrate     = bf.storeyrate
        this.basevalue      = bf.basevalue
        
        setUnitvalue(bf.basevalue)
        setBasemarketvalue( 0.0 )
        setAdjustment( 0.0 )
        setMarketvalue( 0.0 )
    }

    void setBasevalue( basevalue ){
        this.basevalue = basevalue
        entity.basevalue = new BigDecimal(basevalue+'')
    }

    void setUnitvalue( unitvalue ){
        this.unitvalue = unitvalue
        entity.unitvalue = new BigDecimal(unitvalue+'')
    }

    void setBasemarketvalue( basemarketvalue ){
        this.basemarketvalue = basemarketvalue
        entity.basemarketvalue = new BigDecimal(basemarketvalue+'')
    }

    void setAdjustment( adjustment ){
        this.adjustment = adjustment
        entity.adjustment = new BigDecimal(adjustment+'')
    }

    void setMarketvalue( marketvalue ){
        this.marketvalue = marketvalue
        entity.marketvalue = new BigDecimal(marketvalue+'')
    }


}
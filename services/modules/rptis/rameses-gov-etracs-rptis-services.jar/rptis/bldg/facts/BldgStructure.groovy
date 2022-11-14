package rptis.bldg.facts;
import java.math.*;


public class BldgStructure 
{
    BldgRPU   rpu
    Integer   floorcount
    Double    basefloorarea
    Double    totalfloorarea
    Double    basevalue
    Double    unitvalue

    //data reference
    def entity;

    public BldgStructure(){

    }

    public BldgStructure(bldgrpu, bs){
        this.rpu            = bldgrpu
        this.entity         = bs
        this.floorcount     = bs.floorcount
        this.basefloorarea  = bs.basefloorarea
        this.basevalue      = bs.basevalue
        this.unitvalue      = bs.basevalue
        
        setTotalfloorarea(0.0)
        entity.unitvalue    = bs.basevalue 
    }

    void setUnitvalue( unitvalue ){
        this.unitvalue = unitvalue
        entity.unitvalue = new BigDecimal(unitvalue+'')
    }

    void setTotalfloorarea( totalfloorarea ){
        this.totalfloorarea = totalfloorarea
        entity.totalfloorarea = new BigDecimal(totalfloorarea+'')
    }
}
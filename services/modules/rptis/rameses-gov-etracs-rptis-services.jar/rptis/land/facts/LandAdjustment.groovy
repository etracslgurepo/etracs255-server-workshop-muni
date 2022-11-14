package rptis.land.facts;

import rptis.facts.*;
import rptis.planttree.facts.*;
import java.math.*;

public class LandAdjustment {
    RPU rpu                  
    LandDetail landdetail
    
    String expr
    Double adjustment
    Double basemarketvalue
    Double marketvalue
    String type    
    List appliedtolist
    
    //data reference
    def entity    

    public LandAdjustment(){}

    public LandAdjustment(rpufact, ldfact, adj){
        this.rpu = rpufact
        this.landdetail = ldfact 
        this.entity = adj
        this.appliedtolist = adj.appliedtolist
        this.adjustment = 0.0
        this.basemarketvalue = 0.0
        this.marketvalue = 0.0
        adj.adjustment = 0.0
        adj.basemarketvalue = 0.0
        adj.marketvalue = 0.0
        this.expr = adj.expr
        this.type = adj.type    
    }

    void setAdjustment(adjustment){
        this.adjustment = adjustment
        entity.adjustment = new BigDecimal(adjustment+'')
    }

    void setBasemarketvalue(basemarketvalue){
        this.basemarketvalue = basemarketvalue
        entity.basemarketvalue = new BigDecimal(basemarketvalue+'')
    }

    void setMarketvalue(marketvalue){
        this.marketvalue = marketvalue
        entity.marketvalue = new BigDecimal(marketvalue+'')
    }

    public Map getParams(){
        Map p = [:]
        entity.params?.each {
            def v = (it.value ? it.value : it.decimalvalue)
            def value = parseInt(v)
            if (it.param.paramtype.matches('.*decimal.*')){
                value = parseDouble(v)
            }
            p[it.param.name] = value
        }
        return p 
    }

    def parseInt(val){
        try{
            return new java.math.BigDecimal(val+'').intValue();
        }
        catch(e){
            return 0;
        }
    }

    def parseDouble(val){
        try{
            return new BigDecimal(val+'')
        }
        catch(e){
            return 0.0;
        }
    }

}

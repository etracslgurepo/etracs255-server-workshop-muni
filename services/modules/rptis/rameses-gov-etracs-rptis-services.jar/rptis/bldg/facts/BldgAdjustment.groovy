package rptis.bldg.facts;
import java.math.*;

public class BldgAdjustment
{

    BldgFloor   bldgfloor
    BldgUse     bldguse 
    String      additionalitemid
    String      additionalitemcode
    String      adjtype         //values: addlitem, adjustment
    Double      amount
    String      expr
    Boolean     depreciate;


    //data reference
    def entity

    public BldgAdjustment(){}

    public BldgAdjustment(bldguse, bldgfloor, adj){
        this.entity         = adj
        this.bldguse        = bldguse 
        this.bldgfloor      = bldgfloor
        this.additionalitemid = adj.additionalitem?.objid
        this.additionalitemcode = adj.additionalitem?.code
        this.adjtype          = adj.additionalitem?.type
        this.depreciate = adj.depreciate
        setAmount(0.0)
        setExpr(adj.additionalitem?.expr)
    }

    void setAmount( amount ){
        this.amount = amount
        entity.amount = new BigDecimal(amount+'')
    }

    void setExpr( expr ){
        this.expr = expr
        entity.expr = expr
    }

    public Map getParams(){
        Map p = [:]
        entity.params?.each {
            def value = 0
            if (it.param.paramtype.matches('.*decimal.*')){
                value = parseDouble(it.value ? it.value : it.decimalvalue)
                it.decimalvalue = value 
                it.intvalue = null 
            }
            else {
                value = parseInt(it.value ? it.value : it.intvalue)
                it.decimalvalue = null 
                it.intvalue = value 
            }
             p[it.param.name] = value
            p.value = value 
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


    void resetValue(){
        entity.params.each{
            it.decimalvalue = 0.0
            it.intvalue = 0
        }
    }



}

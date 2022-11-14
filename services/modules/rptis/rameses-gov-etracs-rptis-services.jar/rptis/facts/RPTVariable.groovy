package rptis.facts;

public class RPTVariable
{
    String refid
    String  objid
    String varid
    Double  value
    String aggregatetype 

    public RPTVariable(){
    }

    public RPTVariable(refid, objid, varid, value, aggregatetype){
        this.refid = refid 
        this.objid = objid
        this.varid = varid
        this.value = value
        this.aggregatetype = aggregatetype
    }

    public void updateValue(newvalue){
        switch(aggregatetype){
            case 'sum' :
                value += newvalue
                break
            case 'count':
                value += 1
                break
            case 'max':
                if (value < newvalue)
                    value = newvalue 
                break
            case 'min':
                if (value > newvalue)
                    value = newvalue 
                break
            default:
                value = newvalue
                break
        }
    }

}

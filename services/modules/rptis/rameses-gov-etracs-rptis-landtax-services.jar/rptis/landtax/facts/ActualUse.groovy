package rptis.landtax.facts;

public class ActualUse 
{
    String objid
    String code 
    String name  

    public ActualUse(){}

    public ActualUse(actualuse){
        this.objid = actualuse?.objid
        this.code = actualuse?.code
        this.name = actualuse?.name
    }

    public def toMap(){
        return [
            objid: objid,
            code: code,
            name: name,
        ]
    }

    public boolean equals(other)  {
        if (!(other instanceof ActualUse)) {
            return false;
        }
        return this.objid.equals(other.objid);

    }

    public int hashCode() {
        return objid.hashCode();
    }
}

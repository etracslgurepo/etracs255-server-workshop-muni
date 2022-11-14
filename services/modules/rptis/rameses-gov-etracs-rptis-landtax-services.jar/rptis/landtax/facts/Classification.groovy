package rptis.landtax.facts;

public class Classification 
{
    String objid
    String code 
    String name  

    public Classification(){}

    public Classification(classification){
        this.objid = classification?.objid
        this.code = classification?.code
        this.name = classification?.name
    }

    public def toMap(){
        return [
            objid: objid,
            code: code,
            name: name,
        ]
    }

    public boolean equals(other)  {
        if (!(other instanceof Classification)) {
            return false;
        }
        return this.objid.equals(other.objid);

    }

    public int hashCode() {
        return objid.hashCode();
    }
}

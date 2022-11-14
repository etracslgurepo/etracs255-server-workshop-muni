package rptis.landtax.facts;

public class AssessedValue
{
    String objid
    Classification classification 
    ActualUse actualuse 
    String rputype
    String txntype 
    Integer year
    Integer fromqtr
    Integer toqtr
    Double av
    Double mv
    Double basicav
    Double sefav
    Boolean taxdifference 
    Boolean idleland  

    public AssessedValue(){}

    public AssessedValue(item, classification, actualuse){
        this.objid = item.objid
        this.classification = classification
        this.actualuse = actualuse
        this.rputype = item.rputype 
        this.txntype = item.txntype 
        this.year = item.year
        this.fromqtr = item.fromqtr
        this.toqtr = item.toqtr
        this.av = item.av
        this.mv = item.mv
        this.basicav = item.basicav
        this.sefav = item.sefav
        this.taxdifference = (item.taxdifference ? item.taxdifference : false)
        this.idleland = (item.idleland ? item.idleland : false)
    }
}

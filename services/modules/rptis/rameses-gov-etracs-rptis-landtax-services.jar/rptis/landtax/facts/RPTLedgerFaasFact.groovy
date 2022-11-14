package rptis.landtax.facts

import java.math.*


public class RPTLedgerFaasFact
{
    String objid 
    String tdno
    Classification classification 
    ActualUse actualuse 
    String classificationid
    String actualuseid
    Integer fromyear
    Integer fromqtr
    Integer toyear
    Integer toqtr
    Double assessedvalue
    Boolean idleland
    String txntype

    def entity

    public RPTLedgerFaasFact(){
        this.fromyear = 0;
        this.fromqtr = 0;
        this.toyear = 0;
        this.toqtr = 0;
        this.assessedvalue = 0.0;
    }

    public RPTLedgerFaasFact(ledgerfaas){
        this.tdno = ledgerfaas.tdno
        this.classificationid = ledgerfaas.classification?.objid
        this.actualuseid = ledgerfaas.actualuse?.objid
        this.fromyear = ledgerfaas.fromyear;
        this.fromqtr = ledgerfaas.fromqtr;
        this.toyear = ledgerfaas.toyear == 0 ?  9999 : ledgerfaas.toyear;
        this.toqtr = ledgerfaas.toqtr == 0 ? 4 : ledgerfaas.toqtr;
        this.assessedvalue = ledgerfaas.assessedvalue;
        this.classification = new Classification(ledgerfaas.classification);
        this.actualuse = new ActualUse(ledgerfaas.actualuse);
        this.idleland = (ledgerfaas.idleland ? ledgerfaas.idleland : false)
        this.txntype = ledgerfaas.txntype?.objid
    }
}

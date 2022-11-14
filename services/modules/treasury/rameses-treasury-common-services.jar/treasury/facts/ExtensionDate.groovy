package treasury.facts;

import java.text.SimpleDateFormat;
import java.util.Date;

/************************************************
* This fact is used for storing user-defined 
* extended dates like business and vehicle
* The year,month,qtr,tag fields are the markers 
* and the date is the date specified.
* Example in business, to override the first 
* qtr due date say Jan 20,2019 entry would be
* year:2019, qtr:1 date: Feb 10, 2019
************************************************/

public class ExtensionDate  {
    
    int year;
    int month;
    int qtr;
	String tag;

    Date date;

}

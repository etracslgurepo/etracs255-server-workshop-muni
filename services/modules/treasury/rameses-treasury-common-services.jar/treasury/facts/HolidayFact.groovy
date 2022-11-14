package treasury.facts;

import java.util.*;
import com.rameses.util.*;

public class HolidayFact implements HolidayProvider {

	String id;
	def handler;

	public boolean exists(Date date) {
		return handler( date );
	}
}
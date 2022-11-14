package treasury.utils;

import treasury.facts.*;
import enterprise.facts.*;
import enterprise.utils.*;
import java.util.*;

public interface RuleOutputHandler {
	
	public void out( def fact, Map result );

}
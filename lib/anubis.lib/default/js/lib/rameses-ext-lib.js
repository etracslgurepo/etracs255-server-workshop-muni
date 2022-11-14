/***
    version 1.5.25.22
    Rameses javascript extension library
**/

//******************************************************************************************************************
// String extensions
//******************************************************************************************************************
String.prototype.trim = function(){ return (this.replace(/^[\s\xA0]+/, "").replace(/[\s\xA0]+$/, ""))};
String.prototype.startsWith = function(str) {return (this.match("^"+str)==str)};
String.prototype.endsWith = function(str) {return (this.match(str+"$")==str)};

String.prototype.formatCode = function(space) {
	if( !space ) space = "_";
	return this.trim().toUpperCase().replace(/\s+/g, space);
};
String.prototype.generateKey = function() {
    var s = [];
    var hexDigits = "0123456789abcdef";
    for (var i = 0; i < 36; i++) {
        s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
    }
    s[14] = "4";  // bits 12-15 of the time_hi_and_version field to 0010
    s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);  // bits 6-7 of the clock_seq_hi_and_reserved to 01
    s[8] = s[13] = s[18] = s[23] = "-";
    return s.join("");
};

//******************************************************************************************************************
// Array extensions
//******************************************************************************************************************
if(!Array.indexOf){ //some lower versions of IE doesn't have indexOf
	Array.prototype.indexOf = function(obj){		
		for(var i=0; i<this.length; i++){
			if(this[i]==obj) return i;
		}
		return -1;
	}
}

Array.prototype.change = function(item1, item2) {
	var idx = this.indexOf(item1); 
	if (idx >= 0) {
		this[idx] = item2; 
		return true; 
	} else {
		return false; 
	} 
} 

Array.prototype.remove = function( from, to ) {
	if( typeof from == 'object' ) {
		var idx = this.indexOf( from );
		if( idx >= 0 ) return this.remove( idx );
		return this;
	} else {
		var rest = this.slice((to || from) + 1 || this.length);
		this.length = from < 0 ? this.length + from : from;
		return this.push.apply(this, rest);
	}
};
Array.prototype.removeAll = function( func ) {
	var _retained = [];
	var _removed = [];
	for( var i=0; i<this.length; i++ ) {
		var item = this[i];
		if( !func(item) == true ) {
			_retained.push( item );
		} else {
			_removed.push( item );
		}
	}
	this.length = 0;
	this.push.apply(this, _retained);
	return _removed;
};
Array.prototype.addAll = function( list ) {
	for( var i=0; i<list.length; i++ ) {
		this.push( list[i] );
	}
	return this;
};
Array.prototype.each = function( func ) {
	for( var i=0; i<this.length; i++ ) {
		func( this[i], i );
	}
	return this;
};
Array.prototype.find = function( func) {
	if( $.isFunction(func) ) {
		for( var i=0; i<this.length; i++ ) {
			var item = this[i];
			if( func(item) == true ) {
				return item;
			}
		}
		return null;
	} else {
		alert("Please pass a function when using find","Error");
	}
};
Array.prototype.contains = function( func) {
	if( $.isFunction(func) ) {
		for( var i=0; i<this.length; i++ ) {
			var item = this[i];
			if( func(item) == true ) {
				return true;
			}
		}
		return false;
	} else {
		alert("Please pass a function when using find","Error");
	}
};
Array.prototype.findAll = function( func ) {
	if( $.isFunction(func) ) {
		var _arr = [];
		for( var i=0; i<this.length; i++ ) {
			var item = this[i];
			if( func(item) == true ) {
				_arr.push(item);
			}
		}
		return _arr;
	} else {
		alert("Please pass a function when using findAll","Error");
	}
};
Array.prototype.collect = function( func ) {
	if( $.isFunction(func) ) {
		var _arr = [];
		for( var i=0; i<this.length; i++ ) {
			var item = this[i];
			var o = func(item);
			if(o!=null) _arr.push(o);
		} 
		return _arr;
	} else {
		alert("Please pass a function when using collect","Error");
	}
};
Array.prototype.clear = function() {
	return this.splice(0,this.length);
};
Array.prototype.unique = function(_key) {	
	if (_key) { 
		var _keys   = [];
		var _values = [];
		for (var i=0; i<this.length; i++) { 
			var o = this[i]; 
			var key = o[_key]; 
			var idx = _keys.indexOf(key); 
			if (idx < 0) { 
				_keys.push(key); 
				_values.push(o); 
			} 
		} 
		return _values; 
	} else {
		var _arrays = []; 
		for (var i=0; i<this.length; i++) { 
			var o = this[i]; 
			var idx = _arrays.indexOf(o); 
			if (idx < 0) _arrays.push(o); 
		} 
		return _arrays; 		
	}
}; 

/**
 * string expression support
 * @param ctx
 *          - the context of the expression (window is the default context)
 * usage: "hello ${name}".evaluate( [optional context] );
 *        - where name is a property of the context
 *
 * @author jaycverg
 */
String.prototype.evaluate = function( ctx ) {

    ctx = ctx? ctx : window;

    var str = this, 
	    match,
	    expr_token = /\\?#{([^{}]+)}/;
	
    while( (match = str.match(expr_token)) ) {
		if( match[0].length > 3 && match[0][0] == '\\' )
			str = str.replace( match[0], '@@' + match[0].substring(2) );
		else
			str = str.replace( match[0], _evaluate(match[1]) );
    }
	str = str.replace('@@{', '#{');
    return str+''; //return the parsed value

    //-- helper methods
    function _evaluate(str) {
		try {
			var result;
			with( ctx ) {
				result = eval( str );
			}
			if(result == null || result == undefined) result = '';
			return result+'';
		}
		catch(e) {
			if( String.DEBUG_EVAL && window.console ) 
				console.log( 'Error: ' + e.message + ', expr: ' + str );
			
			return '';
		}
    }
    
    function strEscape( str ) {
		return str.replace(/'/g, '\\\'')
		          .replace(/\n/g, '\\n')
		          .replace(/\t/, '\\t');
	}
};

//******************************************************************************************************************
// Number extensions
//******************************************************************************************************************
Number.prototype.formatDecimal = function() {
	var nStr = this.toFixed(2);
	x = nStr.split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + ',' + '$2');
	}
	return x1 + x2;
};
var KeyGen = new function() {
	this.generateKey = function(string_length) {
		if (!string_length) string_length=8;
		
		var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
		var randomstring = '';
		for (var i=0; i<string_length; i++) {
			var rnum = Math.floor(Math.random() * chars.length);
			randomstring += chars.substring(rnum,rnum+1);
		}
		return randomstring;
	}
	this.UID = function(){
	    var s = [];
	    var hexDigits = "0123456789abcdef";
	    for (var i = 0; i < 36; i++) {
	        s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
	    }
	    s[14] = "4";  // bits 12-15 of the time_hi_and_version field to 0010
	    s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);  // bits 6-7 of the clock_seq_hi_and_reserved to 01
	    s[8] = s[13] = s[18] = s[23] = "-";
	    return s.join("");		
	}
}
var NumberUtils = new function() {
    this.toNumber = function( val ) {
		if (!val) return null; 
        else if (val == "") return null;
		
		val = val.replace(',', '');
        return eval(val);
    }

    this.toInteger = function( val ) {
		if (!val) return null; 
        else if (val == "") return null;
	
		val = val.replace(',', '');
        return parseInt(val, 10); //use base 10 numeric notation
    }

    this.toDecimal = function( val ) {
		if (!val) return null; 
        else if (val == "") return null;
		
		val = val.replace(',', '');
		if ((parseFloat(val)+'') == 'NaN') return null; 
		
        if (val.indexOf(".") < 0) 
            return parseFloat(parseFloat(val).toFixed(2)+'');
        else 
            return parseFloat(val);
    }
	
	this.getFixedValue = function(val) {
		var numval = this.toDecimal(val); 
		if (!numval) return null; 
		
		var sval = numval+'';
		if (sval.indexOf('.') < 0) 
			return parseFloat(sval).toFixed(2); 
		else
			return sval; 
	} 
}

//*****************************************
//Date extensions
//*****************************************
var dateFormat = function () {
	var	token = /d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g,
		timezone = /\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g,
		timezoneClip = /[^-+\dA-Z]/g,
		pad = function (val, len) {
			val = String(val);
			len = len || 2;
			while (val.length < len) val = "0" + val;
			return val;
		};

	// Regexes and supporting functions are cached through closure
	return function (date, mask, utc) {
		var dF = dateFormat;

		// You can't provide utc if you skip other args (use the "UTC:" mask prefix)
		if (arguments.length == 1 && Object.prototype.toString.call(date) == "[object String]" && !/\d/.test(date)) {
			mask = date;
			date = undefined;
		}

		// Passing date through Date applies Date.parse, if necessary
		date = date ? new Date(date) : new Date;
		if (isNaN(date)) throw SyntaxError("invalid date");

		mask = String(dF.masks[mask] || mask || dF.masks["default"]);

		// Allow setting the utc argument via the mask
		if (mask.slice(0, 4) == "UTC:") {
			mask = mask.slice(4);
			utc = true;
		}

		var	_ = utc ? "getUTC" : "get",
			d = date[_ + "Date"](),
			D = date[_ + "Day"](),
			m = date[_ + "Month"](),
			y = date[_ + "FullYear"](),
			H = date[_ + "Hours"](),
			M = date[_ + "Minutes"](),
			s = date[_ + "Seconds"](),
			L = date[_ + "Milliseconds"](),
			o = utc ? 0 : date.getTimezoneOffset(),
			flags = {
				d:    d,
				dd:   pad(d),
				ddd:  dF.i18n.dayNames[D],
				dddd: dF.i18n.dayNames[D + 7],
				m:    m + 1,
				mm:   pad(m + 1),
				mmm:  dF.i18n.monthNames[m],
				mmmm: dF.i18n.monthNames[m + 12],
				yy:   String(y).slice(2),
				yyyy: y,
				h:    H % 12 || 12,
				hh:   pad(H % 12 || 12),
				H:    H,
				HH:   pad(H),
				M:    M,
				MM:   pad(M),
				s:    s,
				ss:   pad(s),
				l:    pad(L, 3),
				L:    pad(L > 99 ? Math.round(L / 10) : L),
				t:    H < 12 ? "a"  : "p",
				tt:   H < 12 ? "am" : "pm",
				T:    H < 12 ? "A"  : "P",
				TT:   H < 12 ? "AM" : "PM",
				Z:    utc ? "UTC" : (String(date).match(timezone) || [""]).pop().replace(timezoneClip, ""),
				o:    (o > 0 ? "-" : "+") + pad(Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60, 4),
				S:    ["th", "st", "nd", "rd"][d % 10 > 3 ? 0 : (d % 100 - d % 10 != 10) * d % 10]
			};

		return mask.replace(token, function ($0) {
			return $0 in flags ? flags[$0] : $0.slice(1, $0.length - 1);
		});
	};
}();

// Some common format strings
dateFormat.masks = {
	"default":      "ddd mmm dd yyyy HH:MM:ss",
	shortDate:      "m/d/yy",
	mediumDate:     "mmm d, yyyy",
	longDate:       "mmmm d, yyyy",
	fullDate:       "dddd, mmmm d, yyyy",
	shortTime:      "h:MM TT",
	mediumTime:     "h:MM:ss TT",
	longTime:       "h:MM:ss TT Z",
	isoDate:        "yyyy-mm-dd",
	isoTime:        "HH:MM:ss",
	isoDateTime:    "yyyy-mm-dd'T'HH:MM:ss",
	isoUtcDateTime: "UTC:yyyy-mm-dd'T'HH:MM:ss'Z'"
};

// Internationalization strings
dateFormat.i18n = {
	dayNames: [
		"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
		"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
	],
	monthNames: [
		"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
		"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
	]
};

// For convenience...
Date.prototype.format = function (mask, utc) {
	return dateFormat(this, mask, utc);
};


//template support
function $template( template, data, repeat ) {
	var tpl = (typeof template == 'string')? $('#' + template) : $(template);
	var varName = tpl.attr('r:varName');
	
	var result = [], ctx = {}, html;
	
	if( !repeat ) data = [data];
	
	data.each(function(obj){
		ctx[ varName || 'it' ] = obj;
		html = unescape(tpl.html()).evaluate( ctx );
		result.push(html);
	});
	
	return result.join('');
}


//CRUDFactory 
var CRUDFactory = new function() {

	this.create = function(o) {
		o.closeOnSave = false;
		o.mode = 'create';
		o.entity = {}; 
		o.saveHandler = function(){};
		
		o.getService = function() { 
			if (o.service) return o.service; 
			
			throw new Error("'service' property is not defined");  
		} 
		
		o.read = function() {
			o.entity = o.getService().read(o.entity); 
		} 
		
		o.onload = function() { 
			if (o.oninit) o.oninit(); 			 	
			else if (o.mode == 'read') o.read(); 
			
			if (o.onafterload) o.onafterload(); 
		} 
		
		o.saveImpl = function() {
			if (o.mode == 'create') {
				if (o.onbeforeSave) o.onbeforeSave(o.entity);
				
				o.entity = o.getService().saveCreate(o.entity); 
			} 
			else if (o.mode == 'edit') {
				if (o.onbeforeUpdate) o.onbeforeUpdate(o.entity); 
				
				o.entity = o.getService().saveUpdate(o.entity); 
			} 
			else {
				throw new Error("This document must be in 'create' or 'edit' mode. Please check."); 
			} 
			
			var pmode = o.mode; 
			o.mode = 'read'; 
			if (o.saveHandler) o.saveHandler(o.entity); 
			if (o.onafterSave) o.onafterSave(o.entity, pmode); 
		} 
		
		o.saveCreate = function() { o.saveImpl(); return '_close'; } 
		o.cancelCreate = function() { 
			var result = (o.oncancelCreate)? o.oncancelCreate(): null; 
			return (result)? result: '_close'; 
		}
		
		o.edit = function() { 
			o.mode='edit'; 
			if (o.onedit) o.onedit(o.entity); 
		} 
		
		o.saveUpdate = function() { 
			o.saveImpl(); 
			if (o.closeOnSave == true) return '_close';
		}
		
		o.cancelUpdate = function() { 
			if (confirm("Discard changes?")) 
			{ 
				o.mode='read'; 
				var result = (o.oncancelUpdate)? o.oncancelUpdate(): null; 
				if (result) return result; 
			} 
		} 
		
		o.onbeforeClose = function() {
			if (o.mode != 'read') return confirm("Discard changes?"); 
		}  
		return o; 
	} 

} 

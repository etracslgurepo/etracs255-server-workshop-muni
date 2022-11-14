function RemoteProxy(name, connection, module) {
	this.name = name;
    this.connection = connection;
	this.module = module;
	
	var convertResult = function( result ) {
        if (result==null) return null;

        if ( result.trim().substring(0,1) == "["  || result.trim().substring(0,1) == "{"  ) {
            return $.parseJSON(result);
        } else {
            return eval(result);
        }
	} 

	this.invoke = function( action, args, handler ) {
        var urlaction = '/js-invoke'+ (this.module? '/'+this.module:'');
        urlaction += '/'+ this.connection +'/'+ this.name +'.'+ action; 
        var err = null;	
		var data = []; 
		if( args ) { 
			if (args.length == 0 || !args[0]) {
				//do nothing
			} else if ($.toJSON) {
				data.push('args=' + encodeURIComponent($.toJSON( args ))); 
			} else { 
				var _args = [(args? args[0]: null)];
				data.push('args=' + encodeURIComponent(JSON.stringify( _args ))); 
			} 
		}
		data = data.join('&');
		
		if (handler == null) { 
			var result = $.ajax({
				type  : "POST", 				
				url   : urlaction, 
				data  : data, 
				async : false, 
				error : function( xhr ) { 
					err = xhr.responseText; 
				} 				
			}).responseText;

			if ( err!=null ) {
				throw new Error(err);
			}
			return convertResult( result );
		}
		else {
			$.ajax({ 
				type    : "POST",				
				url     : urlaction,
				data    : data,
				async   : true,				
				success : function( data) { 
					var r = convertResult(data);
					handler(r); 
				},
				error   : function( xhr ) { 
					handler( null, new Error(xhr.responseText) ); 
				} 				
			});
		}
	}
};

var Service = new function() {
	this.debug = false;
	this.services = {}
	this.module = null;

	this.lookup = function(name, connection, mod) {
        var module = this.module;
        if( mod ) module = mod;

		if (this.debug == true && window.console) 
			window.console.log('Service_lookup: name='+name + ', module='+module + ', connection=' + connection); 
	
		if ( this.services[name]==null ) {
			var err = null;
			if (this.debug == true && window.console) 
				window.console.log('Service_lookup: module='+module); 
			
			var urlaction =  '/js-proxy' + (module? '/'+module: '');
			urlaction += '/' + connection + '/' + name + ".js";
			
            if (this.debug == true && window.console) 
				window.console.log('Service_lookup: urlaction='+urlaction); 
			
			var result = $.ajax({
                            url:urlaction,
                            type:"GET",
                            error: function( xhr ) { err = xhr.responseText },
                            async : false 
			}).responseText;
			if ( err!=null ) throw new Error(err);

			if (this.debug == true && window.console) 
				window.console.log('Service_lookup: result='+result); 
			
			var func = eval( '(' + result + ')' );	
                            
			var svc = new func( new RemoteProxy(name, connection, module) );
			this.services[name] = svc;
		}
		return this.services[name];
	} 
};
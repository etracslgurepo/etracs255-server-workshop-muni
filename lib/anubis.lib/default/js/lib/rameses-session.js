var Socket = new function() {

	function Notifier( handlers, result ) {

		var _self = this;
		var _handlers = handlers;
		var _result = result;

		var notifyImpl = function( data ) { 
			for( var n in _handlers ) {
				try {
					_handlers[n]( data );
				} catch(e){;} 
			} 
		}

		this.run = function() {
			if ( _result instanceof Array ) {
				for ( var i=0; i<_result.length; i++ ) {
					notifyImpl( _result[i] ); 
				}
			} else {
				notifyImpl( _result ); 
			} 
		} 
	}

    function HttpSocket ( channel ) { 
        if (!channel) { 
            alert('channel must be provided!'); 
            throw new Error('channel must be provided!'); 
        } 

        var self = this;
        var _channel = channel;
        var _token =  Math.floor(Math.random()*1000000001) + '-' + Math.floor(Math.random()*1000000001);
        var _running = false;

        this.handlers = {};
        this.error;

        this.getToken = function() {
        	return _token; 
        } 

        var poll = function() { 
        	if (_running == false) return; 

			try {
				$.ajax({ 
					url: "/poll/"+_channel+"/"+_token, 
					dataType: 'text',
					cache: false, 
					complete: function(o,textStatus) {
						if (o.statusText == 'OK' ) {
							var result = null;
							if (o.responseText) { 
								try { 
									result = $.parseJSON(o.responseText); 
								} catch(e) {
									if (window.console) window.console.log("ERROR parsing caused by " + e + " responseText->" + o.responseText); 
								} 
							}  

							if ( result ) { 
								new Notifier( self.handlers, result ).run(); 
							} 

							setTimeout( poll, 1000 );
						} 
					} ,
					error: function(o,textStatus,msg) {
						if(textStatus=="timeout") {
							poll();
						} else {
							if( self.error ) {
								self.error( o );
							} else {
								if( window.console ) window.console.log( "Error in polling. " + o.error);
								//reconnect after 30 seconds
								setTimeout( poll, 30000 );
							}    
						}
					}
				});
			} 
			catch(e) { 
				if (window.console) window.console.log("[ERROR]_poll caused by " + e); 
			} 
        } 
        
        this.start = function(){
        	if (_running == true) {
        		//do nothing 
        	} else {
	        	_running = true; 
	            poll();
        	}
        } 

        this.stop = function() {
        	_running = false; 
        }
    } 

    this.create = function( channel ) {
        var socket = new HttpSocket( channel );
        return socket;
    } 


} 

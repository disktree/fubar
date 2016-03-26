
var pending = [];

function preloadImage(url) {
	var xhr = new XMLHttpRequest();
    xhr.responseType = 'blob';
    xhr.onload = function(e){
        //console.log("PRELOAD COMPLETE "+url );
		pending[url] = null;
        self.postMessage({status:0,url:url,result:xhr.response});
        //self.close();
    };
    xhr.onprogress = function(e){
        //self.postMessage({status:1,loaded:e.loaded,total:e.total});
    };
    xhr.onerror = function(e){
		pending[url] = null;
        self.postMessage({status:1,info:e.toString()});
        //self.close();
    };
    xhr.open('GET',url,true);
    xhr.send();
	return xhr;
}

function abortPending() {
	for( var i=0; i <= pending.length; i++ ) {
		pending[i].abort();
	}
	pending = [];
}

self.onmessage = function(e) {
	switch( e.data.type ) {
	case 0:
		var url = e.data.url;
		pending[url] = preloadImage( url );
		break;
	case 1:
		abortPending();
		break;
	case 1:
		abortPending();
		self.close();
		break;
	}
};

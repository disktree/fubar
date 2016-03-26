(function (console, $global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = ["EReg"];
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,split: function(s) {
		var d = "#__delim__#";
		return s.replace(this.r,d).split(d);
	}
	,__class__: EReg
};
var HxOverrides = function() { };
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
Math.__name__ = ["Math"];
var Std = function() { };
Std.__name__ = ["Std"];
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std["int"] = function(x) {
	return x | 0;
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var StringTools = function() { };
StringTools.__name__ = ["StringTools"];
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
};
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && HxOverrides.substr(s,slen - elen,elen) == end;
};
var Type = function() { };
Type.__name__ = ["Type"];
Type.getClassName = function(c) {
	var a = c.__name__;
	if(a == null) return null;
	return a.join(".");
};
var fubar_App = function() { };
fubar_App.__name__ = ["fubar","App"];
fubar_App.update = function(time) {
	fubar_App.animationFrameId = window.requestAnimationFrame(fubar_App.update);
	om_app_Activity.current.update(window.performance.now());
};
fubar_App.handleBeforeUnload = function(e) {
	fubar_App.cancelAnimationFrame();
	fubar_Storage.storage.setItem("fubar_" + "config",JSON.stringify(fubar_App.config));
};
fubar_App.cancelAnimationFrame = function() {
	if(fubar_App.animationFrameId != null) {
		window.cancelAnimationFrame(fubar_App.animationFrameId);
		fubar_App.animationFrameId = null;
	}
};
fubar_App.main = function() {
	fubar_App.isMobile = om_System.isMobile();
	window.onload = function() {
		window.document.body.innerHTML = "";
		var element;
		var _this = window.document;
		element = _this.createElement("div");
		element.id = "fubar";
		window.document.body.appendChild(element);
		fubar_Storage.get("config",function(config) {
			if(config == null || config.version < "3.2.0") {
				fubar_Storage.storage.clear();
				config = { version : "3.2.0", rating : null, limit : 300, autoplay : 7, maxGifSize : (fubar_App.isMobile?2:3) * 1024 * 1024};
				fubar_Storage.storage.setItem("fubar_" + "config",JSON.stringify(fubar_App.config));
			}
			fubar_App.element = element;
			fubar_App.config = config;
			fubar_App.service = new fubar_Service("dc6zaTOxFJmzC");
			new fubar_app_IntroActivity().boot(element);
			window.addEventListener("beforeunload",fubar_App.handleBeforeUnload,false);
			fubar_App.animationFrameId = window.requestAnimationFrame(fubar_App.update);
		});
	};
};
var fubar_Service = function(apiKey) {
	this.apiKey = apiKey;
};
fubar_Service.__name__ = ["fubar","Service"];
fubar_Service.prototype = {
	get: function(id,callback) {
		this.request("/" + id + "?",function(e,r) {
			if(e != null) callback(e,null); else callback(null,r.data);
		});
	}
	,search: function(q,limit,offset,rating,callback) {
		var path = "/search?q=" + q.join("+");
		if(limit != null) path += "&limit=" + limit;
		if(offset != null) path += "&offset=" + offset;
		if(rating != null) path += "&rating=" + rating;
		this.request(path,function(e,r) {
			if(e != null) callback(e,null); else callback(null,r.data);
		});
	}
	,trending: function(limit,rating,callback) {
		var path = "/trending?";
		if(limit != null) path += "&limit=" + limit;
		if(rating != null) path += "&rating=" + rating;
		this.request(path,function(e,r) {
			if(e != null) callback(e,null); else callback(null,r.data);
		});
	}
	,request: function(params,callback) {
		var req = new XMLHttpRequest();
		req.open("GET","" + "http://api.giphy.com/v1/gifs" + params + "&api_key=" + this.apiKey,true);
		req.onerror = function(e) {
			callback(e,null);
		};
		req.onload = function(e1) {
			callback(null,JSON.parse(req.responseText));
		};
		try {
			req.send();
		} catch( e2 ) {
			callback(e2,null);
			return;
		}
	}
	,__class__: fubar_Service
};
var js_Browser = function() { };
js_Browser.__name__ = ["js","Browser"];
js_Browser.getLocalStorage = function() {
	try {
		var s = window.localStorage;
		s.getItem("");
		return s;
	} catch( e ) {
		return null;
	}
};
var fubar_Storage = function() { };
fubar_Storage.__name__ = ["fubar","Storage"];
fubar_Storage.get = function(id,callback) {
	var item = fubar_Storage.storage.getItem("fubar_" + id);
	callback(item == null?null:JSON.parse(item));
};
var om_app_Activity = function(id) {
	if(id == null) {
		var cName = Type.getClassName(js_Boot.getClass(this));
		var i = cName.lastIndexOf(".");
		if(i != -1) cName = cName.substring(i + 1);
		if(StringTools.endsWith(cName,"Activity")) cName = cName.substring(0,cName.length - "Activity".length);
		id = cName.toLowerCase();
	} else {
	}
	this.id = id;
	this.element = om_html__$DivElement_DivElement_$Impl_$._new();
	this.element.classList.add("activity");
	this.element.id = id;
	this.state = om_app_ActivityState.init;
};
om_app_Activity.__name__ = ["om","app","Activity"];
om_app_Activity.prototype = {
	update: function(time) {
	}
	,replace: function(activity) {
		activity.container = this.container;
		activity.onCreate();
		activity.onStart();
		this.onPause();
		activity.onResume();
		this.onStop();
		this.onDestroy();
		om_app_Activity.stack.pop();
		om_app_Activity.stack.push(activity);
		window.history.replaceState(null,null,null);
	}
	,onCreate: function() {
		this.handleStateChange(om_app_ActivityState.create);
	}
	,onRestart: function() {
		this.handleStateChange(om_app_ActivityState.restart);
		this.onStart();
	}
	,onStart: function() {
		this.handleStateChange(om_app_ActivityState.start);
		window.addEventListener("popstate",$bind(this,this.handlePopState),false);
		this.container.appendChild(this.element);
	}
	,onResume: function() {
		om_app_Activity.current = this;
		this.handleStateChange(om_app_ActivityState.resume);
	}
	,onPause: function() {
		om_app_Activity.current = null;
		this.handleStateChange(om_app_ActivityState.pause);
	}
	,onStop: function() {
		this.handleStateChange(om_app_ActivityState.stop);
		window.removeEventListener("popstate",$bind(this,this.handlePopState));
		this.element.remove();
	}
	,onDestroy: function() {
		this.handleStateChange(om_app_ActivityState.destroy);
	}
	,handleStateChange: function(newState) {
		this.element.classList.remove(Std.string(this.state));
		this.state = newState;
		this.element.classList.add(Std.string(newState));
	}
	,handlePopState: function(e) {
		e.preventDefault();
		e.stopPropagation();
		if(om_app_Activity.stack.length < 2) null; else {
			var current = om_app_Activity.stack.pop();
			var prev = om_app_Activity.stack[om_app_Activity.stack.length - 1];
			prev.onRestart();
			this.onPause();
			prev.onResume();
			this.onStop();
			this.onDestroy();
			window.history.replaceState(null,null,null);
		}
	}
	,boot: function(container) {
		if(container != null) this.container = container; else this.container = window.document.body;
		om_app_Activity.stack.push(this);
		this.onCreate();
		this.onStart();
		this.onResume();
		return this;
	}
	,__class__: om_app_Activity
};
var fubar_app_IntroActivity = function(id) {
	om_app_Activity.call(this,id);
};
fubar_app_IntroActivity.__name__ = ["fubar","app","IntroActivity"];
fubar_app_IntroActivity.__super__ = om_app_Activity;
fubar_app_IntroActivity.prototype = $extend(om_app_Activity.prototype,{
	onCreate: function() {
		var _g = this;
		om_app_Activity.prototype.onCreate.call(this);
		var this1;
		var _this = window.document;
		this1 = _this.createElement("img");
		this1.src = "image/giphy-badge-640.gif";
		this.banner = this1;
		this.banner.addEventListener("animationend",function(e) {
			e.stopPropagation();
			_g.replace(new fubar_app_PlayActivity("trending"));
		},false);
	}
	,onStart: function() {
		om_app_Activity.prototype.onStart.call(this);
		this.element.appendChild(this.banner);
	}
	,onStop: function() {
		om_app_Activity.prototype.onStop.call(this);
		this.banner.remove();
	}
	,__class__: fubar_app_IntroActivity
});
var fubar_app_PlayActivity = function(mode) {
	om_app_Activity.call(this);
	this.mode = mode;
};
fubar_app_PlayActivity.__name__ = ["fubar","app","PlayActivity"];
fubar_app_PlayActivity.__super__ = om_app_Activity;
fubar_app_PlayActivity.prototype = $extend(om_app_Activity.prototype,{
	onCreate: function() {
		om_app_Activity.prototype.onCreate.call(this);
		this.player = new fubar_gui_Player();
		this.element.appendChild(this.player.element);
		this.controls = new fubar_gui_player_Controls(false);
		this.element.appendChild(this.controls.element);
		var _this = window.document;
		this.statusbar = _this.createElement("div");
		this.statusbar.classList.add("statusbar");
		this.element.appendChild(this.statusbar);
	}
	,onStart: function() {
		var _g = this;
		om_app_Activity.prototype.onStart.call(this);
		this.timeLastImageChange = 0;
		this.timeLastUpdate = window.performance.now();
		this.timeImageShown = 0;
		this.timePauseStart = 0;
		this.player.onView = function(item) {
			_g.timeLastImageChange = window.performance.now();
			_g.controls.share.set_item(item);
		};
		this.controls.mode.onChange = function(change) {
			switch(change[1]) {
			case 0:
				var m = change[2];
				switch(m) {
				case "trending":
					_g.loadTrendingItems();
					break;
				case "search":
					var term = _g.controls.mode.searchInput.value;
					if(term.length == 0) null; else _g.loadItems(term.split(""));
					break;
				}
				break;
			case 1:
				var term1 = change[2];
				var terms = new EReg("(\\s+)","").split(term1);
				_g.loadItems(terms);
				break;
			}
		};
		this.controls.play.onChange = function(play) {
			if(play) {
				if(_g.timePauseStart > 0) {
					_g.timeImageShown -= window.performance.now() - _g.timePauseStart;
					_g.timePauseStart = 0;
				}
				_g.statusbar.style.display = "block";
			} else {
				_g.timePauseStart = window.performance.now();
				_g.statusbar.style.display = "none";
			}
		};
		var _g1 = this.mode;
		switch(_g1) {
		case "trending":
			this.loadTrendingItems();
			break;
		case "search":
			break;
		default:
			this.loadItem(this.mode);
		}
		this.touchInput = new fubar_gui_TouchInput(this.player.container);
		this.touchInput.onGesture = $bind(this,this.handleTouchGesture);
		this.player.element.addEventListener("dblclick",$bind(this,this.handleDoubleClickPlayer),false);
		window.addEventListener("keydown",$bind(this,this.handleKeyDown),false);
		window.document.addEventListener("visibilitychange",$bind(this,this.handleVisibilityChange),false);
	}
	,onStop: function() {
		om_app_Activity.prototype.onStop.call(this);
		this.touchInput.dispose();
		this.player.element.removeEventListener("dblclick",$bind(this,this.handleDoubleClickPlayer));
		window.removeEventListener("keydown",$bind(this,this.handleKeyDown));
		window.document.removeEventListener("visibilitychange",$bind(this,this.handleVisibilityChange));
	}
	,update: function(time) {
		if(!window.document.hidden) {
			this.timeImageShown += time - this.timeLastUpdate;
			if(this.controls.play.autoplay) {
				if(this.timeImageShown / 1000 >= fubar_App.config.autoplay) {
					this.timeImageShown = 0;
					this.statusbar.style.width = "0px";
					this.player.next();
				} else {
					var percent = this.timeImageShown / fubar_App.config.autoplay / 10;
					this.statusbar.style.width = Std["int"](window.innerWidth * percent / 100) + "px";
				}
			}
		}
		this.timeLastUpdate = time;
	}
	,loadItem: function(id) {
		var _g = this;
		fubar_App.service.get(id,function(e,i) {
			_g.handleItemsLoad(e,[i]);
		});
	}
	,loadItems: function(q) {
		fubar_App.service.search(q,fubar_App.config.limit,0,fubar_App.config.rating,$bind(this,this.handleItemsLoad));
	}
	,loadTrendingItems: function() {
		fubar_App.service.trending(fubar_App.config.limit,fubar_App.config.rating,$bind(this,this.handleItemsLoad));
	}
	,handleItemsLoad: function(e,items) {
		if(e != null) {
		} else {
			var filteredItems = [];
			var _g = 0;
			while(_g < items.length) {
				var item = items[_g];
				++_g;
				if(Std.parseInt(item.images.original.size) < fubar_App.config.maxGifSize) filteredItems.push(item);
			}
			this.player.load(filteredItems);
		}
	}
	,handleTouchGesture: function(gesture) {
		switch(gesture[1]) {
		case 0:
			this.controls.toggle();
			break;
		case 3:
			var v = gesture[2];
			this.controls.show();
			break;
		case 4:
			var v1 = gesture[2];
			this.controls.hide();
			break;
		case 2:
			var v2 = gesture[2];
			this.player.next();
			break;
		case 1:
			var v3 = gesture[2];
			this.player.prev();
			break;
		}
	}
	,handleDoubleClickPlayer: function(e) {
		if(window.document.webkitFullscreenElement != null) window.document.webkitExitFullscreen(); else window.document.documentElement.webkitRequestFullscreen();
	}
	,handleKeyDown: function(e) {
		var _g = e.keyCode;
		switch(_g) {
		case 38:
			break;
		case 39:
			this.player.next();
			break;
		case 40:
			break;
		case 37:
			this.player.prev();
			break;
		default:
		}
	}
	,handleVisibilityChange: function(e) {
		if(window.document.hidden) {
			if(this.controls.play.autoplay) this.timeInvisibleStart = window.performance.now();
		} else if(this.timeInvisibleStart > 0) {
			this.timeImageShown -= window.performance.now() - this.timeInvisibleStart;
			this.timeInvisibleStart = 0;
		}
	}
	,__class__: fubar_app_PlayActivity
});
var fubar_gui_ScaleMode = { __ename__ : true, __constructs__ : ["fit","letterbox"] };
fubar_gui_ScaleMode.fit = ["fit",0];
fubar_gui_ScaleMode.fit.toString = $estr;
fubar_gui_ScaleMode.fit.__enum__ = fubar_gui_ScaleMode;
fubar_gui_ScaleMode.letterbox = ["letterbox",1];
fubar_gui_ScaleMode.letterbox.toString = $estr;
fubar_gui_ScaleMode.letterbox.__enum__ = fubar_gui_ScaleMode;
var fubar_gui_Player = function(scaleMode,backgroundColor) {
	if(backgroundColor == null) backgroundColor = "#000";
	if(scaleMode == null) scaleMode = fubar_gui_ScaleMode.fit;
	var _this = window.document;
	this.element = _this.createElement("div");
	this.element.classList.add("player");
	switch(scaleMode[1]) {
	case 0:
		break;
	case 1:
		break;
	}
	this.scaleMode = scaleMode;
	this.backgroundColor = this.element.style.backgroundColor = backgroundColor;
	this.index = 0;
	var _this1 = window.document;
	this.container = _this1.createElement("div");
	this.container.classList.add("media");
	this.element.appendChild(this.container);
	this.preloader = new fubar_net_ImagePreloader();
};
fubar_gui_Player.__name__ = ["fubar","gui","Player"];
fubar_gui_Player.prototype = {
	onView: function(item) {
	}
	,load: function(items,index,pagination) {
		if(index == null) index = 0;
		if(this.items != null) this.clear();
		this.items = items;
		this.pagination = pagination;
		this["goto"](index);
	}
	,'goto': function(i) {
		var _g = this;
		if(i > this.items.length || i < 0) return;
		var item = this.items[i];
		if(item == null) return;
		var isNext = this.index + 1 == i;
		var isPrev = this.index - 1 == i;
		this.index = i;
		if(this.nextView != null) this.nextView.remove(true);
		this.nextView = new fubar_gui_player_ItemView(item);
		this.nextView.onLoadProgress = function(bytes,total) {
		};
		this.nextView.onLoad = function() {
			_g.nextView = null;
			_g.onView(item);
			if(isNext && _g.index < _g.items.length - 1) _g.preload(_g.items[_g.index + 1]);
			if(isPrev && _g.index > 0) _g.preload(_g.items[_g.index - 1]);
		};
		this.container.appendChild(this.nextView.element);
		if(this.currentView != null) this.currentView.remove();
		this.currentView = this.nextView;
	}
	,prev: function() {
		if(this.index > 0) this["goto"](this.index - 1); else {
		}
	}
	,next: function() {
		if(this.index < this.items.length - 1) this["goto"](this.index + 1); else {
		}
	}
	,clear: function() {
		while(this.container.firstChild != null) this.container.removeChild(this.container.firstChild);
		this.items = [];
		this.index = 0;
		this.preloader.dispose();
	}
	,preload: function(item,callback) {
		var url = item.images.original.url;
		this.preloader.preload(url,callback);
	}
	,__class__: fubar_gui_Player
};
var fubar_gui_TouchGesture = { __ename__ : true, __constructs__ : ["tap","right","left","up","down"] };
fubar_gui_TouchGesture.tap = ["tap",0];
fubar_gui_TouchGesture.tap.toString = $estr;
fubar_gui_TouchGesture.tap.__enum__ = fubar_gui_TouchGesture;
fubar_gui_TouchGesture.right = function(v) { var $x = ["right",1,v]; $x.__enum__ = fubar_gui_TouchGesture; $x.toString = $estr; return $x; };
fubar_gui_TouchGesture.left = function(v) { var $x = ["left",2,v]; $x.__enum__ = fubar_gui_TouchGesture; $x.toString = $estr; return $x; };
fubar_gui_TouchGesture.up = function(v) { var $x = ["up",3,v]; $x.__enum__ = fubar_gui_TouchGesture; $x.toString = $estr; return $x; };
fubar_gui_TouchGesture.down = function(v) { var $x = ["down",4,v]; $x.__enum__ = fubar_gui_TouchGesture; $x.toString = $estr; return $x; };
var fubar_gui_TouchInput = function(element,threshold) {
	if(threshold == null) threshold = 50;
	this.threshold = threshold;
	this.start = { x : -1, y : -1};
	this.move = { x : -1, y : -1};
	element.addEventListener("touchstart",$bind(this,this.handleTouchStart),false);
	element.addEventListener("touchmove",$bind(this,this.handleTouchMove),false);
	element.addEventListener("touchend",$bind(this,this.handleTouchEnd),false);
	this.enabled = true;
};
fubar_gui_TouchInput.__name__ = ["fubar","gui","TouchInput"];
fubar_gui_TouchInput.prototype = {
	onStart: function(e) {
	}
	,onMove: function(e) {
	}
	,onEnd: function(e) {
	}
	,onGesture: function(gesture) {
	}
	,dispose: function() {
		this.enabled = false;
		this.element.removeEventListener("touchstart",$bind(this,this.handleTouchStart));
		this.element.removeEventListener("touchmove",$bind(this,this.handleTouchMove));
		this.element.removeEventListener("touchend",$bind(this,this.handleTouchEnd));
	}
	,handleTouchStart: function(e) {
		if(!this.enabled) return;
		e.preventDefault();
		e.stopPropagation();
		if(e.touches != null) {
			var touch = e.touches[0];
			this.start.x = touch.pageX;
			this.start.y = touch.pageY;
			this.onStart(e);
		}
	}
	,handleTouchMove: function(e) {
		if(!this.enabled) return;
		e.preventDefault();
		e.stopPropagation();
		if(e.touches != null) {
			var touch = e.touches[0];
			this.move.x = touch.pageX;
			this.move.y = touch.pageY;
			this.onMove(e);
		}
	}
	,handleTouchEnd: function(e) {
		if(!this.enabled) return;
		e.preventDefault();
		e.stopPropagation();
		this.onEnd(e);
		if(this.start.x > -1 && this.move.x > -1) {
			var xDiff;
			if(this.start.x > this.move.x) xDiff = this.start.x - this.move.x; else xDiff = this.move.x - this.start.x;
			var yDiff;
			if(this.start.y > this.move.y) yDiff = this.start.y - this.move.y; else yDiff = this.move.y - this.start.y;
			if(xDiff > this.threshold) this.onGesture(this.start.x < this.move.x?fubar_gui_TouchGesture.right(xDiff):fubar_gui_TouchGesture.left(xDiff)); else if(yDiff > this.threshold) this.onGesture(this.start.y < this.move.y?fubar_gui_TouchGesture.down(yDiff):fubar_gui_TouchGesture.up(yDiff));
		} else this.onGesture(fubar_gui_TouchGesture.tap);
		this.start.x = this.start.y = this.move.x = this.move.y = -1;
	}
	,__class__: fubar_gui_TouchInput
};
var fubar_gui_player_ControlMenu = function(id) {
	this.hidden = false;
	var _this = window.document;
	this.element = _this.createElement("div");
	this.element.classList.add("menu",id,"shown");
};
fubar_gui_player_ControlMenu.__name__ = ["fubar","gui","player","ControlMenu"];
fubar_gui_player_ControlMenu.prototype = {
	show: function() {
		this.hidden = false;
		this.element.classList.add("shown");
		this.element.classList.remove("hidden");
	}
	,hide: function() {
		this.hidden = true;
		this.element.classList.remove("shown");
		this.element.classList.add("hidden");
	}
	,addIconButton: function(id) {
		var e = this.createIconButton(id);
		this.element.appendChild(e);
		return e;
	}
	,createIconButton: function(id) {
		var img;
		var _this = window.document;
		img = _this.createElement("img");
		img.classList.add("button",id);
		img.src = "image/ic_" + id + ".png";
		return img;
	}
	,__class__: fubar_gui_player_ControlMenu
};
var fubar_gui_player_ControlMenuAutoplay = function(autoplay) {
	fubar_gui_player_ControlMenu.call(this,"autoplay");
	this.buttonPlay = this.addIconButton("play");
	this.buttonPause = this.addIconButton("pause");
	this.set(autoplay);
	this.element.addEventListener("click",$bind(this,this.handleClick),false);
};
fubar_gui_player_ControlMenuAutoplay.__name__ = ["fubar","gui","player","ControlMenuAutoplay"];
fubar_gui_player_ControlMenuAutoplay.__super__ = fubar_gui_player_ControlMenu;
fubar_gui_player_ControlMenuAutoplay.prototype = $extend(fubar_gui_player_ControlMenu.prototype,{
	onChange: function(autoplay) {
	}
	,handleClick: function(e) {
		e.stopPropagation();
		e.preventDefault();
		this.set(!this.autoplay);
	}
	,set: function(autoplay) {
		this.autoplay = autoplay;
		if(autoplay) {
			this.buttonPlay.style.display = "none";
			this.buttonPause.style.display = "inline-block";
		} else {
			this.buttonPlay.style.display = "inline-block";
			this.buttonPause.style.display = "none";
		}
		this.onChange(autoplay);
	}
	,__class__: fubar_gui_player_ControlMenuAutoplay
});
var fubar_gui_player_PlaySettingsChange = { __ename__ : true, __constructs__ : ["mode","search"] };
fubar_gui_player_PlaySettingsChange.mode = function(m) { var $x = ["mode",0,m]; $x.__enum__ = fubar_gui_player_PlaySettingsChange; $x.toString = $estr; return $x; };
fubar_gui_player_PlaySettingsChange.search = function(t) { var $x = ["search",1,t]; $x.__enum__ = fubar_gui_player_PlaySettingsChange; $x.toString = $estr; return $x; };
var fubar_gui_player_ControlMenuMode = function() {
	var _g = this;
	fubar_gui_player_ControlMenu.call(this,"mode");
	this.trendingButton = this.addIconButton("trending");
	this.trendingButton.onclick = function(_) {
		_g.setMode("search");
		_g.onChange(fubar_gui_player_PlaySettingsChange.mode("search"));
	};
	this.searchButton = this.addIconButton("search");
	this.searchButton.style.display = "none";
	this.searchButton.onclick = function(_1) {
		_g.setMode("trending");
		_g.onChange(fubar_gui_player_PlaySettingsChange.mode("trending"));
	};
	var _this = window.document;
	this.searchInput = _this.createElement("input");
	this.searchInput.type = "search";
	this.searchInput.addEventListener("input",$bind(this,this.handleSearchInput),false);
	this.searchInput.addEventListener("search",$bind(this,this.handleSearchEnter),false);
	this.element.appendChild(this.searchInput);
	this.searchClear = this.addIconButton("clear");
	this.searchClear.addEventListener("click",$bind(this,this.handleClearClick),false);
	this.setMode("trending");
};
fubar_gui_player_ControlMenuMode.__name__ = ["fubar","gui","player","ControlMenuMode"];
fubar_gui_player_ControlMenuMode.__super__ = fubar_gui_player_ControlMenu;
fubar_gui_player_ControlMenuMode.prototype = $extend(fubar_gui_player_ControlMenu.prototype,{
	onChange: function(change) {
	}
	,setMode: function(mode) {
		this.mode = mode;
		var _g = this.mode;
		switch(_g) {
		case "trending":
			this.trendingButton.style.display = "inline-block";
			this.searchButton.style.display = "none";
			this.searchInput.style.display = "none";
			this.searchClear.style.opacity = "0";
			break;
		case "search":
			this.trendingButton.style.display = "none";
			this.searchButton.style.display = "inline-block";
			this.searchInput.style.display = "inline-block";
			if(this.searchInput.value.length == 0) {
				this.searchClear.style.opacity = "0";
				this.searchInput.focus();
			} else this.searchClear.style.opacity = "1";
			break;
		}
	}
	,setSearchText: function(text) {
		this.searchInput.value = text;
		this.updateSearchInput();
	}
	,updateSearchInput: function() {
		this.searchInput.style.width = (16.8 + 14 * this.searchInput.value.length | 0) + "px";
		if(this.searchInput.value.length == 0) {
			this.searchClear.style.opacity = "0";
			this.searchInput.focus();
		} else this.searchClear.style.opacity = "1";
	}
	,handleSearchInput: function(e) {
		this.updateSearchInput();
	}
	,handleSearchEnter: function(e) {
		e.preventDefault();
		e.stopPropagation();
		this.searchInput.blur();
		this.onChange(fubar_gui_player_PlaySettingsChange.search(this.searchInput.value));
	}
	,handleClearClick: function(e) {
		e.stopPropagation();
		e.preventDefault();
		this.setSearchText("");
		this.searchInput.focus();
	}
	,__class__: fubar_gui_player_ControlMenuMode
});
var fubar_gui_player_ControlMenuShare = function() {
	var _g = this;
	fubar_gui_player_ControlMenu.call(this,"share");
	this.isMenuOpen = false;
	this.isMouseOver = false;
	this.timer = new haxe_Timer(3000);
	var _this = window.document;
	this.menu = _this.createElement("div");
	this.menu.classList.add("menu","closed");
	this.element.onmouseenter = function() {
		_g.isMouseOver = true;
	};
	this.element.onmouseleave = function() {
		_g.isMouseOver = false;
		if(_g.timer == null) _g.closeMenu();
	};
	this.element.appendChild(this.menu);
	this.optShare = this.addMenuOption("share",function() {
		_g.closeMenu();
		if(_g.item != null) window.open(_g.item.bitly_url,"_blank");
	});
	this.optLink = this.addMenuOption("link",function() {
	});
	this.optLink.target = "_blank";
	this.optDownload = this.addMenuOption("download",function() {
		_g.closeMenu();
	});
	this.more = this.createIconButton("more_vert");
	this.more.onclick = $bind(this,this.toggleMenu);
	this.element.appendChild(this.more);
};
fubar_gui_player_ControlMenuShare.__name__ = ["fubar","gui","player","ControlMenuShare"];
fubar_gui_player_ControlMenuShare.__super__ = fubar_gui_player_ControlMenu;
fubar_gui_player_ControlMenuShare.prototype = $extend(fubar_gui_player_ControlMenu.prototype,{
	set_item: function(n) {
		this.item = n;
		if(this.item == null) {
			this.optLink.href = null;
			this.optDownload.href = null;
			this.optDownload.download = null;
			this.optShare.style.display = "none";
			this.optLink.style.display = "none";
			this.optDownload.style.display = "none";
		} else {
			var sourceUrl = this.item.source_post_url;
			if(sourceUrl == null || sourceUrl.length == 0) {
				this.optLink.href = null;
				this.optLink.style.display = "none";
			} else {
				this.optLink.href = sourceUrl;
				this.optLink.style.display = "inline-block";
				var icon;
				if(sourceUrl.indexOf("reddit.com") != -1) icon = "reddit"; else if(sourceUrl.indexOf("tumblr.com") != -1) icon = "tumblr"; else if(sourceUrl.indexOf("youtube.com") != -1) icon = "youtube"; else icon = "link";
				this.optLink.children[0].src = "image/ic_" + icon + ".png";
			}
			this.optDownload.href = this.item.images.original.url;
			this.optDownload.download = "giphy-" + this.item.id + ".gif";
		}
		return this.item;
	}
	,openMenu: function() {
		var _g = this;
		this.destroyTimer();
		this.isMenuOpen = true;
		this.menu.classList.remove("closed");
		this.menu.classList.add("opened");
		this.timer = new haxe_Timer(3000);
		this.timer.run = function() {
			_g.timer.stop();
			_g.timer = null;
			if(!_g.isMouseOver) _g.closeMenu();
		};
		return true;
	}
	,closeMenu: function() {
		this.destroyTimer();
		this.isMenuOpen = false;
		this.menu.classList.remove("opened");
		this.menu.classList.add("closed");
		return false;
	}
	,toggleMenu: function() {
		if(this.isMenuOpen) return this.closeMenu(); else return this.openMenu();
	}
	,addMenuOption: function(id,onSelect) {
		var a;
		var _this = window.document;
		a = _this.createElement("a");
		a.classList.add("option");
		var icon;
		var _this1 = window.document;
		icon = _this1.createElement("img");
		icon.src = "image/ic_" + id + ".png";
		icon.classList.add("button");
		a.appendChild(icon);
		this.menu.appendChild(a);
		if(onSelect != null) {
			a.onclick = onSelect;
			a.ontouchstart = onSelect;
		}
		return a;
	}
	,destroyTimer: function() {
		if(this.timer != null) {
			this.timer.stop();
			this.timer = null;
		}
	}
	,__class__: fubar_gui_player_ControlMenuShare
});
var fubar_gui_player_Controls = function(autoplay) {
	this.hidden = false;
	this.menus = [];
	var _this = window.document;
	this.element = _this.createElement("div");
	this.element.classList.add("controls","shown");
	this.mode = this.addControlMenu(new fubar_gui_player_ControlMenuMode());
	this.play = this.addControlMenu(new fubar_gui_player_ControlMenuAutoplay(autoplay));
	this.share = this.addControlMenu(new fubar_gui_player_ControlMenuShare());
};
fubar_gui_player_Controls.__name__ = ["fubar","gui","player","Controls"];
fubar_gui_player_Controls.prototype = {
	show: function() {
		this.hidden = false;
		this.element.classList.add("shown");
		this.element.classList.remove("hidden");
		var _g = 0;
		var _g1 = this.menus;
		while(_g < _g1.length) {
			var m = _g1[_g];
			++_g;
			m.show();
		}
	}
	,hide: function() {
		this.hidden = true;
		this.element.classList.remove("shown");
		this.element.classList.add("hidden");
		var _g = 0;
		var _g1 = this.menus;
		while(_g < _g1.length) {
			var m = _g1[_g];
			++_g;
			m.hide();
		}
	}
	,toggle: function() {
		if(this.hidden) this.show(); else this.hide();
	}
	,addControlMenu: function(menu) {
		this.element.appendChild(menu.element);
		this.menus.push(menu);
		return menu;
	}
	,__class__: fubar_gui_player_Controls
};
var fubar_gui_player_ItemView = function(item) {
	var _g1 = this;
	var _this = window.document;
	this.element = _this.createElement("div");
	this.element.classList.add("item","inc");
	this.element.addEventListener("animationend",function(e) {
		var _g = e.animationName;
		switch(_g) {
		case "item_inc":
			_g1.element.classList.remove("inc");
			break;
		case "item_out":
			_g1.element.remove();
			break;
		default:
			if(StringTools.startsWith(e.animationName,"item_")) _g1.element.classList.remove(HxOverrides.substr(e.animationName,"item_".length,null));
		}
	},false);
	var _this1 = window.document;
	this.gif = _this1.createElement("img");
	this.gif.classList.add("gif");
	this.gif.onload = function() {
		_g1.gif.style.display = "inline-block";
		_g1.gif.classList.add("playing");
		_g1.onLoad();
	};
	this.element.appendChild(this.gif);
	this.gif.src = item.images.original.url;
	var _this2 = window.document;
	this.still = _this2.createElement("img");
	this.still.onload = function() {
		_g1.still.style.display = "inline-block";
	};
};
fubar_gui_player_ItemView.__name__ = ["fubar","gui","player","ItemView"];
fubar_gui_player_ItemView.prototype = {
	onLoad: function() {
	}
	,onLoadProgress: function(bytes,total) {
	}
	,remove: function(immediately) {
		if(immediately == null) immediately = false;
		if(immediately) this.element.remove(); else {
			this.element.classList.remove("playing");
			this.element.classList.add("out");
		}
	}
	,__class__: fubar_gui_player_ItemView
};
var fubar_net_ImagePreloader = function(maxConcurrentPreloads) {
	if(maxConcurrentPreloads == null) maxConcurrentPreloads = 10;
	this.maxConcurrentPreloads = maxConcurrentPreloads;
	this.numActivePreloads = 0;
	this.map = new haxe_ds_StringMap();
	this.worker = new Worker("worker/image-preloader.js");
	this.worker.onmessage = function(e) {
		var _g = e.data.status;
		switch(_g) {
		case 0:
			break;
		case 1:
			null;
			break;
		}
	};
	this.worker.onerror = function(e1) {
		null;
	};
};
fubar_net_ImagePreloader.__name__ = ["fubar","net","ImagePreloader"];
fubar_net_ImagePreloader.prototype = {
	preload: function(url,onResult,useWorker) {
		if(useWorker == null) useWorker = false;
		var _g = this;
		if(this.map.exists(url)) return;
		if(this.numActivePreloads == this.maxConcurrentPreloads) return;
		if(useWorker) this.worker.postMessage({ type : 0, url : url}); else {
			var xhr = new XMLHttpRequest();
			this.map.set(url,xhr);
			this.numActivePreloads++;
			xhr.responseType = "blob";
			xhr.open("GET",url,true);
			xhr.onload = function(e) {
				_g.map.remove(url);
				_g.numActivePreloads--;
				if(onResult != null) onResult(null);
			};
			xhr.onerror = function(e1) {
				_g.map.remove(url);
				_g.numActivePreloads--;
				if(onResult != null) onResult(e1);
			};
			xhr.send();
		}
	}
	,dispose: function() {
		var $it0 = this.map.iterator();
		while( $it0.hasNext() ) {
			var r = $it0.next();
			r.abort();
		}
		this.map = new haxe_ds_StringMap();
		this.numActivePreloads = 0;
		if(this.worker != null) {
			this.worker.postMessage({ type : 1});
			this.worker.terminate();
		}
	}
	,__class__: fubar_net_ImagePreloader
};
var haxe_IMap = function() { };
haxe_IMap.__name__ = ["haxe","IMap"];
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe_Timer.__name__ = ["haxe","Timer"];
haxe_Timer.prototype = {
	stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe_Timer
};
var haxe_ds__$StringMap_StringMapIterator = function(map,keys) {
	this.map = map;
	this.keys = keys;
	this.index = 0;
	this.count = keys.length;
};
haxe_ds__$StringMap_StringMapIterator.__name__ = ["haxe","ds","_StringMap","StringMapIterator"];
haxe_ds__$StringMap_StringMapIterator.prototype = {
	hasNext: function() {
		return this.index < this.count;
	}
	,next: function() {
		return this.map.get(this.keys[this.index++]);
	}
	,__class__: haxe_ds__$StringMap_StringMapIterator
};
var haxe_ds_StringMap = function() {
	this.h = { };
};
haxe_ds_StringMap.__name__ = ["haxe","ds","StringMap"];
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	set: function(key,value) {
		if(__map_reserved[key] != null) this.setReserved(key,value); else this.h[key] = value;
	}
	,get: function(key) {
		if(__map_reserved[key] != null) return this.getReserved(key);
		return this.h[key];
	}
	,exists: function(key) {
		if(__map_reserved[key] != null) return this.existsReserved(key);
		return this.h.hasOwnProperty(key);
	}
	,setReserved: function(key,value) {
		if(this.rh == null) this.rh = { };
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) return null; else return this.rh["$" + key];
	}
	,existsReserved: function(key) {
		if(this.rh == null) return false;
		return this.rh.hasOwnProperty("$" + key);
	}
	,remove: function(key) {
		if(__map_reserved[key] != null) {
			key = "$" + key;
			if(this.rh == null || !this.rh.hasOwnProperty(key)) return false;
			delete(this.rh[key]);
			return true;
		} else {
			if(!this.h.hasOwnProperty(key)) return false;
			delete(this.h[key]);
			return true;
		}
	}
	,arrayKeys: function() {
		var out = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) out.push(key);
		}
		if(this.rh != null) {
			for( var key in this.rh ) {
			if(key.charCodeAt(0) == 36) out.push(key.substr(1));
			}
		}
		return out;
	}
	,iterator: function() {
		return new haxe_ds__$StringMap_StringMapIterator(this,this.arrayKeys());
	}
	,__class__: haxe_ds_StringMap
};
var js_Boot = function() { };
js_Boot.__name__ = ["js","Boot"];
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var om_Error = function() { };
om_Error.__name__ = ["om","Error"];
om_Error.__super__ = Error;
om_Error.prototype = $extend(Error.prototype,{
	__class__: om_Error
});
var om_System = function() { };
om_System.__name__ = ["om","System"];
om_System.isMobile = function(userAgent,mobileUserAgents) {
	if(userAgent == null) userAgent = window.navigator.userAgent;
	if(mobileUserAgents == null) mobileUserAgents = om_System.mobileUserAgents;
	return new EReg(mobileUserAgents.join("|"),"i").match(userAgent);
};
var om_app_ActivityState = { __ename__ : true, __constructs__ : ["init","create","start","restart","resume","pause","stop","destroy"] };
om_app_ActivityState.init = ["init",0];
om_app_ActivityState.init.toString = $estr;
om_app_ActivityState.init.__enum__ = om_app_ActivityState;
om_app_ActivityState.create = ["create",1];
om_app_ActivityState.create.toString = $estr;
om_app_ActivityState.create.__enum__ = om_app_ActivityState;
om_app_ActivityState.start = ["start",2];
om_app_ActivityState.start.toString = $estr;
om_app_ActivityState.start.__enum__ = om_app_ActivityState;
om_app_ActivityState.restart = ["restart",3];
om_app_ActivityState.restart.toString = $estr;
om_app_ActivityState.restart.__enum__ = om_app_ActivityState;
om_app_ActivityState.resume = ["resume",4];
om_app_ActivityState.resume.toString = $estr;
om_app_ActivityState.resume.__enum__ = om_app_ActivityState;
om_app_ActivityState.pause = ["pause",5];
om_app_ActivityState.pause.toString = $estr;
om_app_ActivityState.pause.__enum__ = om_app_ActivityState;
om_app_ActivityState.stop = ["stop",6];
om_app_ActivityState.stop.toString = $estr;
om_app_ActivityState.stop.__enum__ = om_app_ActivityState;
om_app_ActivityState.destroy = ["destroy",7];
om_app_ActivityState.destroy.toString = $estr;
om_app_ActivityState.destroy.__enum__ = om_app_ActivityState;
var om_html__$DivElement_DivElement_$Impl_$ = {};
om_html__$DivElement_DivElement_$Impl_$.__name__ = ["om","html","_DivElement","DivElement_Impl_"];
om_html__$DivElement_DivElement_$Impl_$._new = function(text,_classes) {
	var this1;
	var _this = window.document;
	this1 = _this.createElement("div");
	if(text != null) this1.textContent = text;
	if(_classes != null) {
		var _g = 0;
		while(_g < _classes.length) {
			var c = _classes[_g];
			++_g;
			this1.classList.add(c);
		}
	}
	return this1;
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
String.prototype.__class__ = String;
String.__name__ = ["String"];
Array.__name__ = ["Array"];
var __map_reserved = {}
fubar_Storage.storage = js_Browser.getLocalStorage();
om_app_Activity.stack = [];
js_Boot.__toStr = {}.toString;
om_System.mobileUserAgents = ["Android","webOS","iPhone","iPad","iPod","BlackBerry","IEMobile","Opera Mini"];
fubar_App.main();
})(typeof console != "undefined" ? console : {log:function(){}}, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

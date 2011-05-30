package adiwars.user.items{
	import adiwars.UndefinedIcon;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import ru.gotoandstop.resources.Resource;
	import ru.gotoandstop.resources.ResourceLibrary;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class AdiwarsLibrary{
		private var cache:Object;
		private var library:ResourceLibrary;
		
		private var urlCache:Object;
		
		public function AdiwarsLibrary(lib:ResourceLibrary){
			this.library = lib;
			this.cache = new Object();
			this.urlCache = new Object();
			
			//http://cs11282.vkontakte.ru/crossdomain.xml
		}
		
		public function getRemoteImage(url:String):DisplayObject{
			trace('load image', url)
			
			if(url == 'http://vkontakte.ru/images/question_c.gif') url = 'http://starwars.nlomarketing.ru/question_c.gif';
			if(url == '') url = 'http://starwars.nlomarketing.ru/question_c.gif';
			
//			var exp:RegExp = /(cs[0-9]+.vkontakte.ru)/;
//			var a:Array = url.match(exp);
//			var server:String = a[1];
//			trace(a)
				
			var clip:DisplayObject;
			
			var old:DisplayObject = this.getFromURLCache(url);
			if(old){
				clip = old;
			}else{
				var loader:Loader = new Loader();
				//var c:LoaderContext = loader.loaderInfo.c
				loader.load(new URLRequest(url), new LoaderContext(true));
				clip = loader;
				this.pushToCache(url, loader);
			}
			
			//clip = new UndefinedIcon();
			
			return clip;
		}
		
//		private function handleLoadError(event:Event):void{
//			var info:LoaderInfo = event.target as LoaderInfo;
//			var loader:Loader = info.loader;
//			loader
//		}
		
		private function pushToURLCache(key:String, value:*):void{
			this.urlCache[key] = value;
		}
		
		private function getFromURLCache(key:String):*{
			return this.urlCache[key];
		}
		
		public function getResourceClip(clipClass:String):DisplayObject{
			var icon:DisplayObject;
			
			var Cached:Class = this.getFromCache(clipClass);
			if(Cached){
				icon = new Cached();
			}else{
				var resource_keys:Array = this.library.getKeys();
				
				for each(var key:String in resource_keys){
					var resource:Resource = this.library.get(key);
					if(resource){
						var clip:DisplayObject = resource.data as DisplayObject;
						if(clip){
							try{
								var ClipClass:Class = clip.loaderInfo.applicationDomain.getDefinition(clipClass) as Class;
								icon = new ClipClass();
								this.pushToCache(clipClass, ClipClass);
								
								break;
							}catch(error:Error){
								
							}
						}
					}
				}
			}
			if(!icon){
				icon = new UndefinedIcon();
				this.pushToCache(clipClass, UndefinedIcon);
				
				trace('undefined icon in adilib is', clipClass)
			}
			return icon;
		}
		
		private function pushToCache(key:String, value:*):void{
			this.cache[key] = value;
		}
		
		private function getFromCache(key:String):*{
			return this.cache[key];
		}
	}
}
package adiwars{
	import adiwars.core.Config;
	import adiwars.core.Context;
	import adiwars.states.ApplicationStateKey;
	import adiwars.states.LoadingState;
	import adiwars.states.ScreenSlider;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.Security;
	import flash.utils.setTimeout;
	
	import ru.gotoandstop.resources.Resource;
	import ru.gotoandstop.resources.ResourceLibrary;
	import ru.gotoandstop.resources.ResourceLoaderEvent;
	
	import social.ISocialGameApplication;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class AdiwarsLoader extends Sprite implements ISocialGameApplication{
		private var dialogsContainer:Sprite;
		private var screensContainer:Sprite;
		
		private var config:Config;
		private var context:Context;
		private var states:ScreenSlider;
		
		private var library:ResourceLibrary;
		private var indicator:Indicator;
		
		public function AdiwarsLoader(){
			super();
//			this.init();
//			if(super.stage){
//				this.init();
//			}else{
//				super.addEventListener(Event.ADDED_TO_STAGE, this.handlerAddedToStage);
//			}
		}
		
		protected function init():void{
			var allowed_domain:String = super.loaderInfo.loaderURL;
			//Security.allowDomain(allowed_domain);//'*.vkontakte.ru', '*.vk.com');
			//Security.allowDomain('*');
			
			this.dialogsContainer = new Sprite();
			this.screensContainer = new Sprite();
			
			super.addChild(this.screensContainer);
			super.addChild(this.dialogsContainer);
			
			//super.addChild(new Performance(200000));
			
			this.library = new ResourceLibrary();
			this.library.loader.addEventListener(ResourceLoaderEvent.QUEUE_COMPLETE, this.handleQueueComplete);
			
			var init_url:String = this.config.context.value.(@key=='initFileURL');
			var init:Resource = this.library.loader.add(init_url, 'init');
			this.addInitResourceListeners(init);
			
			this.indicator = new Indicator();
			this.context = Context.create(this.library, this.screensContainer, this.dialogsContainer);
			this.context.config = this.config;
			
			this.states = this.context.applicationStates;
			this.states.register(new LoadingState(this.context, this.indicator));
			
			this.library.loader.start();
			this.states.activateState(ApplicationStateKey.LOADING);
		}
		
		private function handlerAddedToStage(event:Event):void{
			super.removeEventListener(Event.ADDED_TO_STAGE, this.handlerAddedToStage);
			this.init();
		}
		
		private function addInitResourceListeners(init:Resource):void{
			init.addEventListener(Event.COMPLETE, this.handleInitFileLoadComplete);
			init.addEventListener(IOErrorEvent.IO_ERROR, this.handleInitFileLoadError);
			init.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleInitFileLoadError);
		}
		
		private function removeInitResourceListeners(init:Resource):void{
			init.removeEventListener(Event.COMPLETE, this.handleInitFileLoadComplete);
			init.removeEventListener(IOErrorEvent.IO_ERROR, this.handleInitFileLoadError);
			init.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleInitFileLoadError);
		}
		
		private function handleInitFileLoadComplete(event:Event):void{
			const resource:Resource = event.target as Resource;
			var init:XML = new XML(resource.data);
			
			var main:Resource;
			for each(var file:XML in init..library){
				var res:Resource = this.library.loader.add(file.@src, file.@key, true);
				if(file.@key == 'main') main = res;
			}
			
			if(main) this.indicator.setTarget(main);
		}
		
		private function handleInitFileLoadError(event:Event):void{
			trace('cannot load init.xml');
		}
		
		private function handleQueueComplete(event:ResourceLoaderEvent):void{
			this.library.loader.removeEventListener(ResourceLoaderEvent.QUEUE_COMPLETE, this.handleQueueComplete);
			
			var main:IAdiwarsGame = this.library.get('main').data as IAdiwarsGame;
			if(main){
				main.launch(this.context, this.config);
			}else{
				trace('pizda')
			}
		}
		
		public function launch(config:Config):void{
			this.doLaunch(config);
		}
		
		private function doLaunch(config:Config):void{
			this.config = config;
			this.init();
		}
	}
}
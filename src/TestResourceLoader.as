package{
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
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import ru.etcs.utils.getDefinitionNames;
	import ru.gotoandstop.resources.Resource;
	import ru.gotoandstop.resources.ResourceLibrary;
	import ru.gotoandstop.resources.ResourceLoaderEvent;
	
	import social.ISocialGameApplication;
	
	[SWF(width=700, height=600, backgroundColor=0, frameRate="50")]
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class TestResourceLoader extends Sprite{
		private var library:ResourceLibrary;
		
		public function TestResourceLoader(){
			super();
			
			//Security.allowDomain('*.vkontakte.ru', '*.vk.com');
			
			this.library = new ResourceLibrary();
			this.library.loader.addEventListener(ResourceLoaderEvent.QUEUE_COMPLETE, this.handleQueueComplete);
			
			var init1:String = 'http://adiwars.ideafixe.ru/init.xml';
			var init2:String = 'init.xml';
			
			var init:Resource = this.library.loader.add(init1, 'init');
			this.addInitResourceListeners(init);
			
			this.library.loader.start();
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
			
			trace(init.toXMLString())
			var main:Resource;
			for each(var file:XML in init..library){
				var res:Resource = this.library.loader.add(file.@src, file.@key, true);
				if(file.@key == 'main') main = res;
			}
		}
		
		private function handleInitFileLoadError(event:Event):void{
			this.showMessage('cannot load init.xml');
		}
		
		private function handleQueueComplete(event:ResourceLoaderEvent):void{
			this.library.loader.removeEventListener(ResourceLoaderEvent.QUEUE_COMPLETE, this.handleQueueComplete);
			var message:String = '';
			var resource_list:Array = this.library.getKeys();
			
			for each(var key:String in resource_list){
				var res:Resource = this.library.get(key);
				var d_o:DisplayObject = res.data as DisplayObject;
				trace(key, res.bytes.length)
				var list:Array = getDefinitionNames(res.bytes, true);
				message += '<<<'+key+'>>>';
				message += '\n';
				message += list.join('\n');
			}
			this.showMessage(message);
		}
		
		private function showMessage(mes:String):void{
			trace(mes)
			var txt:TextField = new TextField();
			txt.width = 700;
			txt.height = 600;
			txt.defaultTextFormat = new TextFormat('_typewriter', 12, 0x00ff00);
			txt.text = mes;
			super.addChild(txt);
		}
	}
}
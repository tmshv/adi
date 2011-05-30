package{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import ru.gotoandstop.vkontakte.params.VkontakteParams;
	
	import vk.APIConnection;
	import social.ISocialApplication;
	import social.ISocialGameApplication;
	
	[SWF(width=700, height=600, backgroundColor=0x000000, frameRate=50)]
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class ApplicationBase extends Sprite{
		public function ApplicationBase(){
			super();
			if(super.stage){
				this.init();
			}else{
				super.addEventListener(Event.ADDED_TO_STAGE, this.handlerAddedToStage);
			}
		}
		
		private function handlerAddedToStage(event:Event):void{
			super.removeEventListener(Event.ADDED_TO_STAGE, this.handlerAddedToStage);
			this.init();
		}
		
		private function init():void{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.handlerLoadAPIComplete);
			loader.load(new URLRequest('VkontakteApplication.swf'));
		}
		
		private function handlerLoadAPIComplete(event:Event):void{
			const loader_info:LoaderInfo = event.target as LoaderInfo;
			loader_info.removeEventListener(Event.COMPLETE, this.handlerLoadAPIComplete);
			const loader:Loader = loader_info.loader;
			
			super.addChild(loader.content);
		}
	}
}
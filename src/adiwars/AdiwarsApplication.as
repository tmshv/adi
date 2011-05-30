package adiwars{
	import adiwars.core.Config;
	import adiwars.core.Context;
	import adiwars.states.MenuState;
	import adiwars.states.MenuView;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import remote.ISocialAPI;
	import remote.RemoteEvent;
	import remote.RemoteRequest;
	
	import ru.gotoandstop.resources.ResourceLibrary;
	
	import social.ISocialApplication;
	import social.ISocialGameApplication;
	
	[SWF(width=700, height=600, frameRate=31, backgroundColor=0x000000)]
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class AdiwarsApplication extends Sprite implements IAdiwarsGame{
		private var controller:MainGameController;
		
		public function AdiwarsApplication(){
		
		}
		
		public function launch(context:Context, config:Config):void{
			//super.stage.addEventListener(Event.ADDED, this.handleAddedToStage);
			
			this.controller = new MainGameController(this, context, config);
		}
		
		private function handleAddedToStage(event:Event):void{
//			var clip:DisplayObject = event.target as DisplayObject;
//			clip.opaqueBackground = 0xffff00;
//			//cacheAsBitmap = true;
//			trace(clip, clip.name);
		}
	}
}
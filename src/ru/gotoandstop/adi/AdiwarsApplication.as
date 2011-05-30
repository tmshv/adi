package ru.gotoandstop.adi{
	import ru.gotoandstop.adi.core.Config;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.states.MenuState;
	import ru.gotoandstop.adi.states.MenuView;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import ru.gotoandstop.adi.remote.ISocialAPI;
	import ru.gotoandstop.adi.remote.RemoteEvent;
	import ru.gotoandstop.adi.remote.RemoteRequest;
	
	import ru.gotoandstop.resources.ResourceLibrary;
	
	import ru.gotoandstop.adi.social.ISocialApplication;
	import ru.gotoandstop.adi.social.ISocialGameApplication;
	
	[SWF(width=700, height=600, frameRate=31, backgroundColor=0x000000)]
	
	/**
	 * 
	 * Ошибки:
	 * 
	 * 200 - ошибка авторизации
	 * 201 - пользователь отсутствует в базе
	 * 202 - передан некорректный тип персонажа
	 * 203 - передан пустой ник
	 * 204
	 * 205 - пользователь уже существует
	 * 206
	 * 213
	 * 214
	 * @author Roman Timashev (roman@tmshv.ru)
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
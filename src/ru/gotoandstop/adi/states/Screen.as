package ru.gotoandstop.adi.states{
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.mvc.BaseController;
	import ru.gotoandstop.adi.core.mvc.BaseModel;
	import ru.gotoandstop.adi.dialogs.Dialog;
	import ru.gotoandstop.adi.states.events.StateEvent;
	import ru.gotoandstop.adi.ui.UIElement;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	import ru.gotoandstop.adi.remote.ISocialAPI;
	import ru.gotoandstop.adi.remote.RemoteRequest;
	
	[Event(name="enabled", type="ru.gotoandstop.adi.states.events.StateEvent")]
	[Event(name="disabled", type="ru.gotoandstop.adi.states.events.StateEvent")]
	
	/**
	 * Базовый класс, отвечающий за состояние системы
	 * Должен быть переделан под это )))
	 * @author Timashev Roman
	 */
	public class Screen extends UIElement{
		private var _manager:ScreenSlider;
		public function get manager():ScreenSlider{
			return this._manager;
		}
		public function set manager(value:ScreenSlider):void{
			this._manager = value;
		}
		
		private var _key:String;
		public function get key():String{
			return this._key;
		}
		
		public var enabled:Boolean;
		
		public function Screen(container:DisplayObjectContainer, context:Context, key:String){
			super(container, context);
			this._key = key;
		}
		
		internal function init():void{
			
		}
		
		/**
		 * Включить состояние 
		 */
		public override function enable():void{
			this.enabled = true;
			super.dispatchEvent(new StateEvent(StateEvent.ENABLED, false, false, this));
		}
		
		/**
		 * Отключить состояние
		 */
		public override function disable():void{
			this.enabled = false;
			super.dispatchEvent(new StateEvent(StateEvent.DISABLED, false, false, this));
		}
		
		public function addDialog(dialog:Dialog):Dialog{
			return dialog;
		}
		
		public override function toString():String{
			var text:String = '[state <key>]';
			text = text.replace(/<key>/, this.key);
			return text;
		}
		
		internal function getLayout():DisplayObject{
			return null;
		}
		
		public function send(...params):void{
			
		}
		
		public function activate():void{
			if(this.manager){
				this.manager.activateState(this.key);
			}
		}
		
//		public override function set container(value:DisplayObjectContainer):void{
//			throw new Error();
//		}
//		
//		internal function setLayoutContainer(container:DisplayObjectContainer):void{
//			super.container = container;
//		}
	}
}
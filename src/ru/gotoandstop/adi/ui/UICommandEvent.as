package ru.gotoandstop.adi.ui{
	import flash.events.Event;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class UICommandEvent extends Event{
		public static const COMMAND:String = 'command';
		
		public static function command(command:String, params:Object=null):UICommandEvent{
			return new UICommandEvent(UICommandEvent.COMMAND, false, false, command, params);
		}
		
		private var _command:String;
		public function get command():String{
			return this._command;
		}
		
		private var _params:Object;
		public function get params():Object{
			return this._params;
		}
		
		public function UICommandEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, command:String='', params:Object=null){
			super(type, bubbles, cancelable);
			this._command = command;
			this._params = params;
		}
		
		public override function clone():Event{
			return new UICommandEvent(super.type, super.bubbles, super.cancelable, this.command, this.params);
		}
		
		public override function toString():String{
			var string:String = '[ui command <command>]';
			return string.replace(/<command>/, this.command);
		}
	}
}
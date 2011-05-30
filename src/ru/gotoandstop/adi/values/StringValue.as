package ru.gotoandstop.adi.values{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class StringValue extends EventDispatcher{
		private var _value:String;
		public function get value():String{
			return this._value;
		}
		public function set value(value:String):void{
			this._value = value;
			this.update();
		}
		
		public function StringValue(value:String=''){
			super();
			this.value = value;
		}
		
		private function update():void{
			super.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public override function toString():String{
			var text:String = '[<value>]';
			text = text.replace(/<value>/, this.value);
			return text;
		}
	}
}
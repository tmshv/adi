package adiwars.values{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class BooleanValue extends EventDispatcher{
		private var _value:Boolean;
		public function get value():Boolean{
			return this._value;
		}
		public function set value(value:Boolean):void{
			this._value = value;
			this.update();
		}
		
		public function BooleanValue(value:Boolean=false){
			super();
			this.value = value;
		}
		
		public function update():void{
			super.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public override function toString():String{
			var text:String = '[<value>]';
			text = text.replace(/<value>/, this.value);
			return text;
		}
	}
}
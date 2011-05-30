package adiwars.values{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class IntValue2 extends EventDispatcher{
		private var _value:int;
		public function get value():int{
			return this._value;
		}
		
		public var maxValue:int;
		public var minValue:int;
		
		public function IntValue2(minValue:uint=0, maxValue:uint=0xffffff){
			super();
			this.maxValue = maxValue;
			this.minValue = minValue;
			this.setValue(this.minValue);
		}
		
		public function increase():void{
			this.setValue(this._value + 1);
			this.update();
		}
		
		public function decrease():void{
			this.setValue(this._value - 1);
			this.update();
		}
		
		public function setValue(value:int):void{
			value = Math.max(value, this.minValue);
			this._value = Math.min(value, this.maxValue);
			this.update();
		}
		
		public function getRatio(fromZero:Boolean=false):Number{
			if(fromZero){
				return this.value / this.maxValue;
			}else{
				var f:int = this.maxValue - this.minValue;
				var v:int = this.value - this.minValue;
				return v/f;
			}
		}
		
		public function isEmpty():Boolean{
			return this.value == this.minValue;
		}
		
		public function isFull():Boolean{
			return this.value == this.maxValue;
		}
		
		private function update():void{
			super.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
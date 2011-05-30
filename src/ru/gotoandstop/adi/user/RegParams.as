package ru.gotoandstop.adi.user{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * Модель данных, указанных при регистрации новго игрока
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class RegParams extends EventDispatcher{
		private static var _instance:RegParams;
		public static function get instance():RegParams{
			if(!RegParams._instance) RegParams._instance = new RegParams();
			return RegParams._instance;
		}
		
		private var _nick:String;
		public function get nick():String{
			return this._nick;
		}
		public function set nick(value:String):void{
			this._nick = value;
			this.update();
		}

		private var _type:String;
		public function get type():String{
			return this._type;
		}
		public function set type(value:String):void{
			this._type = value;
			this.update();
		}

		private var _agility:uint;
		public function get agility():uint{
			return this._agility;
		}
		public function set agility(value:uint):void{
			this._agility = value;
			this.update();
		}

		private var _accuracy:uint;
		public function get accuracy():uint{
			return this._accuracy;
		}
		public function set accuracy(value:uint):void{
			this._accuracy = value;
			this.update();
		}

		private var _strength:uint;
		public function get strength():uint{
			return this._strength;
		}
		public function set strength(value:uint):void{
			this._strength = value;
			this.update();
		}
		
		public function RegParams(){
			super();
		}
		
		public function update():void{
			super.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
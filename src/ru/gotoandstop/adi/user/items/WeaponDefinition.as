package ru.gotoandstop.adi.user.items{
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.mvc.BaseModel;
	import ru.gotoandstop.adi.ui.GameItem;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class WeaponDefinition extends GameItem{
		public static function createByXML(definition:XML):WeaponDefinition{
			var weapon:WeaponDefinition = new WeaponDefinition();
			weapon._cost = definition.@cost;
			weapon._damage = definition.@damage;
			weapon._minUserLevel = definition.@level;
			weapon._picID = definition.@pic;
			weapon._title = definition.@title;
			weapon._description = definition.@desctiption;
			return weapon;
		}
		
		private var _damage:uint;
		public function get damage():uint{
			return this._damage;
		}
		
		private var _cost:uint;
		public function get cost():uint{
			return this._cost;
		}
		
		private var _minUserLevel:uint;
		public function get minUserLevel():uint{
			return this._minUserLevel;
		}
		
		private var _title:String;
		public function get title():String{
			return this._title;
		}
		
		private var _description:String;
		public function get description():String{
			return this._damage;
		}
		
		private var _picID:String;
		public function get picID():String{
			return this._picID;
		}
		
		public function WeaponDefinition(){
			super();
		}
	}
}
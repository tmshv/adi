package ru.gotoandstop.adi.user{
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.mvc.BaseModel;
	import ru.gotoandstop.adi.core.mvc.IModel;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * Модель пользователя соц. сети
	 * @author Timashev Roman
	 */
	public class OwnerModel extends UserModel{
		private var _money:uint;
		public function get money():uint{
			return this._money;
		}
		public function set money(value:uint):void{
			this._money = value;
			this.dispatch();
		}
		
		private var _experience:uint;
		public function get experience():uint{
			return _experience;
		}
		public function set experience(value:uint):void{
			_experience = value;
			this.dispatch();
		}
		
		private var _friends:Vector.<String>;
		public function get friends():Vector.<String>{
			return this._friends;
		}
		public function set friends(value:Vector.<String>):void{
			this._friends = value;
			this.dispatch();
		}
		
		public function getFriends():Vector.<String>{
			return this.friends.concat();
		}
		
		public function OwnerModel(context:Context){
			super(context);
			this.setName('', '');
		}
		
		public override function update():void{
			super.update();
			super.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setParams(
			experience:uint,
			level:uint,
			money:uint
		):void{
			super.lock();
			
			this.money = money;
			this.experience = experience;
			this.level = level;
			
			super.unlock();
			super.dispatch();
		}
	}
}
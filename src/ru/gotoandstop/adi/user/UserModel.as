package ru.gotoandstop.adi.user{
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.mvc.BaseModel;
	
	import flash.events.Event;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class UserModel extends BaseModel{
		private var _firstName:String;
		public function get firstName():String{
			return this._firstName;
		}
		public function set firstName(value:String):void{
			this._firstName = value;
			super.dispatch();
		}
		
		private var _lastName:String;
		public function get lastName():String{
			return this._lastName;
		}
		public function set lastName(value:String):void{
			this._lastName = value;
			super.dispatch();
		}
		
		private var _level:uint;
		public function get level():uint{
			return this._level;
		}
		public function set level(value:uint):void{
			this._level = value;
			this.dispatch();
		}
		
		public var userID:String;
		private var _charType:String;
		public function get charType():String{
			return this._charType;
		}
		public function set charType(value:String):void{
			this._charType = value;
			this.dispatch();
		}
		
		private var _userPicURL:String;
		public function get userPicURL():String{
			return this._userPicURL;
		}
		public function set userPicURL(value:String):void{
			this._userPicURL = value;
			this.dispatch();
		}
		
		private var _userBigPicURL:String;
		public function get userBigPicURL():String{
			return this._userPicURL;
		}
		public function set userBigPicURL(value:String):void{
			this._userPicURL = value;
			this.dispatch();
		}
		
		public function UserModel(context:Context){
			super(context);
			this.setName('', '');
		}
		
		public override function update():void{
			super.update();
			super.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setName(first:String, last:String):void{
			super.lock();
			this.firstName = first;
			this.lastName = last;
			super.unlock();
			super.dispatch();
		}
		
		public function getName(separator:String=' '):String{
			return this._firstName + separator + this._lastName;
		}
	}
}
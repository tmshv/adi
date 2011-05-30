package ru.gotoandstop.adi.user{
	import ru.gotoandstop.adi.core.mvc.BaseModel;
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class UserAvatarData extends BaseModel{
		private var _name:String;
		public function get name():String{
			return _name;
		}
		public function set name(value:String):void{
			_name = value;
		}
		
		private var _character:String;
		public function get character():String{
			return _character;
		}
		public function set character(value:String):void{
			_character = value;
		}
		
		private var _sex:String;
		public function get sex():String{
			return _sex;
		}
		public function set sex(value:String):void{
			_sex = value;
		}
		
		private var _eyeColor:uint;
		public function get eyeColor():uint{
			return _eyeColor;
		}
		public function set eyeColor(value:uint):void{
			_eyeColor = value;
		}
		
		private var _hairColor:uint;
		public function get hairColor():uint{
			return _hairColor;
		}
		public function set hairColor(value:uint):void{
			_hairColor = value;
		}
		
		private var _zodiak:String;
		public function get zodiak():String{
			return _zodiak;
		}
		public function set zodiak(value:String):void{
			_zodiak = value;
		}

//		private var hair:
		private var items:Vector.<AvatarItemData>;
		
		public function UserAvatarData(){
			super();
		}
		
		public function addItem(item:AvatarItemData):void{
			
		}
		
		public function removeItem(item:AvatarItemData):void{
			
		}
		
		public function get length():uint{
			return this.items.length;
		}
	}
}
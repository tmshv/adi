package ru.gotoandstop.adi.character{
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.mvc.BaseModel;
	import ru.gotoandstop.adi.core.mvc.IModel;
	
	import flash.events.EventDispatcher;
	
	/**
	 * Модель персонажа. 
	 * Хранит информацию об игровом персонаже. Владелец, имя персонажа, его характеристики
	 * @author Roman Timshev
	 */
	public class CharDefinition extends EventDispatcher implements IModel{
		public static function createFromXML(xmlDefinition:XML):CharDefinition{
			var char:CharDefinition = new CharDefinition();//context);
			char._type = xmlDefinition.@type;
			char._nick = xmlDefinition.@nick;
			char._health = xmlDefinition.@health;
			char._ownerID = xmlDefinition.@owner;
			
			char._items = new Vector.<String>();
			char._items.push(xmlDefinition.@weapon);
			char._items.push(xmlDefinition.@shoes);
			char._items.push(xmlDefinition.@pants);
			char._items.push(xmlDefinition.@outwear);
			
			return char;
		}
		
		public static function createDefault(id:String, nick:String, type:String):CharDefinition{
			var char:CharDefinition = new CharDefinition();
			char._type = type;
			char._nick = nick;
			char._health = 100;
			char._ownerID = id;
			char._items = new Vector.<String>();
			return char;
		}
		
		private var _items:Vector.<String>;
		public function get items():Vector.<String>{
			return this._items;
		}
		
		private var _type:String;
		public function get type():String{
			return this._type;
		}
		
		private var _nick:String;
		public function get nick():String{
			return this._nick;
		}
		
		private var _health:uint;
		public function get health():uint{
			return this._health;
		}
		
		private var _ownerID:String;
		public function get ownerID():String{
			return this._ownerID;
		}
		
		public function CharDefinition(){
			super();
		}
		
		public function update():void{
			
		}
		
		public override function toString():String{
			var text:String = '[<nick> char definition]';
			text = text.replace(/<nick>/, this.nick);
			return text;
		}
	}
}
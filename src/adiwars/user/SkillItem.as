package adiwars.user{
	import adiwars.core.Context;
	import adiwars.core.mvc.BaseModel;
	import adiwars.ui.GameItem;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SkillItem extends EventDispatcher{
		public static function createByXML(definition:XML, custom:XML):SkillItem{
			var item:SkillItem = new SkillItem();
			item.name = definition.@name;
			item.description = definition.text().toString();
			item.title = definition.@titl;
			item.level = custom.@lvl;
			item.image = definition.@image;
			
			item.values = new Vector.<uint>();
			var values1:String = definition.@value;
			var values2:Array = values1.split('/');
			for each(var v:String in values2) item.values.push(parseInt(v));
			
			return item;
		}
		
		public var name:String;
		public var title:String;
		public var description:String;
		
		private var _level:uint;
		public function get level():uint{
			return this._level;
		}
		public function set level(value:uint):void{
			this._level = value;
			super.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public var values:Vector.<uint>;
		public var image:String;
		
		public function SkillItem(){
			super();
		}
		
		public function getValue():uint{
			return this.values[this.level-1];
		}
	}
}
package ru.gotoandstop.adi{
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class GoodsItem{
		public static function createByXML(definition:XML):GoodsItem{
			var item:GoodsItem = new GoodsItem();
			item.configure(definition);
			return item;
		}
		
		public var cost:uint;
		public var level:uint;
		public var title:String;
		public var name:String;
		public var type:String;
		public var image:String;
		public var frame:uint;
		public var description:String;
		
		public function GoodsItem(){
			
		}
		
		public function configure(def:XML):void{
			this.cost = def.@cost;
			this.level = def.@lvl;
			this.title = def.@titl;
			this.name = def.@name;
			this.type = def.@type;
			this.image = def.@image;
			this.frame = def.@frame;
			this.description = def.text().toString();
		}
		
		public function toString():String{
			var text:String = '[goods <name>]';
			text = text.replace(/<name>/, this.name);
			return text;
		}
	}
}
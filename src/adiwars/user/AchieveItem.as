package adiwars.user{
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class AchieveItem{
		public static function createByXML(definition:XML):AchieveItem{
			var color:String = definition.@color;
			var r:uint = parseInt(color.substr(0, 2), 16);
			var g:uint = parseInt(color.substr(2, 2), 16);
			var b:uint = parseInt(color.substr(4, 2), 16);
			
			var item:AchieveItem = new AchieveItem();
			item.id = definition.@id;
			item.level = definition.@lvl;
			item.date = new Date(definition.@date);
			item.description = definition.text().toString();
			item.color = (r << 16 | g << 8 | b);
			item.image = definition.@image;
			return item;
		}
		
		public var id:String;
		public var level:uint;
		public var date:Date;
		public var description:String;
		public var color:uint;
		public var image:String;
		
		public function AchieveItem(){
			
		}
	}
}
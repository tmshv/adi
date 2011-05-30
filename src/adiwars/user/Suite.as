package adiwars.user{
	import adiwars.GoodsItem;
	
	import flash.events.Event;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Suite extends Goods{
		public function Suite(){
			super();
		}
		
		public override function add(item:GoodsItem):void{
			trace('add to suite', item)
			
			//var same_item:GoodsItem = super.getItem(item.name);
			var same_item:GoodsItem = this.getBySameType(item.name);
			if(same_item){
				super.removeItem(same_item);
				this.dispatchAboutRemoved(same_item);
			}
			
			super.add(item);
			this.dispatchAboutAdded(item);
		}
		
		private function dispatchAboutRemoved(item:GoodsItem):void{
			super.dispatchEvent(new SuiteEvent(Event.REMOVED, false, false, item));
		}
		
		private function dispatchAboutAdded(item:GoodsItem):void{
			super.dispatchEvent(new SuiteEvent(Event.ADDED, false, false, item));
		}
		
		private function getBySameType(name:String):GoodsItem{
			var type:String = this.extractTypeFromName(name);
			for each(var item:GoodsItem in super.goods){
				if(!item) continue;
				var item_type:String = this.extractTypeFromName(item.name);
				if(this.isSame(type, item_type)){
					return item;
				}
			}
			return null;
		}
		
		private function isSame(item1:String, item2:String):Boolean{
			if(item1 == '3') item1 = '4';
			if(item2 == '3') item2 = '4';
			return item1 == item2;
		}
		
		private function extractTypeFromName(name:String):String{
			var type:String = name.substr(0, 1);
			return type;
		}
	}
}
package adiwars.user{
	import adiwars.GoodsItem;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Goods extends EventDispatcher{
		public var lastAdded:GoodsItem;
		protected var goods:Object;
		
		public function isGoodies(type:String):Boolean{
			return (type=='weapon') || (type=='suite')
		}
		
		public function Goods(){
			super();
			this.goods = new Object();
		}
		
		public function addItem(def:XML):void{
			var same_item:GoodsItem = this.getItem(def.@name);
			if(same_item){
				same_item.configure(def);
			}else{
				this.add(GoodsItem.createByXML(def));
			}
		}
		
		internal function removeItem(item:GoodsItem):void{
			this.goods[item.name] = null;
		}
		
		public function add(item:GoodsItem):void{
			this.lastAdded = item;
			this.goods[item.name] = item;
		}
		
		public function getItem(name:String):GoodsItem{
			return this.goods[name] as GoodsItem;
		}
		
		public function getList():Vector.<GoodsItem>{
			var list:Vector.<GoodsItem> = new Vector.<GoodsItem>();
			for each(var item:GoodsItem in this.goods){
				list.push(item);
			}
			
			return list;
		}
	}
}
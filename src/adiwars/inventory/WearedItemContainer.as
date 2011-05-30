package adiwars.inventory{
	import adiwars.GoodsItem;
	import adiwars.ITemp;
	import adiwars.clips.GoodsInvItem;
	import adiwars.core.Context;
	import adiwars.ui.ItemContainer;
	import adiwars.user.Goods;
	import adiwars.user.SuiteEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class WearedItemContainer implements ITemp{
		private var weapon:DisplayObjectContainer;
		private var top:DisplayObjectContainer;
		private var pants:DisplayObjectContainer;
		private var boots:DisplayObjectContainer;
		
		private var model:IEventDispatcher;
		
		public function WearedItemContainer(
			suite:Goods,
			weapon:DisplayObjectContainer,
			jacket:DisplayObjectContainer,
			pants:DisplayObjectContainer,
			boots:DisplayObjectContainer
		){
			this.weapon = this.createContainer(weapon);
			this.top = this.createContainer(jacket);
			this.pants = this.createContainer(pants);
			this.boots = this.createContainer(boots);
			
			this.model = suite;
			this.model.addEventListener(Event.ADDED, this.handleSuiteAdded);
			//this.model.addEventListener(Event.REMOVED, this.handleRemoved);
			
			var list:Vector.<GoodsItem> = suite.getList();
			for each(var item:GoodsItem in list){
				if(item) this.add(item);
			}
		}
		
		public function dispose():void{
			this.model.removeEventListener(Event.ADDED, this.handleSuiteAdded);
		}
		
		private function handleSuiteAdded(event:SuiteEvent):void{
			trace('ololo is pizd')
			trace(event)
			trace(event.item)
			this.add(event.item);
		}
		
		private function createContainer(parent:DisplayObjectContainer):DisplayObjectContainer{
			var c:ItemContainer = new ItemContainer(1, 100);
			c.setLayout('horizontal', 75, new Point(75, 10), 'easeInSine');
			parent.addChild(c);
			return c;
		}
		
		private function clearContainer(container:DisplayObjectContainer):void{
			while(container.numChildren) container.removeChildAt(0);
		}
		
//		public override function addChild(child:DisplayObject):DisplayObject{
//			throw new IllegalOperationError();
//		}
		
		public function add(item:GoodsItem):void{
			var c:DisplayObjectContainer = this.getContainerForItem(item.name);
			var d:DisplayObject = this.createItem(item);
			c.addChild(d);
			
			(c as ItemContainer).next();
		}
		
		private function getContainer(type:String):DisplayObjectContainer{
			var result:DisplayObjectContainer;
			switch(type){
				default:
					result = this.weapon;
					break;
			}
			return result;
		}
		
		/**
		 * Создает вьюшку товарного айтема 
		 * @param item
		 * @return 
		 * 
		 */
		private function createItem(item:GoodsItem):GoodsInvItem{
			var clip:GoodsInvItem = new GoodsInvItem();
			clip.cacheAsBitmap = true;
			var ava:DisplayObject = Context.inst.getResourceClip(item.image);
			if(ava) clip.point.addChild(ava);
			return clip;
		}
		
		private function getContainerForItem(name:String):DisplayObjectContainer{
			var result:DisplayObjectContainer;
			var type:String = name.substr(0, 1);
			switch(type){
				case '1':
					result = this.boots;
					break;
				
				case '2':
					result = this.pants;
					break;
				
				case '3':
					result = this.top;
					break;
				
				case '4':
					result = this.top;
					break;
				
				case '5':
					result = this.weapon;
					break;
			}
			return result;
		}
	}
}
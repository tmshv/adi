package adiwars.user{
	import adiwars.GoodsItem;
	
	import flash.events.Event;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SuiteEvent extends Event{
		private var _item:GoodsItem;
		public function get item():GoodsItem{
			return this._item;
		}
		
		public function SuiteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, item:GoodsItem=null){
			super(type, bubbles, cancelable);
			this._item = item;
		}
		
		public override function clone():Event{
			return new SuiteEvent(super.type, super.bubbles, super.cancelable, this.item);
		}
	}
}
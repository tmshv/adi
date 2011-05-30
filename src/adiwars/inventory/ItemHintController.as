package adiwars.inventory{
	import adiwars.GoodsItem;
	import adiwars.ITemp;
	import adiwars.clips.GoodsInvItem;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ItemHintController implements ITemp{
		private var view:GoodsInvItem;
		private var item:GoodsItem;
		
		private var id:uint;
		
		public function ItemHintController(item:GoodsItem, view:GoodsInvItem){
			this.item = item;
			this.view = view;
			
			this.view.addEventListener(MouseEvent.MOUSE_OVER, this.handleOver);
			this.view.addEventListener(MouseEvent.MOUSE_OUT, this.handleOut);
		}
		
		public function dispose():void{
			this.view.removeEventListener(MouseEvent.MOUSE_OVER, this.handleOver);
			this.view.removeEventListener(MouseEvent.MOUSE_OUT, this.handleOut);
		}
		
		private function handleOver(event:MouseEvent):void{
			clearTimeout(this.id);
			this.id = setTimeout(this.show, 500);
		}
		
		private function handleOut(event:MouseEvent):void{
			clearTimeout(this.id);
			this.hide();
		}
		
		private function show():void{
			var coord:Point = this.view.localToGlobal(new Point(-50, 75));
			
			trace('ololo hint show', this.item)
			ItemHint.instance.show(item, coord);
		}
		
		private function hide():void{
			ItemHint.instance.hide();
		}
	}
}
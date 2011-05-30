package adiwars.skills{
	import adiwars.ITemp;
	import adiwars.user.SkillItem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class HintItemController implements ITemp{
		private var view:SkillItemView;
		private var item:SkillItem;
		
		private var id:uint;
		
		public function HintItemController(item:SkillItem, view:SkillItemView){
			this.item = item;
			this.view = view;
			
			this.view.addEventListener(MouseEvent.MOUSE_OVER, this.handleOver);
			this.view.addEventListener(MouseEvent.MOUSE_OUT, this.handleOut);
		}
		
		public function dispose():void{
			this.view.removeEventListener(MouseEvent.MOUSE_OVER, this.handleOver);
			this.view.removeEventListener(MouseEvent.MOUSE_OUT, this.handleOut);
		}
		
		private function handleRemoved(event:Event):void{
			
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
			SkillHint.instance.show(item, coord);
		}
		
		private function hide():void{
			SkillHint.instance.hide();
		}
	}
}
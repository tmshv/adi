package adiwars.ui{
	import adiwars.values.IntValue;
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class PrevNextController{
		protected var prev:InteractiveObject;
		protected var next:InteractiveObject;
		
		protected var c:IntValue;
		protected var t:IntValue;
		
		public function PrevNextController(prev:InteractiveObject, next:InteractiveObject){
			this.prev = prev;
			this.next = next;
		}
		
		public function init(current:IntValue, total:IntValue):void{
			current.addEventListener(Event.CHANGE, this.handleChange);
			total.addEventListener(Event.CHANGE, this.handleChange);
			this.c = current;
			this.t = total;
			
			current.update();
			total.update();
		}
		
		public function dispose():void{
			this.c.removeEventListener(Event.CHANGE, this.handleChange);
			this.t.removeEventListener(Event.CHANGE, this.handleChange);
		}
		
		private function handleChange(event:Event):void{
			this.update();
		}
		
		protected function update():void{
			var available_next:Boolean = (this.c.value < this.t.value);
			var available_prev:Boolean = (this.c.value > 0);
			
			if(available_next) this.unlockButton(this.next);
			else this.lockButton(this.next);
			
			if(available_prev) this.unlockButton(this.prev);
			else this.lockButton(this.prev);
		}
		
		private function lockButton(btn:InteractiveObject):void{
			const value:Number = 0.6;
			btn.filters = [new ColorMatrixFilter([
				0, 0, value, 0, 0,
				0, 0, value, 0, 0,
				0, 0, value, 0, 0,
				0, 0, value, .65, 0
			])];
			
			btn.mouseEnabled = false;
			Tweener.addTween(btn, {alpha:0.3, time:0.3, transition:'easeInSine'});
		}
		
		private function unlockButton(btn:InteractiveObject):void{
			btn.filters = [];
			btn.mouseEnabled = true;
			Tweener.addTween(btn, {alpha:1, time:0.3, transition:'easeInSine'});
		}
	}
}
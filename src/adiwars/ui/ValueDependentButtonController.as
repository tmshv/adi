package adiwars.ui{
	import adiwars.values.IntValue2;
	
	import caurina.transitions.Tweener;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;

	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ValueDependentButtonController{
		protected var button:InteractiveObject;
		protected var c:IntValue2;
		
		public function ValueDependentButtonController(value:IntValue2, button:InteractiveObject){
			this.button = button;
			this.c = value;
			
			this.c.addEventListener(Event.CHANGE, this.handleChange);
			this.update();
		}
		
		public function dispose():void{
			this.c.removeEventListener(Event.CHANGE, this.handleChange);
		}
		
		private function handleChange(event:Event):void{
			this.update();
		}
		
		protected function update():void{
			var available:Boolean = Boolean(this.c.value);
			
			if(available) this.unlockButton(this.button);
			else this.lockButton(this.button);
		}
		
		private function lockButton(btn:InteractiveObject):void{
			const value:Number = 0.6;
//			btn.filters = [new ColorMatrixFilter([
//				0, 0, value, 0, 0,
//				0, 0, value, 0, 0,
//				0, 0, value, 0, 0,
//				0, 0, value, .65, 0
//			])];
			
			btn.mouseEnabled = false;
			Tweener.addTween(btn, {alpha:0.3, time:0.3, transition:'easeInSine'});
		}
		
		private function unlockButton(btn:InteractiveObject):void{
//			btn.filters = [];
			btn.mouseEnabled = true;
			Tweener.addTween(btn, {alpha:1, time:0.3, transition:'easeInSine'});
		}
	}
}
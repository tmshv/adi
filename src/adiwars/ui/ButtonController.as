package adiwars.ui{
	import adiwars.ITemp;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ButtonController implements ITemp{
		private var target:IEventDispatcher;
		private var button:DisplayObject;
		
		public function ButtonController(target:IEventDispatcher, button:DisplayObject){
			FilterShortcuts.init();
			
			this.target = target;
			this.button = button;
			
			this.target.addEventListener(MouseEvent.MOUSE_OVER, this.handleMouseOver);
			this.target.addEventListener(MouseEvent.MOUSE_OUT, this.handleMouseOut);
		}
		
		public function dispose():void{
			this.target.removeEventListener(MouseEvent.MOUSE_OVER, this.handleMouseOver);
			this.target.removeEventListener(MouseEvent.MOUSE_OUT, this.handleMouseOut);
		}
		
		private function handleMouseOver(event:MouseEvent):void{
			this.glow(this.button, 1);
		}
		
		private function handleMouseOut(event:MouseEvent):void{
			this.glow(this.button, 0);
		}
		
//		private function handleMouseOver(event:MouseEvent):void{
//			
//		}
		
		private function glow(button:DisplayObject, amount:Number=0):void{
			Tweener.removeTweens(button);
			Tweener.addTween(button, {_Glow_blurX:amount * 15, _Glow_blurY:amount * 15, _Glow_strength:amount * 5, time:.5});
		}
	}
}
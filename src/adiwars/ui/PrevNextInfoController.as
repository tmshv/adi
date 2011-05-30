package adiwars.ui{
	import adiwars.values.IntValue2;
	
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
	public class PrevNextInfoController extends PrevNextController{
		private var info:TextField;
		
		public function PrevNextInfoController(prev:InteractiveObject, next:InteractiveObject, info:TextField){
			super(prev, next);
			this.info = info;
		}
		
		protected override function update():void{
			this.updateText();
			super.update();
		}
		
		private function updateText():void{
			this.info.text = (super.c.value+1) + '/' + (super.t.value+1);
		}
	}
}
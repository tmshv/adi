package adiwars.informers{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	import adiwars.values.IntValue2;
	import adiwars.ITemp;
	
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ValueInformer implements ITemp{
		private var line:MovieClip;
		private var field:TextField;
		private var model:IntValue2;
		
		public function ValueInformer(model:IntValue2, line:MovieClip, field:TextField){
			super();
			
			this.line = line;
			this.field = field;
			this.model = model;
			
			this.model.addEventListener(Event.CHANGE, this.handleChange);
			this.update(this.model.value, this.model.getRatio(true));
		}
		
		public function dispose():void{
			this.line.stop();
			this.model.removeEventListener(Event.CHANGE, this.handleChange);
		}
		
		private function update(value:uint, ratio:Number):void{
			var frame:uint = this.line.totalFrames * ratio;
			this.line.gotoAndStop(frame);
			if(this.field) this.field.text = value.toString();
		}
		
		private function handleChange(event:Event):void{
			const model:IntValue2 = event.target as IntValue2;
			this.update(model.value, model.getRatio(true));
		}
	}
}
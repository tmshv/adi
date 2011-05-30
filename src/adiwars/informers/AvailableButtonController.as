package adiwars.informers{
	import adiwars.values.BooleanValue;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import adiwars.ITemp;

	/**
	 * Кнопочный контроллер. Отключает кнопку в зависимости от знания <code>target</code>
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class AvailableButtonController implements ITemp{
		private var clip:InteractiveObject;
		private var target:BooleanValue;
		
		public function AvailableButtonController(clip:InteractiveObject, target:BooleanValue){
			this.clip = clip;
			this.target = target;
			this.target.addEventListener(Event.CHANGE, this.handleChange);
			this.update(target.value);
		}
		
		public function dispose():void{
			this.target.removeEventListener(Event.CHANGE, this.handleChange);
		}
		
		private function handleChange(event:Event):void{
			this.update(this.target.value);
		}
		
		private function update(value:Boolean):void{
			if(value){
				this.displayAvailable();
			}else{
				this.displayUnavailable();
			}
		}
		
		private function displayAvailable():void{
			this.clip.filters = [];
			this.clip.mouseEnabled = true;
		}
		
		private function displayUnavailable():void{
			this.clip.filters = [this.getGrayColorFilter()];
			this.clip.mouseEnabled = false;
		}
		
		private function getGrayColorFilter():ColorMatrixFilter{
			const value:Number = 0.6;
			return new ColorMatrixFilter([
				0, 0, value, 0, 0,
				0, 0, value, 0, 0,
				0, 0, value, 0, 0,
				0, 0, value, .65, 0
			]);
		}
	}
}
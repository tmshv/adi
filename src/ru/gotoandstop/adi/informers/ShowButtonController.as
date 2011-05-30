package ru.gotoandstop.adi.informers{
	import ru.gotoandstop.adi.values.BooleanValue;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import ru.gotoandstop.adi.ITemp;
	
	/**
	 * Кнопочный контроллер. Отключает кнопку в зависимости от знания <code>target</code>
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ShowButtonController implements ITemp{
		private var clip:InteractiveObject;
		private var target:BooleanValue;
		
		public function ShowButtonController(clip:InteractiveObject, target:BooleanValue){
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
			this.clip.visible = true;
		}
		
		private function displayUnavailable():void{
			this.clip.visible = false;
		}
	}
}
package ru.gotoandstop.adi.informers{
	import flash.events.Event;
	import flash.text.TextField;
	import ru.gotoandstop.adi.values.IntValue2;
	import ru.gotoandstop.adi.ITemp;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class AvailablePointsInformer implements ITemp{
		private var field:TextField;
		private var model:IntValue2;
		
		public function AvailablePointsInformer(model:IntValue2, field:TextField){
			this.field = field;
			this.model = model;
			
			this.model.addEventListener(Event.CHANGE, this.handleChange);
			this.update(this.model.value);
		}
		
		public function dispose():void{
			this.model.removeEventListener(Event.CHANGE, this.handleChange);
		}
		
		private function update(value:uint):void{
			this.field.text = value.toString();
		}
		
		private function handleChange(event:Event):void{
			const model:IntValue2 = event.target as IntValue2;
			this.update(model.value);
		}
	}
}
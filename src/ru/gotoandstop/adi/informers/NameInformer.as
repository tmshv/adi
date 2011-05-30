package ru.gotoandstop.adi.informers{
	import flash.events.Event;
	import flash.text.TextField;
	import ru.gotoandstop.adi.values.StringValue;
	import ru.gotoandstop.adi.ITemp;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class NameInformer implements ITemp{
		private var field:TextField;
		private var model:StringValue;
		
		public function NameInformer(model:StringValue, field:TextField){
			this.field = field;
			this.model = model;
			
			this.model.addEventListener(Event.CHANGE, this.handleChange);
			this.update(this.model.value);
		}
		
		public function dispose():void{
			this.model.removeEventListener(Event.CHANGE, this.handleChange);
		}
		
		private function update(value:String):void{
			this.field.text = value;
		}
		
		private function handleChange(event:Event):void{
			const model:StringValue = event.target as StringValue;
			this.update(model.value);
		}
	}
}
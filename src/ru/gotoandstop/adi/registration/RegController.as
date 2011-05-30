package ru.gotoandstop.adi.registration{
	import ru.gotoandstop.adi.command.Invoker;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.mvc.BaseController;
	import ru.gotoandstop.adi.values.StringValue;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class RegController extends BaseController{
		private var _clip:Registration;
		public function get clip():Registration{
			return this._clip;
		}
		
		public var nick:StringValue;
		public var type:StringValue;
		private var confirm:Invoker;
		
		public function RegController(context:Context, t:StringValue, n:StringValue, confirm:Invoker){
			super(null, context);
			this.nick = n;
			this.type = t;
			this.confirm = confirm;
			this.init();
		}
		
		private function init():void{
			this._clip = new Registration();
			this.clip.confirmButton.addEventListener(MouseEvent.CLICK, this.handleConfirmButtonClick);
			
			var name:String = super.context.owner.model.getName();
			this.clip.setName(name.length > 1 ? name : 'Джедай');
		}
		
		private function handleConfirmButtonClick(event:MouseEvent):void{
			this.clip.confirmButton.removeEventListener(MouseEvent.CLICK, this.handleConfirmButtonClick);
			
			this.nick.value = this.clip.getTypedNick();
			this.type.value = this.clip.getSelectedChar();
			this.confirm.executeCommand();
		}
	}
}
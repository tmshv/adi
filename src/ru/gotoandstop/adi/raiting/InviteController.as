package ru.gotoandstop.adi.raiting{
	import ru.gotoandstop.adi.ITemp;
	import ru.gotoandstop.adi.command.Invoker;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class InviteController implements ITemp{
		private var button:InteractiveObject;
		private var command:Invoker;
		
		public function InviteController(button:InteractiveObject, command:Invoker){
			this.button = button;
			this.command = command;
			
			this.button.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemoved);
			this.button.addEventListener(MouseEvent.CLICK, this.handleClick);
		}
		
		public function dispose():void{
			this.button.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemoved);
			this.button.removeEventListener(MouseEvent.CLICK, this.handleClick);
		}
		
		private function handleRemoved(event:Event):void{
			this.dispose();
		}
		
		private function handleClick(event:MouseEvent):void{
			this.command.executeCommand();
		}
	}
}
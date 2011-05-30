package ru.gotoandstop.adi.dialogs{
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.mvc.BaseController;
	import ru.gotoandstop.adi.ui.UICommandEvent;
	import ru.gotoandstop.adi.ui.UIElement;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	[Event(name="command", type="ru.gotoandstop.adi.ui.UICommandEvent")]

	/**
	 * Базовый класс-контроллер диалогового окна
	 * @author Timashev Roman
	 */
	public class Dialog extends UIElement implements IDialog{
		public function get clip():DisplayObject{
			return null;
		}
		protected var manager:DialogManager;
		
		public function Dialog(context:Context){
			super(context.dialogManager.container, context);
			this.manager = context.dialogManager;
		}
		
		protected function add():void{
			//this.manager.add(this);
		}
		
		public function close():void{
			super.dispatchEvent(UICommandEvent.command('close'));
		}
	}
}
package ru.gotoandstop.adi.dialogs{
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.mvc.BaseController;
	import ru.gotoandstop.adi.core.mvc.IModel;
	
	import flash.display.DisplayObjectContainer;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class DialogManager extends BaseController implements IModel{
		private var dialogs:DialogsContainer;
		public override function get container():DisplayObjectContainer{
			return this.dialogs;
		}
		
		public function DialogManager(container:DisplayObjectContainer, context:Context){
			super(container, context);
			this.init();
		}
		
		private function init():void{
			this.dialogs = new DialogsContainer(this, super.context);
			super.container.addChild(this.dialogs);
		}
		
		public function add(dialog:IDialog):IDialog{
			return dialog;
		}
		
		public function remove(dialog:IDialog):IDialog{
			return dialog;
		}
		
		public function update():void{
			
		}
	}
}
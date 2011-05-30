package ru.gotoandstop.adi.dialogs{
	import ru.gotoandstop.adi.command.ICommand;
	
	import caurina.transitions.Tweener;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class CloseDialogCommand implements ICommand{
		private var dialog:Dialog;
		public function CloseDialogCommand(dialog:Dialog){
			this.dialog = dialog;
		}
		
		public function execute():void{
			this.dialog.close();
			Tweener.addTween(this.dialog.clip, {time:0.4, x:-700, rotation:0, transition:'easeInQuad', onComplete: this.onHideComplete});
		}
		
		private function onHideComplete():void{
			this.dialog.container.removeChild(this.dialog.clip);
		}
	}
}
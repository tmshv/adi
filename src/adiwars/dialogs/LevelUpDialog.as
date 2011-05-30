package adiwars.dialogs{
	import adiwars.clips.LevelUpClip;
	import adiwars.command.ICommand;
	import adiwars.core.Context;
	import adiwars.menu.LevelUpController;
	import adiwars.ui.UICommandEvent;
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class LevelUpDialog extends Dialog{
		private var view:Sprite;
		private var controller:LevelUpController;
		
		public override function get clip():DisplayObject{
			return this.view;
		}
		
		public function LevelUpDialog(context:Context){
			super(context);
			
			var close:ICommand = new CloseDialogCommand(this);
			
			this.controller = new LevelUpController(super.context, close);
			
			this.view = this.controller.view;
			this.view.x -= 700;
			
			super.container.addChild(this.view);
			Tweener.addTween(this.view, {time:0.8, x:0, transition:'easeOutElastic'});
		}
		
		public override function close():void{
			super.close();
			this.controller.dispose();
		}
	}
}
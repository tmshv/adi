package adiwars.raiting{
	import adiwars.command.ICommand;
	import adiwars.core.Context;
	import adiwars.dialogs.Dialog;
	import adiwars.dialogs.InputDialog;
	import adiwars.states.MenuState;
	import adiwars.states.Screen;
	import adiwars.ui.UICommandEvent;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ShowAchievementsDialogCommand implements ICommand{
		private var userID:String;
		private var state:MenuState;
		
		public function ShowAchievementsDialogCommand(userID:String, menu:MenuState){
			this.userID = userID;
			this.state = menu;
		}
		
		public function execute():void{
			this.state.showEnemyDialog(this.userID);
		}
	}
}
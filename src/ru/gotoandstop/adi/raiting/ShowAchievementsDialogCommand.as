package ru.gotoandstop.adi.raiting{
	import ru.gotoandstop.adi.command.ICommand;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.dialogs.Dialog;
	import ru.gotoandstop.adi.dialogs.InputDialog;
	import ru.gotoandstop.adi.states.MenuState;
	import ru.gotoandstop.adi.states.Screen;
	import ru.gotoandstop.adi.ui.UICommandEvent;
	
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
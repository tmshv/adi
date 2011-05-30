package ru.gotoandstop.adi.raiting{
	import ru.gotoandstop.adi.command.ICommand;
	import ru.gotoandstop.adi.states.MenuState;
	import ru.gotoandstop.adi.states.Screen;
	import ru.gotoandstop.adi.user.UserModel;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class AttackUserCommand implements ICommand{
		private var item:RaitingItem;
		private var state:Screen;
		private var model:UserModel;
		
		public function AttackUserCommand(item:RaitingItem, battle:Screen, model:UserModel){
			this.item = item;
			this.state = battle;
			this.model = model;
		}
		
		public function execute():void{
//			this.state.showEnemyDialog(this.userID);
//			
//			var def:XML = new XML(event.params['opponent']);
//			if(def){
//				var o:UserModel = super.context.opponent;
//				o.setName(def.@firstName, def.@lastName);
//				o.userID = def.@id;
//				o.level = def.@lvl;
//				o.userPicURL = def.@userpic;
//				
//				trace('menu state oponn', def.toXMLString())
//				
//				this.switchToArena();
//			}
			
			this.model.setName(this.item.firstName, this.item.lastName);
			this.model.userID = this.item.userID;
			this.model.level = this.item.level;
			this.model.userPicURL = this.item.picURL;
			
			this.state.activate();
		}
	}
}
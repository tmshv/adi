package adiwars.states{
	import adiwars.character.Char;
	import adiwars.clips.ArenaUnavailableDialogContent;
	import adiwars.core.Context;
	import adiwars.dialogs.Dialog;
	import adiwars.dialogs.EnemyDialog;
	import adiwars.dialogs.InputDialog;
	import adiwars.dialogs.InventoryDialog;
	import adiwars.dialogs.LevelUpDialog;
	import adiwars.dialogs.ModalDialog;
	import adiwars.dialogs.SelectOpponentDialog;
	import adiwars.dialogs.ShopDialog;
	import adiwars.menu.ArenaUnavailableContent;
	import adiwars.menu.GetEnemyMatch;
	import adiwars.ui.UICommandEvent;
	import adiwars.user.UserModel;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import remote.ISocialAPI;
	import remote.RemoteEvent;
	import remote.RemoteRequest;
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class MenuState extends Screen{
		private var showLevelUpDialogWhenStart:Boolean;
		
		private var layout:MenuView;
		internal override function getLayout():DisplayObject{
			return this.layout;
		}
		
		public function MenuState(context:Context){
			super(null, context, ApplicationStateKey.MENU);
		}
		
		internal override function init():void{
			this.layout = new MenuView(context);
		}
		
		public override function enable():void{
			if(this.showLevelUpDialogWhenStart){
				this.showLevelUpDialog();
			}
			
			this.layout.raiting.enable();
			super.manager.addLayout(this.layout);
			this.layout.addEventListener(UICommandEvent.COMMAND, this.handleUICommand);
			super.enable();
		}
		
		public override function disable():void{
			this.layout.raiting.disable();
			if(super.manager && this.layout) super.manager.removeLayout(this.layout);
			if(this.layout) this.layout.removeEventListener(UICommandEvent.COMMAND, this.handleUICommand);
			super.disable();
		}
		
		public override function send(...params):void{
			this.showLevelUpDialogWhenStart = params[0] == true;
		}
		
		private function handleUICommand(event:UICommandEvent):void{
			trace(event.type, event.command)
			switch(event.command){
				case 'arena':
					this.moveToArena();
					break;
				
				case 'bank':
					this.showBankDialog();
					break;
				
				case 'shop':
					this.showShopDialog();
					break;
				
				case 'bag':
					this.showInventoryDialog();
					break;
			}
		}
		
		private function switchToArena():void{
			super.manager.activateState(ApplicationStateKey.BATTLE);
		}
		
		private function moveToArena():void{
			this.layout.lock();
			
			var request:GetEnemyMatch = new GetEnemyMatch();
			request.addEventListener(Event.COMPLETE, this.handleMatchComplete);
			request.addEventListener('error', this.handleMatchError);
			request.execute();
		}
		
		private function handleMatchComplete(event:Event):void{
			const request:GetEnemyMatch = event.target as GetEnemyMatch;
			request.removeEventListener(Event.COMPLETE, this.handleMatchComplete);
			request.removeEventListener('error', this.handleMatchError);
		
			this.layout.unlock();
			
			this.showSelectOpponentDialog(request.enemies);
		}
		
		private function handleMatchError(event:Event):void{
			const request:GetEnemyMatch = event.target as GetEnemyMatch;
			request.removeEventListener(Event.COMPLETE, this.handleMatchComplete);
			request.removeEventListener('error', this.handleMatchError);
			
			this.layout.unlock();
			
			this.showArenaClosedDialog(request.timeToOpen);
		}
		
		//-------------------------
		//BANK DIALOG
		
		private function showBankDialog():void{
			this.layout.lock();
			var dialog:Dialog = super.addDialog(new InputDialog('Введите промо-код', super.context));
			this.createListenersForDialog(dialog, this.handleDialogUICommand);
		}
		
		private function createListenersForDialog(dialog:Dialog, handler:Function):void{
			dialog.addEventListener(UICommandEvent.COMMAND, handler);
		}
		
		private function destroyListenersFromDialog(dialog:Dialog, handler:Function):void{
			dialog.removeEventListener(UICommandEvent.COMMAND, handler);
		}
		
		private function handleDialogUICommand(event:UICommandEvent):void{
			trace('menu state handle ', event)
			
			var dialog:Dialog = event.target as Dialog;
			this.destroyListenersFromDialog(dialog, this.handleDialogUICommand);
			switch(event.command){
				case 'confirm':
					dialog.close();
					this.layout.unlock();
					break;
				
				case 'close':
					dialog.close();
					this.layout.unlock();
					break;
			}
		}
		
		//---------------------
		//SHOP DIALOG
		
		private function showShopDialog():void{
			this.layout.lock();
			var dialog:Dialog = super.addDialog(new ShopDialog(super.context));
			this.createListenersForDialog(dialog, this.handleDialogUICommand);
		}
		
		//---------------------
		//INVENTORY DIALOG
		
		private function showInventoryDialog():void{
			this.layout.lock();
			var dialog:Dialog = super.addDialog(new InventoryDialog(super.context));
			this.createListenersForDialog(dialog, this.handleDialogUICommand);
		}
		
		public function showEnemyDialog(userID:String):void{
			this.layout.lock();
			var dialog:Dialog = new EnemyDialog(userID, this.context);
			this.createListenersForDialog(dialog, this.handleDialogUICommand);
			super.addDialog(dialog);
		}

		
		//---------------------
		//SELECT DIALOG
		
		private function showSelectOpponentDialog(list:XMLList):void{
			this.layout.lock();
			var dialog:Dialog = super.addDialog(new SelectOpponentDialog(super.context, list));
			this.createListenersForDialog(dialog, this.handleSelectOpponentDialogUICommand);
		}
		
		private function showArenaClosedDialog(time:uint):void{
			this.layout.lock();
			var dialog:Dialog = super.addDialog(new ModalDialog(super.context, new ArenaUnavailableContent(time), 'Арена закрыта'));
			this.createListenersForDialog(dialog, this.handleDialogUICommand);
		}
		
		private function handleSelectOpponentDialogUICommand(event:UICommandEvent):void{
			var dialog:Dialog = event.target as Dialog;
			this.destroyListenersFromDialog(dialog, this.handleSelectOpponentDialogUICommand);
			switch(event.command){
				case 'confirm':
					dialog.close();
					var def:XML = new XML(event.params['opponent']);
					if(def){
						var o:UserModel = super.context.opponent;
						o.setName(def.@firstName, def.@lastName);
						o.userID = def.@id;
						o.level = def.@lvl;
						o.userPicURL = def.@userpic;
						
						trace('menu state oponn', def.toXMLString())
						
						this.switchToArena();
					}
					this.layout.unlock();
					break;
				
				case 'close':
					dialog.close();
					this.layout.unlock();
					break;
			}
		}
		
		private function showLevelUpDialog():void{
			this.showLevelUpDialogWhenStart = false;
			//this.layout.lock();
			var dialog:Dialog = super.addDialog(new LevelUpDialog(super.context));
			this.createListenersForDialog(dialog, this.handleDialogUICommand);
		}
	}
}
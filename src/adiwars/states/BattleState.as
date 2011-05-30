package adiwars.states{
	import adiawars.clips.LeiaClip;
	
	import adiwars.GoodsItem;
	import adiwars.ITemp;
	import adiwars.battle.BattleAward;
	import adiwars.battle.BattleBubbleEmmiter;
	import adiwars.battle.BattleDefinition;
	import adiwars.battle.BattleStateView;
	import adiwars.battle.CritEmmiter;
	import adiwars.battle.Fighter;
	import adiwars.battle.Timeline;
	import adiwars.character.BattleCharModel;
	import adiwars.character.Char;
	import adiwars.character.CharAction;
	import adiwars.character.CharDefinition;
	import adiwars.character.CharType;
	import adiwars.character.events.CharEvent;
	import adiwars.clips.BattleBackground;
	import adiwars.clips.BattleUserInfo;
	import adiwars.clips.ChewbaccaClip;
	import adiwars.clips.LukClip;
	import adiwars.clips.VaderClip;
	import adiwars.core.Context;
	import adiwars.dialogs.Dialog;
	import adiwars.dialogs.LoseDialog;
	import adiwars.dialogs.WinnerDialog;
	import adiwars.informers.BattleInformer;
	import adiwars.ui.UICommandEvent;
	import adiwars.user.Goods;
	import adiwars.user.UserModel;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import remote.RemoteEvent;
	import remote.RemoteRequest;
	
	import ru.gotoandstop.math.Calculate;
	
	/**
	 * 
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class BattleState extends Screen{
		private var layout:BattleStateView;
		internal override function getLayout():DisplayObject{
			return this.layout;
		}
		
		private var definition:BattleDefinition;
		
		private var timeline:Timeline;
		//private var suite:Goods;
		
		private var user:Fighter;
		private var opponent:Fighter;
		
		private var temps:Vector.<ITemp>;
		
		/**
		 * При создании рандомно выбирается фонå
		 * @param container
		 * @param context
		 * 
		 */
		public function BattleState(context:Context){
			super(null, context, ApplicationStateKey.BATTLE);
		}
		
		internal override function init():void{
			var o:UserModel = super.context.opponent;
			
			this.layout = new BattleStateView();
			Fighter.clipContainer = this.layout.charsContainer;
		}
		
		public override function enable():void{
			super.manager.addLayout(this.layout);
			
			this.temps = new Vector.<ITemp>();
			
			this.layout.clear();
			this.layout.refreshBackground();
			
			this.getBattleResult();
			
			//this.layout.addEventListener(UICommandEvent.COMMAND, this.handleUICommand);
			super.enable();
		}
		
		public override function disable():void{
			if(super.manager && this.layout) super.manager.removeLayout(this.layout);
			//if(this.layout) this.layout.removeEventListener(UICommandEvent.COMMAND, this.handleUICommand);
			
			for each(var temp:ITemp in this.temps){
				temp.dispose();
			}
			this.temps = null;
			
			super.disable();
		}
		
		private function buildBattle():void{
			this.timeline = new Timeline();
			this.timeline.userID = super.context.owner.model.userID;
			this.timeline.opponentID = super.context.opponent.userID;
			this.timeline.addEventListener(Event.COMPLETE, this.handleTimelineComplete);
			
			//this.suite = super.context.owner.suite;
			
			var chars_definition:Vector.<CharDefinition> = this.definition.getChars();
			var user_def:CharDefinition = chars_definition[0];
			var opponent_def:CharDefinition = chars_definition[1];
			
			var user_suite:Goods = this.createGoodsListByItemsName(user_def.items);
			var opponent_suite:Goods = this.createGoodsListByItemsName(opponent_def.items);
			
			this.user = new Fighter(user_def, user_suite.getList(), new Point(150, 0), new Point(1, 1));
			this.opponent = new Fighter(opponent_def, opponent_suite.getList(), new Point(550, 0), new Point(-1, 1));
			
			this.temps.push(new BattleBubbleEmmiter(this.user.char, this.layout.userEmmiter));
			this.temps.push(new BattleBubbleEmmiter(this.opponent.char, this.layout.enemyEmmiter));
			
			this.temps.push(new CritEmmiter(this.user.char, this.layout.userEmmiter));
			this.temps.push(new CritEmmiter(this.opponent.char, this.layout.enemyEmmiter));
		}
		
		private function createGoodsListByItemsName(names:Vector.<String>):Goods{
			var lib:Context = super.context;//.getGoodsItem(
			var list:Goods = new Goods();
			for each(var name:String in names){
				list.add(lib.getGoodsItem(name));
			}
			return list;
		}
		
		private function startBattle():void{
			var chars:Vector.<Char> = new Vector.<Char>();
			chars.push(this.user.char);
			chars.push(this.opponent.char);
			this.timeline.play(this.definition, chars);
		}
		
		private function handleTimelineComplete(event:Event):void{
			trace('степы закончились')
			this.presentAward();
		}
		
		private function presentAward():void{
			var award:BattleAward = this.definition.award;
			
			trace('presenting', award.experience)
			trace(award.winner, super.context.owner.model.userID)
			
			if(award.winner == super.context.owner.model.userID){
				this.showResultDialod(new WinnerDialog(definition.award.money, definition.award.experienceAdded, super.context));
			}else{
				this.showResultDialod(new LoseDialog(definition.award.money, definition.award.experienceAdded, super.context));
			}
			
			//super.context.owner.addExp(award.experience);
			super.context.owner.model.experience = award.experience;
			super.context.owner.addMoney(award.money);
			
			if(award.levelUp){
				super.context.owner.model.level = award.level;
				super.context.owner.paramsPoints.value = award.paramsPoints;
				super.context.owner.skillPoints.value = award.skillPoints;
			}
		}
		
		private function showResultDialod(dialog:Dialog):void{
			dialog.addEventListener(UICommandEvent.COMMAND, this.handleDialogUICommand);
		}
		
		private function handleDialogUICommand(event:UICommandEvent):void{
			const dialog:Dialog = event.target as Dialog;
			
			switch(event.command){
				case 'confirm':
					dialog.removeEventListener(UICommandEvent.COMMAND, this.handleDialogUICommand);
					dialog.close();
					this.switchToMenu();
					break;
			}
		}
		
		private function switchToMenu():void{
			var state:Screen = super.manager.getState(ApplicationStateKey.MENU);
			var level_up:Boolean = this.definition.award.levelUp;
			state.send(level_up);
			state.activate();
		}
		
		private function getBattleResult():void{
			var battle_result_request:RemoteRequest = this.createBattleResult();
			battle_result_request.getBattleResult(super.context.opponent.userID);
		}
		
		private function createBattleResult():RemoteRequest{
			var request:RemoteRequest = new RemoteRequest();
			request.addEventListener(RemoteEvent.COMPLETE, this.handleBattleResult);
			request.addEventListener(RemoteEvent.ERROR, this.handleBattleResultError);
			return request;
		}
		
		private function destroyBattleResult(request:RemoteRequest):void{
			request.removeEventListener(RemoteEvent.COMPLETE, this.handleBattleResult);
			request.removeEventListener(RemoteEvent.ERROR, this.handleBattleResultError);
		}
		
		private function handleBattleResult(event:RemoteEvent):void{
			trace(event.response.toXMLString());
			
			this.definition = BattleDefinition.createByXML(event.response);
			
			this.buildBattle();
			this.layout.informer.init(super.context.owner.model, super.context.opponent);
			this.layout.informer.subscribe(this.user.char.model, this.opponent.char.model);
			this.startBattle();
			
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyBattleResult(request);
		}
		
		private function handleBattleResultError(event:RemoteEvent):void{
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyBattleResult(request);
			
			setTimeout(this.getBattleResult, 5000);
		}
	}
}
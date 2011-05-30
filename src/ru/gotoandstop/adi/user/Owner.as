package ru.gotoandstop.adi.user{
	import ru.gotoandstop.adi.GoodsItem;
	import ru.gotoandstop.adi.character.CharParams;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.IContextDependent;
	import ru.gotoandstop.adi.core.mvc.BaseController;
	import ru.gotoandstop.adi.values.IntValue;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	import ru.gotoandstop.adi.remote.RemoteEvent;
	import ru.gotoandstop.adi.remote.RemoteRequest;
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class Owner extends EventDispatcher implements IContextDependent{
		private var _model:OwnerModel;
		public function get model():OwnerModel{
			return this._model;
		}
		
		private var _context:Context;
		public function get context():Context{
			return this._context;
		}
		
		private var _achievements:Achievements;
		public function get achievements():Achievements{
			return this._achievements;
		}
		
		private var _skills:Skills;
		public function get skills():Skills{
			return this._skills;
		}
		
		private var _goodies:Vector.<String>;
		public function hasGoods(name:String):Boolean{
			for each(var item:String in this._goodies){
				if(item == name) return true;
			}
			return false;
		}
		public function getGoodiesList():Vector.<String>{
			return this._goodies.concat();
		}
		
		public function refreshGoods(currentNamesList:Vector.<String>):void{
			this._goodies = currentNamesList;
		}
		
		private var _suite:Goods;
		public function get suite():Goods{
			return this._suite;
		}
		
		private var _skillPoints:IntValue;
		public function get skillPoints():IntValue{
			return this._skillPoints;
		}
		
		private var _paramsPoints:IntValue;
		public function get paramsPoints():IntValue{
			return this._paramsPoints;
		}
		
		private var _charParams:CharParams;
		public function get char():CharParams{
			return this._charParams;
		}
		
		public function Owner(id:String, context:Context){
			super();
			this._context = context;
			this._paramsPoints = new IntValue();
			this._skillPoints = new IntValue();
			this._model = new OwnerModel(context);
			this._model.userID = id;
			this._charParams = new CharParams();
			this._achievements = new Achievements();
			this._skills = new Skills();
			
			this._suite = new Suite();
			
			this.refreshGoods(new Vector.<String>());
		}
		
		public function wearUp(item:GoodsItem):void{
			this.suite.add(item);
		}
		
		public function update():void{
			this.updateUserInfo();
			//this.updateFriends();
			this.updateAchievements();
			this.updateSkills();
		}
		
		public function addMoney(value:uint):void{
			this.model.money += value;
		}
		
		public function addExp(value:uint):void{
			this.model.experience += value;
		}
		
		public function updateFriends():void{
			var request:RemoteRequest = new RemoteRequest();
			request.addEventListener(RemoteEvent.COMPLETE, this.handleFriendsComplete);
			request.addEventListener(RemoteEvent.ERROR, this.handleFriendsError);
			request.getUserFriends();
		}
		
		private function handleFriendsComplete(event:RemoteEvent):void{
			var raw:Array = event.response.text().toString().split(',');
			var list:Vector.<String> = new Vector.<String>();
			for each(var raw_item:String in raw) list.push(raw_item);
			
			this.model.friends = list;
		}
		
		private function handleFriendsError(event:RemoteEvent):void{
			trace(event.response.toXMLString())
		}
		
		public function updateAchievements():void{
			var request:RemoteRequest = new RemoteRequest();
			request.addEventListener(RemoteEvent.COMPLETE, this.handleAchievementsComplete);
			request.addEventListener(RemoteEvent.ERROR, this.handleAchievementsError);
			request.getAchievements();
		}
		
		private function handleAchievementsComplete(event:RemoteEvent):void{
			this._achievements.clear();
			
			var items:XMLList = event.response..item;
			for each(var item:XML in items){
				this._achievements.add(AchieveItem.createByXML(item));
			}
		}
		
		private function handleAchievementsError(event:RemoteEvent):void{
			trace(event.response.toXMLString());
		}
		
		public function updateSkills():void{
			var request:RemoteRequest = new RemoteRequest();
			request.addEventListener(RemoteEvent.COMPLETE, this.handleSkillsComplete);
			request.addEventListener(RemoteEvent.ERROR, this.handleSkillsError);
			request.getSkills();
		}
		
		private function handleSkillsComplete(event:RemoteEvent):void{
			//this._skills.clear();
			
			var skills:XMLList = this.context.configXML..item.(@type=='skill');
			
			var items:XMLList = event.response..item;
			for each(var item:XML in items){
				var n:String = item.@name;
				var defs:XMLList = skills.(@name==n);
				var def:XML = defs[0];
				
				this._skills.add(SkillItem.createByXML(def, item));
			}
		}
		
		private function handleSkillsError(event:RemoteEvent):void{
			trace(event.response.toXMLString())
		}
		
		/**
		 * Парсит результат запроса "info" и устанавливает новые значения модели 
		 * @param xml 
		 * 
		 */
		public function parseRemoteRequest(xml:XML):void{
			//trace('user info parsing', xml.toXMLString())
			
			const char:XML = xml..char[0];
			this.char.strength = char.@strength;
			this.char.agility = char.@agility;
			this.char.accuracy = char.@accuracy;
			this.char.health = char.@health;
			
			var weared_items_raw:String = char.@equipment;
			var weared_items_list:Array = weared_items_raw.split(',');
			for each(var str:String in weared_items_list){
				var item:GoodsItem = this.context.getGoodsItem(str);
				this.suite.add(item);
			}
			
			this._skillPoints.value = xml.@skillpoints;
			this._paramsPoints.value = xml.@parampoints;
			
			this.model.setParams(xml.@experience, xml.@level, xml.@money);
			this.model.charType = xml.@char;
		}
		
		public function updateUserInfo():void{
			var request:RemoteRequest = new RemoteRequest();
			request.addEventListener(RemoteEvent.COMPLETE, this.handleComplete);
			request.addEventListener(RemoteEvent.ERROR, this.handleError);
			request.getBaseUserInfo(this.model.userID);
		}
		
		private function destroyRequest(request:RemoteRequest):void{
			request.removeEventListener(RemoteEvent.COMPLETE, this.handleComplete);
			request.removeEventListener(RemoteEvent.ERROR, this.handleError);
		}
		
		private function handleComplete(event:RemoteEvent):void{
			const info:XML = event.response..userInfo[0];
			
			this.model.lock();
			this.model.userPicURL = info.@userpic;
			this.model.userBigPicURL = info.@userpicBig;
			this.model.setName(info.@firstName, info.@lastName);
			this.model.unlock();
			
			//trace(event);
			//trace(event.response.toXMLString());
		}
		
		private function handleError(event:RemoteEvent):void{
			trace(event);
		}
		
		
		
		
		
		
		
		
//		public function updateBaseUserInfo():void{
//			var request:RemoteRequest = new RemoteRequest();
//			request.addEventListener(RemoteEvent.COMPLETE, this.handleBaseComplete);
//			request.addEventListener(RemoteEvent.ERROR, this.handleBaseError);
//			request.getBaseUserInfo(this.model.userID);
//		}
//		
//		private function destroyBaseRequest(request:RemoteRequest):void{
//			request.removeEventListener(RemoteEvent.COMPLETE, this.handleBaseComplete);
//			request.removeEventListener(RemoteEvent.ERROR, this.handleBaseError);
//		}
//		
//		private function handleBaseComplete(event:RemoteEvent):void{
//			const info:XML = event.response..userInfo[0];
//			
//			this.model.lock();
//			this.model.userPicURL = info.@userpic;
//			this.model.userBigPicURL = info.@userpicBig;
//			this.model.setName(info.@firstName, info.@lastName);
//			this.model.unlock();
//			
//			//trace(event);
//			//trace(event.response.toXMLString());
//		}
//		
//		private function handleBaseError(event:RemoteEvent):void{
//			trace(event);
//		}
	}
}
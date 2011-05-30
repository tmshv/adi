package remote{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Event(name="complete", type="remote.RemoteEvent")]
	[Event(name="error", type="remote.RemoteEvent")]
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class RemoteRequest extends EventDispatcher implements ISocialAPI, IGameAPI{
		private static var socialAPIBuilder:IRemoteRequestBuilder;
		private static var gameAPIBuilder:IRemoteRequestBuilder;
		private static var inited:Boolean;
		
		public static function init(socialAPI:IRemoteRequestBuilder, gameAPI:IRemoteRequestBuilder):void{
			RemoteRequest.socialAPIBuilder = socialAPI;
			RemoteRequest.gameAPIBuilder = gameAPI;
			
			RemoteRequest.inited = true;
		}
		
		public static function isInited():Boolean{
			return RemoteRequest.inited;
		}
		
		private var socialAPI:ISocialAPI;
		private var gameAPI:IGameAPI;
		
		public function RemoteRequest(){
			super();
			this.init(
				RemoteRequest.socialAPIBuilder.createSocial(),
				RemoteRequest.gameAPIBuilder.createGame()
			);
		}
		
		public function init(socialAPI:ISocialAPI, gameAPI:IGameAPI):void{
			this.socialAPI = socialAPI;
			this.socialAPI.addEventListener(RemoteEvent.COMPLETE, super.dispatchEvent);
			this.socialAPI.addEventListener(RemoteEvent.ERROR, super.dispatchEvent);
			
			this.gameAPI = gameAPI;
			this.gameAPI.addEventListener(RemoteEvent.COMPLETE, super.dispatchEvent);
			this.gameAPI.addEventListener(RemoteEvent.ERROR, super.dispatchEvent);
		}
		
		/**
		 * Возвращает социальную информацию о пользователе 
		 */
		public function getBaseUserInfo(uids:String):void{
			if(this.socialAPI){
				this.socialAPI.getBaseUserInfo(uids);
			}
		}
		
		/**
		 * Возвращает список друзей пользователя
		 */
		public function getUserFriends():void{
			if(this.socialAPI){
				this.socialAPI.getUserFriends();
			}
		}
		
		/**
		 * Возвращает игровую информацию о пользователе
		 */
		public function getUserInfo():void{
			if(this.gameAPI){
				this.gameAPI.getUserInfo();
			}
		}
		
		public function registerNewUser(nick:String, charType:String, strength:uint, agility:uint, accuracy:uint):void{
			if(this.gameAPI){
				this.gameAPI.registerNewUser(nick, charType, strength, agility, accuracy);
			}
		}
		
		public function getBattleResult(opponentID:String):void{
			if(this.gameAPI){
				this.gameAPI.getBattleResult(opponentID);
			}
		}
		
		public function getOpponents():void{
			if(this.gameAPI){
				this.gameAPI.getOpponents();
			}
		}
		
		public function getConfig():void{
			if(this.gameAPI){
				this.gameAPI.getConfig();
			}
		}
		
		public function buy(item:String):void{
			if(this.gameAPI){
				this.gameAPI.buy(item);
			}
		}
		
		public function getTop30():void{
			if(this.gameAPI){
				this.gameAPI.getTop30();
			}
		}
		
		public function getTopFriends(list:Vector.<String>):void{
			if(this.gameAPI){
				this.gameAPI.getTopFriends(list);
			}
		}
		
		public function getAchievements(uid:String=null):void{
			if(this.gameAPI){
				this.gameAPI.getAchievements(uid);
			}
		}
		
		public function getSkills():void{
			if(this.gameAPI){
				this.gameAPI.getSkills();
			}
		}
		
		public function getItems():void{
			if(this.gameAPI){
				this.gameAPI.getItems();
			}
		}
		
		public function updateSuite(list:Vector.<String>):void{
			if(this.gameAPI){
				this.gameAPI.updateSuite(list);
			}
		}
		
		public function tune(strength:uint, agility:uint, accuracy:uint):void{
			if(this.gameAPI){
				this.gameAPI.tune(strength, agility, accuracy);
			}
		}
		
		public function skillUp(skill:String):void{
			if(this.gameAPI){
				this.gameAPI.skillUp(skill);
			}
		}
	}
}
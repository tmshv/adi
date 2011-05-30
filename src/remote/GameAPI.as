package remote{
	import adiwars.APIMethod;
	import adiwars.core.Config;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class GameAPI extends EventDispatcher implements IGameAPI{
		private var url:String;
		
		private var config:Config;
		public function GameAPI(config:Config){
			super();
			this.config = config;
			this.init();
		}
		
		private function init():void{
			this.url = this.config.gameAPIURL;// + '/api.php';
		}
		
		private function dispatchAboutComplete(response:XML):void{
			super.dispatchEvent(new RemoteEvent(RemoteEvent.COMPLETE, false, false, response));
		}
		
		private function dispatchAboutError(response:XML):void{
			super.dispatchEvent(new RemoteEvent(RemoteEvent.ERROR, false, false, response));
		}
		
		/**
		 * Обрабатывает результат любого запроса в классе и в результате диспатчит соответствующее событие 
		 * @param response
		 * 
		 */
		private function processingRawResponse(response:String):void{
			var response_xml:XML;
			
			trace(response)
			
			try{
				response_xml = new XML(response);
				
				if(this.responseIsError(response_xml)) this.dispatchAboutError(response_xml);
				else this.dispatchAboutComplete(response_xml);
			}catch(error:Error){
				trace(error.message)
				trace(response)
				this.dispatchAboutError(RemoteErrorGenerator.xmlParsingError().toXML());
			}
		}
		
		private function responseIsError(xml:XML):Boolean{
			var tag_name:String = xml.name();
			return tag_name == 'error';
		}
		
		private function getRequest(method:String, params:Object=null):URLRequest{
			if(!params) params = new Object();
			
			var vars:URLVariables = new URLVariables();
			for(var item:String in params){
				vars[item] = params[item];
			}
			
			vars.method = method;
			vars.auth_key = this.config.authKey;
			vars.api_id = this.config.apiID;
			vars.id = this.config.userID;
			vars.timestamp = (new Date()).getTime();
			
			var request:URLRequest = new URLRequest(this.url);
			request.method = URLRequestMethod.POST;
			request.data = vars;
			
			return request;
		}
		
		private function handleComplete(event:Event):void{
			const loader:URLLoader = event.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, this.handleComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			//trace(loader.data)
			
			this.processingRawResponse(loader.data);
		}
		
		private function handleError(event:Event):void{
			const loader:URLLoader = event.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, this.handleComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			this.processingRawResponse(RemoteErrorGenerator.someError().toXML().toXMLString());
		}
		
		/*
		 *  GET USER PARAMS
		 */		
		public function getUserInfo():void{
//			var xml:XML = ResponseGenerator.userInfo(
//				this.config.userID,
//				10,
//				1,
//				2,
//				100001,
//				122,
//				100,
//				12,
//				1244,
//				234,
//				1234,
//				12
//			);
			
//			this.processingRawResponse(RemoteErrorGenerator.xmlUserIsUndefined().toXML().toXMLString());
//			return;
			
			var request:URLRequest = this.getRequest(
				APIMethod.GET_USER_INFO, {
				id: this.config.userID
			});
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			loader.load(request);
		}
		
		/*
		 *  REGISTER
		 */
		public function registerNewUser(nick:String, charType:String, strength:uint, agility:uint, accuracy:uint):void{
//			var temp_result:XML = <userInfo id="1338931" level="1" char="chewbacca" skillpoints="1" experience="0" money="0" totalbattles="0" battles="4">
//				<char nick="Пиздорас" health="50" strength="1" agility="1" accuracy="1"/>
//			</userInfo>;
//			this.processingRawResponse(temp_result.toXMLString());
//			return;
			
			var request:URLRequest = this.getRequest(
				APIMethod.REGISTER_USER, {
				id: this.config.userID,
				nick: nick,
				char: charType,
				strength: strength,
				agility: agility,
				accuracy: accuracy
			});
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			loader.load(request);
		}
		
		/*
		*  BATTLE RESULT
		*/
		public function getBattleResult(opponentID:String):void{
			var request:URLRequest = this.getRequest(
				APIMethod.GET_BATTLE_RESULT, {
					id: this.config.userID,
					eid: opponentID
				});
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			loader.load(request);
		}
		
		/*
		*  FIGHTERS MATCH
		*/
		
		public function getOpponents():void{
			var request:URLRequest = this.getRequest(APIMethod.GET_OPPONENTS);
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			loader.load(request);
		}
		
		/*
		*  CONFIG
		*/
		
		public function getConfig():void{
			var request:URLRequest = this.getRequest(APIMethod.GET_CONFIG);
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			loader.load(request);
		}
		
		/*
		*  BUY
		*/
		
		public function buy(item:String):void{
			var request:URLRequest = this.getRequest(APIMethod.BUY, {item:item});
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			loader.load(request);
		}
		
		/*
		* TOP 30
		*/
		
		public function getTop30():void{
			var request:URLRequest = this.getRequest(APIMethod.TOP_30);
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			loader.load(request);
		}
		
		/*
		* TOP FRIENDS
		*/
		
		public function getTopFriends(list:Vector.<String>):void{
			var request:URLRequest = this.getRequest(APIMethod.FRIENDS, {list: list.join(',')});
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			loader.load(request);
		}
		
		/*
		* ACHIEVEMENTS
		*/
		
		public function getAchievements(uid:String=null):void{
			var request:URLRequest = this.getRequest(APIMethod.GET_ACHIEVMENTS, {uid:uid});
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			loader.load(request);
		}
		
		/*
		* SKILLS
		*/
		
		public function getSkills():void{
			var request:URLRequest = this.getRequest(APIMethod.GET_SKILLS);
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			loader.load(request);
		}
		
		/*
		* GET ITEMS
		*/
		
		public function getItems():void{
			var request:URLRequest = this.getRequest(APIMethod.GET_USER_ITEMS);
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			loader.load(request);
		}
		
		public function updateSuite(list:Vector.<String>):void{
			var request:URLRequest = this.getRequest(APIMethod.UPDATE_SUITE, {item:list.join()});
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			loader.load(request);
		}
		
		public function tune(strength:uint, agility:uint, accuracy:uint):void{
			var request:URLRequest = this.getRequest(APIMethod.TUNE, {strength:strength, agility:agility, accuracy:accuracy});
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			loader.load(request);
		}
		
		public function skillUp(skill:String):void{
			var request:URLRequest = this.getRequest(APIMethod.SKILL_UP, {skill:skill});
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleError);
			
			loader.load(request);
		}
	}
}
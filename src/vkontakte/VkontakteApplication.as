package vkontakte{
	import adiwars.core.Config;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import remote.GameAPI;
	import remote.GameAPIBuilder;
	import remote.RemoteEvent;
	import remote.RemoteRequest;
	
	import ru.gotoandstop.utils.Convert;
	import ru.gotoandstop.vkontakte.params.VkontakteParams;
	
	import social.ISocialApplication;
	import social.ISocialGameApplication;
	
	[SWF(width=700, height=600, frameRate=50, backgroundColor=0x4CA0C7)]
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class VkontakteApplication extends Sprite{
		private var local:Boolean;
		private var config:Config;
		private var gameURL:String;
		private var context:XML;
		
		protected var _game:ISocialGameApplication;
		public function get game():ISocialGameApplication{
			return this._game;
		}
		
		public function VkontakteApplication(){
			super();
			
			var x:XML = <asd color="0xaabbcc" />;
			var n:uint = x.@color;
			trace(n.toString(16))
			
			if(super.stage){
				this.init();
			}else{
				super.addEventListener(Event.ADDED_TO_STAGE, this.handlerAddedToStage);
			}
		}
		
		private function handlerAddedToStage(event:Event):void{
			super.removeEventListener(Event.ADDED_TO_STAGE, this.handlerAddedToStage);
			this.init();
		}
		
		protected function init():void{
			Security.allowDomain('adiwars.ideafixe.ru', 'starwars.nlomarketing.ru');
			
			var params:Object = super.stage.loaderInfo.parameters;
			
			var ideafixe_remote_context:XML = <context>
							<value key="secretKey">KotJNqAw7F</value>
							<value key="initFileURL">http://adiwars.ideafixe.ru/init.xml</value>
							<value key="vkontakteTestMode">true</value>
							<value key="gameAPIURL">http://adiwars.ideafixe.ru/api.php</value>
						</context>;
			
			var nlo_remote_context:XML = <context>
										<value key="secretKey">k1roFpK4Oe</value>
										<value key="initFileURL">http://starwars.nlomarketing.ru/init.xml</value>
										<value key="vkontakteTestMode">false</value>
										<value key="gameAPIURL">http://starwars.nlomarketing.ru/api.php</value>
									</context>;
			
			var ideafixe_local_context:XML = <context>
							<value key="userID">1338931</value>
							<value key="applicationID">1386476</value>
							<value key="secretKey">KotJNqAw7F</value>
							<value key="initFileURL">init.xml</value>
							<value key="loaderURL">AdiwarsLoader.swf</value>
							<value key="vkontakteTestMode">true</value>
							<value key="gameAPIURL">http://adiwars.ideafixe.ru/api.php</value>
						</context>;
			
			var nlo_local_context:XML = <context>
										<value key="userID">1338931</value>
										<value key="applicationID">1386476</value>
										<value key="secretKey">KotJNqAw7F</value>
										<value key="initFileURL">init.xml</value>
										<value key="loaderURL">AdiwarsLoader.swf</value>
										<value key="vkontakteTestMode">true</value>
										<value key="gameAPIURL">http://starwars.nlomarketing.ru/api.php</value>
									</context>;
			
			var remote_context:XML = nlo_remote_context;
			var local_context:XML = nlo_local_context;
			
			if(!params.api_id){
				this.local = true;
				this.context = local_context;
				
				const appl_id:uint = this.context.value.(@key=='applicationID');
				const user_id:uint = this.context.value.(@key=='userID');
				
				params = {
					api_url: 'http://api.vkontakte.ru/api.php',
					api_id: appl_id,
					user_id: user_id,
//					group_id, 
					viewer_id: user_id,
//					is_app_user,
//					viewer_type,
					auth_key: '81056bfb7c3a0d6736a092fc885347cd'
//					language,
//					api_result,
//					api_settings,
//					referrer,
//					poster_id,
//					post_id
				};
			}else{
				this.context = remote_context;
				this.local = false;
			}
			
			var vk_params:VkontakteParams = new VkontakteParams(params);
			const viewer_id:uint = vk_params.viewerID;
			
			var first:FirstRequest = new FirstRequest(new XML(vk_params.apiResult), viewer_id);
			//var first:FirstRequest = new FirstRequest(new XML('<response><test>1</test><url>http://cs4888.vkontakte.ru/u53426/8a43e817d08c7f.zip</url><isapp>1</isapp><profile list="true"><item><uid>1338931</uid><first_name>Роман</first_name><last_name>Тимашев</last_name><sex>2</sex><bdate>12.3.1989</bdate></item></profile><settings>2</settings></response>'), viewer_id);
			this.gameURL = first.url;
			
			this.config = this.createConfig(vk_params, new ConfigProfile(first.profile));
			
			var use_test_mode:Boolean = Convert.stringToBoolean(this.context.value.(@key=='vkontakteTestMode'));
			var vk_builder:VkontakteAPIBuilder = new VkontakteAPIBuilder(params, config, use_test_mode);
			RemoteRequest.init(vk_builder, new GameAPIBuilder(config));
			
			this.config.inviteFunction = vk_builder.inviteFunction;
			this.config.firstRequest = first.source;
			
			var fr:RemoteRequest = new RemoteRequest();
			fr.addEventListener(RemoteEvent.COMPLETE, this.handleLoadFriendsResult);
			fr.addEventListener(RemoteEvent.ERROR, this.handleLoadFriendsResult);
			fr.getUserFriends();
		}
		
		private function createConfig(vk:VkontakteParams, profile:ConfigProfile):Config{
			var config:Config = new Config();
			config.context = this.context;
			config.userID = vk.viewerID.toString();
			config.apiID = vk.apiID.toString();
			config.authKey = vk.authKey;
			config.userProfile = profile.profile;
			config.width = 700;
			config.height = 600;
			config.secretKey = this.context.value.(@key=='secretKey');
			config.gameAPIURL = this.context.value.(@key=='gameAPIURL');
			
			return config;
		}
		
		private function startLoadGame():void{
			const local_url:String = this.context.value.(@key=='loaderURL');
			const remote_url:String = this.gameURL ? this.gameURL : local_url;
			var url:String = this.local ? local_url : remote_url;
			
			trace('game url:', url)
			var loader:Loader = this.createLoader();
			loader.load(new URLRequest(url));
		}
		
		private function createLoader():Loader{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.handlerLoadGameComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.handleLoadGameProgress);
			return loader;
		}
		
		private function destroyLoader(loader:Loader):void{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.handlerLoadGameComplete);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.handleLoadGameProgress);
		}
		
		private function handleLoadGameProgress(event:ProgressEvent):void{
			
		}
		
		private function handlerLoadGameComplete(event:Event):void{
			const loader_info:LoaderInfo = event.target as LoaderInfo;
			const loader:Loader = loader_info.loader;
			this.destroyLoader(loader);
			
			this._game = loader.content as ISocialGameApplication;
			this.build();
		}
		
		private function handleLoadFriendsResult(event:RemoteEvent):void{
			const request:RemoteRequest = event.target as RemoteRequest;
			request.removeEventListener(RemoteEvent.COMPLETE, this.handleLoadFriendsResult);
			request.removeEventListener(RemoteEvent.ERROR, this.handleLoadFriendsResult);
			
			var friends_raw:String = event.response;
			var friends_list:Array = friends_raw.split(',');
			var friends:Vector.<String> = new Vector.<String>();
			for each(var friend_uid:String in friends_list){
				friends.push(friend_uid);
			}
			config.friends = friends;
			
			this.startLoadGame();
		}
		
		protected function build():void{
			super.addChild(this._game as DisplayObject);
			this._game.launch(this.config);
		}
	}
}
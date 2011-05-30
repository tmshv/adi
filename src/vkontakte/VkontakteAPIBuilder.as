package vkontakte{
	import adiwars.core.Config;
	
	import remote.IGameAPI;
	import remote.IRemoteRequestBuilder;
	import remote.ISocialAPI;
	
	import ru.gotoandstop.vkontakte.api.VkontakteRequest;
	import ru.gotoandstop.vkontakte.params.VkontakteParams;
	
	import vk.APIConnection;
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class VkontakteAPIBuilder implements IRemoteRequestBuilder{
		private var _api:APIConnection;
		private var _params:VkontakteParams;
		
		public function get inviteFunction():Function{
			return this.invite;
		}
		
		private function invite():void{
			trace('open invite box')
			try{
				this._api.callMethod('showInviteBox');
			}catch(error:Error){
				
			}
		}
		
		public function VkontakteAPIBuilder(params:Object, config:Config, useTestMode:Boolean){
			super();
			
			var vk_params:VkontakteParams = new VkontakteParams(params);
			
			const secret:String = config.secretKey;
			
			VkontakteRequest.init(
				vk_params.viewerID,
				vk_params.apiID,
				secret,
				'XML',
				'2.0',
				useTestMode,
				vk_params.apiURL,
				null
			);
			
			this._params = vk_params;
			this._api = new APIConnection(params);
			
			this.setSize(config.width, config.height);
		}
		
		public function setSize(width:uint, height:uint):void{
			try{
				this._api.callMethod('resizeWindow', width, height);
			}catch(error:Error){
				trace('cannot resize window')
			}
		}
		
		public function createSocial():ISocialAPI{
			return new VkontakteAPI(this._params);
		}
		
		public function createGame():IGameAPI{
			return null;
		}
	}
}
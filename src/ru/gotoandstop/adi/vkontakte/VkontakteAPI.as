package ru.gotoandstop.adi.vkontakte{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import ru.gotoandstop.adi.remote.ISocialAPI;
	import ru.gotoandstop.adi.remote.RemoteEvent;
	import ru.gotoandstop.adi.remote.ResponseGenerator;
	
	import ru.gotoandstop.vkontakte.api.Method;
	import ru.gotoandstop.vkontakte.api.VkontakteRequest;
	import ru.gotoandstop.vkontakte.api.events.VkontakteErrorEvent;
	import ru.gotoandstop.vkontakte.api.events.VkontakteEvent;
	import ru.gotoandstop.vkontakte.params.VkontakteParams;
	
	import vk.APIConnection;
	
	[Event(name="complete", type="ru.gotoandstop.adi.remote.RemoteEvent")]
	[Event(name="error", type="ru.gotoandstop.adi.remote.RemoteEvent")]
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class VkontakteAPI extends EventDispatcher implements ISocialAPI{
//		private var _api:APIConnection;
		private var _params:VkontakteParams;
		
		public function VkontakteAPI(params:VkontakteParams){
			super();
			
			this._params = params;
			
//			var vk_params:VkontakteParams = new VkontakteParams(params);
//			
//			const secret:String = 'KotJNqAw7F';
//			
//			VkontakteRequest.init(
//				vk_params.viewerID,
//				vk_params.apiID,
//				secret,
//				'XML',
//				'2.0',
//				true,
//				vk_params.apiURL,
//				null
//			);
			
//			this._api = new APIConnection(params);
		}
		
		public function getBaseUserInfo(uids:String):void{
			trace('vk: get base user info')
			
			const needed_fields:String = 'uid,first_name,last_name,photo_medium,photo,photo_big,photo_rec';
			
			var r:VkontakteRequest = new VkontakteRequest();
			r.addEventListener(VkontakteEvent.REQUEST_COMPLETE, this.handleGetBaseInfoComplete);
			r.addEventListener(VkontakteErrorEvent.REQUEST_ERROR, this.handleGetBaseUserInfoError);
			r.request(Method.GET_PROFILES, {
				uids: uids,//this._params.userID,
				fields: needed_fields
				
			});
		}
		
		private function handleGetBaseInfoComplete(event:VkontakteEvent):void{
			trace('vk: base user info request complete')
			
			const r:VkontakteRequest = event.target as VkontakteRequest;
			r.removeEventListener(VkontakteEvent.REQUEST_COMPLETE, this.handleGetBaseInfoComplete);
			r.removeEventListener(VkontakteErrorEvent.REQUEST_ERROR, this.handleGetBaseUserInfoError);
			
			//var response:XML = ResponseGenerator.createUserInfoResponse(
//				event.response.user.first_name,
//				event.response.user.last_name,
//				event.response.user.photo_medium
//			);
//			
//			trace(response.toXMLString())
//			trace('end of handle')
			
			var user_list:Vector.<Array> = new Vector.<Array>();
			var users:XMLList = event.response..user;
			for each(var user:XML in users){
				user_list.push([user.uid, user.first_name, user.last_name, user.photo, user.photo_medium]);
			}
			var response:XML = ResponseGenerator.createUserInfoResponse(user_list);
			//var response:XML = event.response;
			super.dispatchEvent(new RemoteEvent(RemoteEvent.COMPLETE, false, false, response));
		}
		
		private function handleGetBaseUserInfoError(event:VkontakteErrorEvent):void{
			trace('vk: base user info request error')
			
			const r:VkontakteRequest = event.target as VkontakteRequest;
			r.removeEventListener(VkontakteEvent.REQUEST_COMPLETE, this.handleGetBaseInfoComplete);
			r.removeEventListener(VkontakteErrorEvent.REQUEST_ERROR, this.handleGetBaseUserInfoError);
			
			super.dispatchEvent(new RemoteEvent(RemoteEvent.ERROR, false, false, event.error));
		}
		
		public function getUserFriends():void{
			trace('vk: get friends')
			
			var r:VkontakteRequest = new VkontakteRequest();
			r.addEventListener(VkontakteEvent.REQUEST_COMPLETE, this.handleGetFriends);
			r.addEventListener(VkontakteErrorEvent.REQUEST_ERROR, this.handleGetFriendsError);
			r.request(Method.GET_APP_FRIENDS, {});
		}
		
		private function handleGetFriends(event:VkontakteEvent):void{
			const r:VkontakteRequest = event.target as VkontakteRequest;
			r.removeEventListener(VkontakteEvent.REQUEST_COMPLETE, this.handleGetFriends);
			r.removeEventListener(VkontakteErrorEvent.REQUEST_ERROR, this.handleGetFriendsError);
			
			trace('vk: friends', event.response.toXMLString())
			
			var list:XMLList = event.response..uid;
			var result:Vector.<uint> = new Vector.<uint>();
			for each(var item:XML in list){
				result.push(item);
			}
			var joined:String = result.join(',');
			var response:XML = <friends>{joined}</friends>;
			super.dispatchEvent(new RemoteEvent(RemoteEvent.COMPLETE, false, false, response));
		}
		
		private function handleGetFriendsError(event:VkontakteErrorEvent):void{
			const r:VkontakteRequest = event.target as VkontakteRequest;
			r.removeEventListener(VkontakteEvent.REQUEST_COMPLETE, this.handleGetFriends);
			r.removeEventListener(VkontakteErrorEvent.REQUEST_ERROR, this.handleGetFriendsError);
			
			trace(event.error.toXMLString())
			super.dispatchEvent(new RemoteEvent(RemoteEvent.COMPLETE, false, false, <friends></friends>));
		}
	}
}
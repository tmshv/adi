package adiwars.raiting{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import remote.RemoteEvent;
	import remote.RemoteRequest;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class RaitingItemLoader extends EventDispatcher{
		private var items:XMLList;
		private var profiles:XMLList;
		
		private var _loadedItems:XMLList;
		public function get loadedItems():XMLList{
			return this._loadedItems;
		}
		
		public function RaitingItemLoader(){
			super();
		}
		
		public function loadItems(list:Vector.<String>):void{
//			trace('loading items')
			var request:RemoteRequest = new RemoteRequest;
			request.addEventListener(RemoteEvent.COMPLETE, this.handleLoadTopComplete);
			request.addEventListener(RemoteEvent.ERROR, this.handleLoadTopError);
			
			if(list.length) request.getTopFriends(list);
			else request.getTop30();
		}
		
		private function destroyRequest(request:RemoteRequest):void{
			request.removeEventListener(RemoteEvent.COMPLETE, this.handleLoadTopComplete);
			request.removeEventListener(RemoteEvent.ERROR, this.handleLoadTopError);
		}
		
		private function handleLoadTopComplete(event:RemoteEvent):void{
//			trace('items loaded')
//			trace(event.response.toXMLString())
			
			this.items = event.response..item;
			this.loadProfiles(this.getIDList(this.items));
			
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyRequest(request);
		}
		
		private function handleLoadTopError(event:RemoteEvent):void{
			trace(event.response.toXMLString())
		}
		
		private function getIDList(items:XMLList):Vector.<String>{
			var ids:Vector.<String> = new Vector.<String>();
			for each(var item:XML in items){
				ids.push(item.@id);
			}
			return ids;
		}
		
		private function loadProfiles(list:Vector.<String>):void{
			trace('loading profiles')
			if(list.length){
				var ids:String = list.join(',');
				
				var request:RemoteRequest = new RemoteRequest();
				request.addEventListener(RemoteEvent.COMPLETE, this.handleLoadProfilesComplete);
				request.addEventListener(RemoteEvent.ERROR, this.handleLoadProfilesError);
				request.getBaseUserInfo(ids);
			}
		}
		
		private function handleLoadProfilesComplete(event:RemoteEvent):void{
			trace('profiles loaded');
//			trace(event.response.toXMLString())
			
			this.profiles = event.response..userInfo;
			this.combineLoadedData();
			
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyIserInfo(request);
		}
		
		private function handleLoadProfilesError(event:RemoteEvent):void{
			trace(event.response.toXMLString())
			
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyIserInfo(request);
		}
		
		private function destroyIserInfo(request:RemoteRequest):void{
			request.removeEventListener(RemoteEvent.COMPLETE, this.handleLoadProfilesComplete);
			request.removeEventListener(RemoteEvent.ERROR, this.handleLoadProfilesError);
		}
		
		private function combineLoadedData():void{
			var length:uint = Math.min(this.items.length(), this.profiles.length());
			
			var items:XML = <users/>;
			for(var i:uint; i<length; i++){
				var top_item:XML = this.items[i];
				var profile:XML = this.profiles.(@id == top_item.@id)[0];
				
				if(top_item && profile){
					var item:XML = <item id={top_item.@id} lvl={top_item.@lvl} exp={top_item.@exp} top={top_item.@top} firstName={profile.@firstName} lastName={profile.@lastName} userpic={profile.@userpic} />;
					items.appendChild(item);	
				}
			}
			
			this._loadedItems = items..item;
			
			super.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
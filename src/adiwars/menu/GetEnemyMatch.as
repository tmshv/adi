package adiwars.menu{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import remote.RemoteEvent;
	import remote.RemoteRequest;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class GetEnemyMatch extends EventDispatcher{
		private var items:XMLList;
		private var profiles:XMLList;
		
		private var _loadedItems:XMLList;
		public function get enemies():XMLList{
			return this._loadedItems;
		}
		
		private var _time:uint;
		public function get timeToOpen():uint{
			return this._time;
		}
		
		public function GetEnemyMatch(){
			super();
		}
		
		public function execute():void{
			//this._time = 2;
			//super.dispatchEvent(new Event('error'));
			
			//<error><value key="time">2</value></error>
			this.loadItems();
		}
		
		private function combineLoadedData():void{
			var length:uint = Math.min(this.items.length(), this.profiles.length());
			length = this.items.length();
			
			var items:XML = <users/>;
			for(var i:uint; i<length; i++){
				var top_item:XML = this.items[i];
				var profile:XML = this.profiles.(@id == top_item.@id)[0];
				
				if(top_item && profile){
					var item:XML = <item id={top_item.@id} lvl={top_item.@lvl} nick={top_item.@nick} health={top_item.@health} strength={top_item.@strength} agility={top_item.@agility} accuracy={top_item.@accuracy} phealth={top_item.@phealth} pstrength={top_item.@pstrength} pagility={top_item.@pagility} paccuracy={top_item.@paccuracy} firstName={profile.@firstName} lastName={profile.@lastName} userpic={profile.@userpic} battles={top_item.@battles} wins={top_item.@wins}/>;
					items.appendChild(item);
				}
			}
			
			this._loadedItems = items..item;
			
			trace('loaded items')
			trace(this.items.toXMLString())
			trace('loaded profiles')
			trace(this.profiles.toXMLString())
			trace('items')
			trace(this.enemies.toXMLString())
			
			super.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/* ************** */
		// LOAD ITEMS
		/* ************** */
		
		private function loadItems():void{
			var request:RemoteRequest = new RemoteRequest;
			request.addEventListener(RemoteEvent.COMPLETE, this.handleLoadComplete);
			request.addEventListener(RemoteEvent.ERROR, this.handleLoadError);
			
			request.getOpponents();
		}
		
		private function destroyRequest(request:RemoteRequest):void{
			request.removeEventListener(RemoteEvent.COMPLETE, this.handleLoadComplete);
			request.removeEventListener(RemoteEvent.ERROR, this.handleLoadError);
		}
		
		private function handleLoadComplete(event:RemoteEvent):void{
			this.items = event.response..item;
			this.loadProfiles(this.getIDList(this.items));
			
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyRequest(request);
		}
		
		private function handleLoadError(event:RemoteEvent):void{
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyRequest(request);
			
			//<error id="215"><value key="time">2</value></error>
			trace(event.response.toXMLString())
			var error_type:uint = event.response.@id;
			if(error_type == 215){
				var time:uint = event.response.value.(@key == 'time');
				this._time = time;
				super.dispatchEvent(new Event('error'));
			}
		}
		
		private function getIDList(items:XMLList):Vector.<String>{
			var ids:Vector.<String> = new Vector.<String>();
			for each(var item:XML in items){
				ids.push(item.@id);
			}
			return ids;
		}
		
		/* ************** */
		// LOAD PROFILES
		/* ************** */
		
		private function loadProfiles(list:Vector.<String>):void{
			if(list.length){
				var ids:String = list.join(',');
				
				var request:RemoteRequest = new RemoteRequest();
				request.addEventListener(RemoteEvent.COMPLETE, this.handleLoadProfilesComplete);
				request.addEventListener(RemoteEvent.ERROR, this.handleLoadProfilesError);
				request.getBaseUserInfo(ids);
			}
		}
		
		private function handleLoadProfilesComplete(event:RemoteEvent):void{
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
	}
}
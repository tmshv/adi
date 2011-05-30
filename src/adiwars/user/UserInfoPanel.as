package adiwars.user{
	import adiwars.clips.UserInfoPanelClip;
	import adiwars.core.Context;
	import adiwars.core.mvc.BaseView;
	import adiwars.core.mvc.IModel;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import remote.RemoteEvent;
	import remote.RemoteRequest;
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class UserInfoPanel extends BaseView{
		private var panel:UserInfoPanelClip;
		private var picURL:String;
		
		public function UserInfoPanel(clip:UserInfoPanelClip, context:Context){
			super(context.owner.model, context);
			this.panel = clip;
			this.init();
		}
		
		private function init():void{
			super.model.addEventListener(Event.CHANGE, this.handleModelChange);
			
			var model:OwnerModel = this.getModel();
			this.updateClipParams(model.money, model.experience, model.level);
			
			if(model.userPicURL) this.loadUserpic(model.userBigPicURL);
		}
		
		private function getModel():OwnerModel{
			return super.model as OwnerModel;
		}
		
		private function updateClipParams(money:uint, exp:uint, level:uint):void{
			var money_text:String = money ? money.toString() : '0';//нетденег';
			
			var needed_to_current_level:uint = this.calculateExpForLevel(level);
			var needed_to_next_level:uint = this.calculateExpForLevel(level + 1);
			var difference_between_current_and_next_level:uint = needed_to_next_level - needed_to_current_level;
			var accumulated_value_for_next_level:uint = exp - needed_to_current_level;
			var percentes:uint = (accumulated_value_for_next_level / difference_between_current_and_next_level) * 100;
			
			trace(this.calculateExpForLevel(10))
			trace(needed_to_current_level)
			trace(needed_to_next_level)
			
			var exp_value_text:String = '<current>/<next>';
			exp_value_text = exp_value_text.replace(/<current>/, exp);
			exp_value_text = exp_value_text.replace(/<next>/, needed_to_next_level);
			
			this.panel.money.text = money_text;
			this.panel.expValue.text = exp_value_text;
			this.panel.level.text = level.toString();
			
			this.panel.expLine.gotoAndStop(percentes);
		}
		
		private function handleModelChange(event:Event):void{
			const model:OwnerModel = event.target as OwnerModel;
			this.updateClipParams(model.money, model.experience, model.level);
			
			if(model.userBigPicURL != this.picURL){
				this.loadUserpic(model.userBigPicURL);
			}
		}
		
		private function loadUserpic(url:String):void{
			this.picURL = url;
			
			//var loader:Loader = new Loader();
			//loader.load(new URLRequest(url));
			
			var ava:DisplayObject = super.context.getRemoteImage(url);
			this.panel.avatar.addChild(ava);
			
//			var request:RemoteRequest = new RemoteRequest();
//			request.addEventListener(RemoteEvent.COMPLETE, this.handleGetProfile);
//			request.addEventListener(RemoteEvent.ERROR, this.handleGetProfileError);
			//request.getBaseUserInfo();
		}
		
//		private function handleGetProfile(event:RemoteEvent):void{
//			var request:RemoteRequest = event.target as RemoteRequest;
//			request.removeEventListener(RemoteEvent.COMPLETE, this.handleGetProfile);
//			request.removeEventListener(RemoteEvent.ERROR, this.handleGetProfileError);
//			
//			var user_pic_url:String = event.response.@userpic;
//			
//			var loader:Loader = new Loader();
//			loader.load(new URLRequest(user_pic_url));
//			this.panel.avatar.addChild(loader);
//		}
		
//		private function handleGetProfileError(event:RemoteEvent):void{
//			trace(event)
//			
//			var request:RemoteRequest = event.target as RemoteRequest;
//			request.removeEventListener(RemoteEvent.COMPLETE, this.handleGetProfile);
//			request.removeEventListener(RemoteEvent.ERROR, this.handleGetProfileError);
//			
//			setTimeout(this.loadUserpic, 5000);
//		}
		
		private function calculateExpForLevel(level:uint):uint{
			var value:uint = 0;
			for(var i:uint=2; i<=level; i++){
				value += 20 * Math.pow(i, 1.5);
			}
			return value;
		}
	}
}
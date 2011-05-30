package adiwars.informers{
	import adiwars.character.BattleCharModel;
	import adiwars.clips.BattleUserInfo;
	import adiwars.core.Context;
	import adiwars.core.mvc.BaseView;
	import adiwars.user.OwnerModel;
	import adiwars.user.UserModel;
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class BattleInformer{
		private var user:BattleCharModel;
		private var opponent:BattleCharModel;
		private var picURL:String;
		private var picURL2:String;
		
		private var clip:BattleUserInfo;
		
		private var userOptions:Options;
		private var opponentOptions:Options;
		
		public function BattleInformer(clip:BattleUserInfo){
			super();
			this.clip = clip;
			
			this.userOptions = new Options(-205, 0, 1);
			this.opponentOptions = new Options(-205, 0, 1);//(856, 654, 1);
//			
//			this.clip.username.text = super.context.owner.model.getName();
//			this.clip.opponentname.text = super.context.opponent.getName();
//			
//			super.context.owner.model.addEventListener(Event.CHANGE, this.handleOwnerChange);
//			super.context.opponent.addEventListener(Event.CHANGE, this.handleOpponentChange);
		}
		
		private function handleOwnerChange(event:Event):void{
			const model:OwnerModel = event.target as OwnerModel;
			var url:String = model.userPicURL;
			
			if(model.userPicURL != this.picURL){
				this.loadUserpic(this.clip.user.userpic, model.userPicURL);
			}
			
			this.clip.user.level.text = model.level.toString();
			this.clip.username.text = model.getName();
		}
		
		private function handleOpponentChange(event:Event):void{
			const model:UserModel = event.target as UserModel;
			var url:String = model.userPicURL;
			
			if(model.userPicURL != this.picURL2){
				this.loadUserpic(this.clip.opponent.userpic, model.userPicURL);
			}
			
//			this.clip.opponent.user.level.text = model.level.toString();
//			this.clip.opponentname.text = model.getName();
		}
		
		public function init(user:UserModel, opponent:UserModel):void{
			this.clip.username.text = user.getName();
			this.clip.user.level.text = user.level.toString();
			this.loadUserpic(this.clip.user.userpic, user.userPicURL);
			
			this.clip.opponentname.text = opponent.getName();
			this.clip.opponent.level.text = opponent.level.toString();
			this.loadUserpic(this.clip.opponent.userpic, opponent.userPicURL);
		}
		
		private function loadUserpic(clip:DisplayObjectContainer, url:String):void{
			if(!url) return;
//			var loader:Loader = new Loader();
//			loader.load(new URLRequest(url));
			var ava:DisplayObject = Context.inst.getRemoteImage(url);
			clip.addChild(ava);
		}
		
		public function subscribe(user:BattleCharModel, opponent:BattleCharModel):void{
			if(this.user) this.destroyListeners(this.user);
			if(this.opponent) this.destroyListeners(this.opponent);
			
			this.user = user;
			this.opponent = opponent;
			this.createListeners(this.user);
			this.createListeners(this.opponent);
			
			this.update(this.user);
			this.update(this.opponent);
		}
		
		private function handleModelChange(event:Event):void{
			const model:BattleCharModel = event.target as BattleCharModel;
			this.update(model);
		}
		
		private function update(model:BattleCharModel):void{
			var clip:MovieClip;
			var options:Options;
			
			var health_field:TextField;			
			switch(model.definition.ownerID){
				//damage to user
				case user.definition.ownerID:
					clip = this.clip.userhealth.line;
					options = this.userOptions;
					health_field = this.clip.userhealthfield;
					break;
				
				//damage to opp
				case opponent.definition.ownerID:
					clip = this.clip.opponenthealth.line;
					options = this.opponentOptions;
					health_field = this.clip.opponenthealthfield;
					break;
			}
			
			health_field.text = model.currentHealth + '/' + model.totalHealth;
			var pos:int = this.getPositionBetween(options.left, options.right, model.currentHealth/model.totalHealth);
			this.slideClipTo(clip, pos);
		}
		
		private function slideClipTo(clip:MovieClip, value:int):void{
			//clip.x = value;
			
			if(clip.x != value){
				Tweener.addTween(clip, {time:0.3, x:value, transition:'easeInQuad'});
			}
		}
		
		private function getPositionBetween(left:int, right:int, ratio:Number):int{
			return (left + (right-left)*ratio);
		}
		
		private function createListeners(model:BattleCharModel):void{
			model.addEventListener(Event.CHANGE, this.handleModelChange);
		}
		
		private function destroyListeners(model:BattleCharModel):void{
			model.removeEventListener(Event.CHANGE, this.handleModelChange);
		}
	}
}
import flash.geom.Point;

internal class Options{
	public var left:int;
	public var right:int;
	public var scale:Number;
	
	public function Options(left:int, right:int, scale:Number){
		this.left = left;
		this.right = right;
		this.scale = scale;
	}
	
	public function toString():String{
		var text:String = '[options <left> <right> <scale>]';
		text = text.replace(/<left>/, this.left);
		text = text.replace(/<right>/, this.right);
		text = text.replace(/<scale>/, this.scale);
		return text;
	}
}
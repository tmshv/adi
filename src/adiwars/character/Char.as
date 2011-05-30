package adiwars.character{
	import adiwars.GoodsItem;
	import adiwars.character.events.CharEvent;
	import adiwars.clips.ChewbaccaClip;
	import adiwars.core.Context;
	import adiwars.core.mvc.BaseController;
	import adiwars.user.Goods;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	
	[Event(name="share", type="adiwars.character.events.CharEvent")]
	[Event(name="doAction", type="adiwars.character.events.CharEvent")]
	[Event(name="damage", type="adiwars.character.events.CharEvent")]
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class Char extends EventDispatcher{
		public var suite:Vector.<GoodsItem>;
		
		/**
		 * экземпляр <code>CharDefinition</code>, описывающий персонажа 
		 */
		protected var _definition:CharDefinition;
		public function get definition():CharDefinition{
			return this._definition;
		}
		
		/**
		 * наследник <code>MovieClip</code> из пакета <code>adiwars.clips</code>, содержащий анимацию персонажа
		 */
		protected var clip:MovieClip;
		public function getClip():DisplayObject{
			return this.clip;
		}
		
		private var sequence:Vector.<String>;
		
//		public override function set container(value:DisplayObjectContainer):void{
//			//throw new IllegalOperationError();
//		}
//		
//		public override function get container():DisplayObjectContainer{
//			return clip;//throw new IllegalOperationError()
//		}
		
		
		public var model:BattleCharModel;
		
		/**
		 * 
		 * @param clip наследник <code>MovieClip</code> из пакета <code>adiwars.clips</code>, содержащий анимацию персонажа
		 * @param context контекст приложения
		 * @param definition экземпляр <code>CharDefinition</code>, описывающий персонажа
		 * 
		 */
		public function Char(clip:MovieClip, definition:CharDefinition){
			super();
			this._definition = definition;
			this.clip = clip;
			this.clip.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			this.clip.addEventListener(Event.REMOVED_FROM_STAGE, this.handleClipRemovedFromStage);
			this.model = new BattleCharModel(this.definition);
			this.wearUp();
			this.doAction('stay');
		}
		
		private function handleClipRemovedFromStage(event:Event):void{
			this.clip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			this.clip.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleClipRemovedFromStage);
		}
		
		/**
		 * Указывает персонажу выполнить указанное действие
		 * туду: передавать экземпляр <code>CharAction</code> в место строки
		 * @param action айди действия
		 * @param delay задержка перед выполнением действия в милисекундах
		 * 
		 */
		public function doAction(action:String):void{
			var s:XML = <sequences>
	<sequence action="stab">forward,stab,backward</sequence>
	<sequence action="doublestab">forward,stab,stab,backward</sequence>
	<sequence action="doublehit">hit,hit</sequence>
	<sequence action="disorientation">disorientation,stab,backward</sequence>
</sequences>;
			
			var sequence:Vector.<String>;
			var current_sequence:XML = s.sequence.(@action==action)[0];
			
			if(current_sequence){
				sequence = CharAction.parseSequence(current_sequence);
			}else{
				sequence = CharAction.parseSequence(action);
			}
			
			//trace(this, 'will play sequence', sequence);
			
			this.playAnimationSequence(sequence);
			super.dispatchEvent(new CharEvent(CharEvent.DO_ACTION, false, false, action));
		}
		
		public function setDamage(value:uint):void{
			this.model.currentHealth = value;
			if(value) super.dispatchEvent(new CharEvent(CharEvent.DAMAGE, false, false, null, value));
		}
		
		/**
		 * Проигрывает последовательность анимаций
		 * В случае отсутствия анимации, диспатчит событие завершения
		 * @param list
		 * 
		 */
		private function playAnimationSequence(list:Vector.<String>):void{
			this.sequence = list;
			
			//trace('play anim seque', this.sequence)
			
			try{
				var anim:String = list[0];
				this.playAnimation(anim);
			}catch(error:Error){
				//trace(this, 'complete sequence')
				
				this.completeAnimationSequence();
			}
		}
		
		private function playAnimation(anim:String):void{
			//trace(this, 'play animation', anim)
			
			this.clip.gotoAndStop(anim);
			this.wearUp();
			
			var anim_clip:MovieClip = this.clip.getChildAt(0) as MovieClip;
			anim_clip.addEventListener(Event.ENTER_FRAME, this.handleAnimationClipEnterFrame);
			anim_clip.gotoAndPlay(1);
		}
		
		private function handleEnterFrame(event:Event):void{
			this.wearUp();
		}
		
		private function handleAnimationClipEnterFrame(event:Event):void{
			const anim:MovieClip = event.target as MovieClip;
			
			//clip frame label changed
			var has_frame_label:Boolean = Boolean(anim.currentFrameLabel);
			var animations:Vector.<String> = this.parseAnimationFrameLabel(anim.currentFrameLabel);
			
			var end_of_animation:Boolean = (anim.currentFrame == anim.totalFrames);
			
			if(has_frame_label){
				for each(var animation:String in animations){
					super.dispatchEvent(new CharEvent(CharEvent.ANIMATION_STATE, false, false, animation));
				}
			}
			
			if(end_of_animation){
				//trace('anim ended')
				
				anim.removeEventListener(Event.ENTER_FRAME, this.handleAnimationClipEnterFrame);
				anim.stop();
				
				this.sequence.shift();
				this.playAnimationSequence(this.sequence);
			}
		}
		
		private function handleAnimationComplete(event:Event):void{
			
		}
		
		private function parseAnimationFrameLabel(label:String):Vector.<String>{
			if(!label) return null;
			var anims:Array = label.split('_');
			var result:Vector.<String> = new Vector.<String>();
			for each(var anim:String in anims){
				result.push(anim);
			}
			return result;
		}
		
		private function completeAnimationSequence():void{
			super.dispatchEvent(new CharEvent(CharEvent.COMPLETE));
		}
		
		public override function toString():String{
			if(this._definition){
				var text:String = '[<nick> <char>; owner=<owner>]';
				text = text.replace(/<nick>/, this._definition.nick);
				text = text.replace(/<char>/, this._definition.type);
				text = text.replace(/<owner>/, this._definition.ownerID);
				return text;
			}else{
				return super.toString();
			}	
		}
		
		public function wearUp():void{
			const clip:MovieClip = this.clip;
			for each(var item:GoodsItem in this.suite){
				if(item){
					//trace('char wear up', item)
					var anim:Sprite = clip.getChildAt(0) as Sprite;
					var goods_clips:Vector.<MovieClip> = this.getSuiteClips(anim, item.name);
					
					for each(var c:MovieClip in goods_clips){
						if(c) c.gotoAndStop(item.frame);
					}
				}
			}
		}
		
		private function getSuiteClips(container:Sprite, type:String):Vector.<MovieClip>{
			type = type.substr(0, 1);
			
			var s:* = container;
			
//			trace(s.foot_left, s.footRight, s.shinRight, s.legLeft)
//			trace(s.body, s.body.jacket, s.body.pants)
//			trace(s.forearmLeft, s.forearmLeft.jacket)
//			trace(s.forearmRight, s.forearmRight.jacket)
			
			var list:Vector.<MovieClip> = new Vector.<MovieClip>();
			switch(type){
				//shoes
				case '1':
					list.push(s.foot_left);
					list.push(s.footRight);
					break;
				
				//pants
				case '2':
					list.push(s.shinRight);
					list.push(s.legRight);
					list.push(s.shinLeft);
					list.push(s.legLeft);
					list.push(s.body.pants);
					break;
				
				//shirts
								case '3':
									list.push(s.forearmRight.jacket);
									list.push(s.forearmLeft.jacket);
									list.push(s.body.jacket);
									break;
								
//				jackets
								case '4':
									list.push(s.forearmRight.jacket);
									list.push(s.forearmLeft.jacket);
									list.push(s.body.jacket);
									break;
								
				//weapone
				case '5':
					list.push(s.weapon);
					break;
			}
			return list;
		}
	}
}
import flash.display.MovieClip;

internal class Boots{
	public function Boots(char:MovieClip, left:MovieClip, right:MovieClip){
		
	}
}
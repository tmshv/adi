package ru.gotoandstop.adi.skills{
	import adiwars.clips.SkillItemHintClip;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.user.SkillItem;
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SkillHint extends Sprite{
		private static var _inst:SkillHint;
		public static function get instance():SkillHint{
			if(!SkillHint._inst){
				SkillHint._inst = new SkillHint();
			}
			return SkillHint._inst;
		}
		
		private var clip:SkillItemHintClip;
		private var context:Context;
		
		private var timeToHideID:uint;
		private var startShowTime:uint;
		private const MIN_SHOW_TIME:uint = 1000;
		private const LONG_SHOW_TIME:uint = 20000;
		
		public function SkillHint(){
			super();
		}
		
		public function init(clip:SkillItemHintClip, context:Context):void{
			this.context = context;
			this.clip = clip;
			this.clip.mouseEnabled = false;
			this.clip.mouseChildren = false;
			this.clip.alpha = 0;//.3;
		}
		
		public function show(item:SkillItem, coord:Point):void{
			this.setInfo(item);
			
			this.clip.x = coord.x;
			this.clip.y = coord.y;
			//this.clip.alpha = 1;
			this.tweenToShow();
			this.startShowTime = getTimer();
			this.hideAfter(this.LONG_SHOW_TIME);
		}
		
		public function hide():void{
			var difference_between_show_and_hide:uint = getTimer() - this.startShowTime;
			if(difference_between_show_and_hide < this.MIN_SHOW_TIME){
				this.hideAfter(difference_between_show_and_hide);
			}else{
				this.tweenToHide();	
			}
		}
		
		private function hideAfter(time:uint):void{
			clearTimeout(this.timeToHideID);
			this.timeToHideID = setTimeout(this.hide, time);
		}
		
		private function tweenToShow():void{
			Tweener.addTween(this.clip, {alpha:1, time:0.1, transition:'easeInSine'});
		}
		
		private function tweenToHide():void{
			Tweener.addTween(this.clip, {alpha:0, time:0.5, transition:'easeInSine'});
		}
		
		private function setInfo(item:SkillItem):void{
			//var title:String = '//'Навык “”'; 
			var title:String = 'Навык "<skill>"';
			title = title.replace(/<skill>/, item.title);
			
			this.clip.title.text = title;
			this.clip.description.text = item.description;
			
			var ava:DisplayObject = this.context.getResourceClip(item.image);
			if(ava) this.clip.avatar.point.addChild(ava);
		}
	}
}
package ru.gotoandstop.adi.inventory{
	import ru.gotoandstop.adi.GoodsItem;
	import adiwars.clips.ShopItemInfoClilp;
	import ru.gotoandstop.adi.core.Context;
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ItemHint{
		private static var _inst:ItemHint;
		public static function get instance():ItemHint{
			if(!ItemHint._inst){
				ItemHint._inst = new ItemHint();
			}
			return ItemHint._inst;
		}
		
		private var clip:ShopItemInfoClilp;
		private var context:Context;
		
		private var timeToHideID:uint;
		private var startShowTime:uint;
		private const MIN_SHOW_TIME:uint = 1000;
		private const LONG_SHOW_TIME:uint = 20000;
		
		public function ItemHint(){
			super();
		}
		
		public function init(clip:ShopItemInfoClilp, context:Context):void{
			this.context = context;
			this.clip = clip;
			this.clip.mouseEnabled = false;
			this.clip.mouseChildren = false;
			this.clip.alpha = 0;//.3;
		}
		
		public function show(item:GoodsItem, coord:Point):void{
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
		
		private function setInfo(item:GoodsItem):void{
			this.clip.title.text = item.title;
			this.clip.cost.text = item.cost.toString();
			this.clip.level.text = item.level.toString();
			this.clip.damage.text = '0';
			this.clip.description.text = item.description;
			
			var icon:DisplayObject = Context.inst.getResourceClip(item.image);
			this.clip.ava.addChild(icon);
		}
	}
}
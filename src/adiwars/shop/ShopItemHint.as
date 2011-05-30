package adiwars.shop{
	import adiwars.GoodsItem;
	import adiwars.clips.ShopItemInfoClilp;
	import adiwars.core.Context;
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ShopItemHint extends Sprite{
		private static var inst:ShopItemHint;
		public static function get():ShopItemHint{
			if(!ShopItemHint.inst){
				ShopItemHint.inst = new ShopItemHint();
			}
			return ShopItemHint.inst;
		}
		
		private var clip:ShopItemInfoClilp;
		private var hideTimeout:uint;
		
		public function ShopItemHint(){
			super();
		}
		
		public function init(clip:ShopItemInfoClilp):void{
			this.clip = clip;
			this.clip.mouseEnabled = false;
			this.clip.alpha = 0;
		}
		
		public function show(item:GoodsItem, coords:Point):void{
			this.setInfo(item);
			
			clearTimeout(this.hideTimeout);
			this.clip.alpha = 1;
			this.hideTimeout = setTimeout(this.hide, 2000);
			
			var offset:Point = new Point(-70, -35);
			var pos:Point = new Point(coords.x+offset.x, coords.y+offset.y);
			Tweener.addTween(this.clip, {x:pos.x, y:pos.y, time:0.3, transition:'easeInSine'});
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
		
		private function hide():void{
			Tweener.removeTweens(this.clip);
			Tweener.addTween(this.clip, {alpha:0, time:0.3, transition:'easeInSine'});
		}
	}
}
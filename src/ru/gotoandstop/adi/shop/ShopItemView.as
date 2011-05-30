package ru.gotoandstop.adi.shop{
	import ru.gotoandstop.adi.GoodsItem;
	import adiwars.clips.ShopItemClip;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.mvc.BaseController;
	import ru.gotoandstop.adi.informers.ShowButtonController;
	import ru.gotoandstop.adi.ui.GameItem;
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	[Event(name="select", type="flash.display.Event")]
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ShopItemView extends GameItem{
		private var clip:ShopItemClip;
		private var item:GoodsItem;
		public var name:String;
		
		private var available:Boolean;
		private var intervalID:uint;
		
		public function ShopItemView(container:DisplayObjectContainer, context:Context, item:GoodsItem){
			super(container, context);
			this.item = item;
			this.init();
		}
		
		public function destroy():void{
			this.clip.removeEventListener(MouseEvent.CLICK, this.handleClick);
			this.clip.removeEventListener(MouseEvent.MOUSE_OVER, this.handleOver);
			this.clip.removeEventListener(MouseEvent.MOUSE_OUT, this.handleOut);
			super.context.owner.model.removeEventListener(Event.COMPLETE, this.handleOwnerChange);
		}
		
		private function init():void{
			super.context.owner.model.addEventListener(Event.COMPLETE, this.handleOwnerChange);
			
			this.clip = new ShopItemClip();
			this.clip.avatar.addChild(super.context.getResourceClip(this.item.image));
			this.clip.addEventListener(MouseEvent.CLICK, this.handleClick);
			this.clip.addEventListener(MouseEvent.MOUSE_OVER, this.handleOver);
			this.clip.addEventListener(MouseEvent.MOUSE_OUT, this.handleOut); 
			super.container.addChild(this.clip);
			
			this.name = this.item.name;
			this.clip.title.autoSize = TextFieldAutoSize.LEFT;
			this.clip.title.text = this.item.title;
			this.clip.title.y -= this.clip.title.height/2;
			this.clip.cost.field.text = this.item.cost.toString();
			
			this.showCurrentState();
		}
		
		private function handleOwnerChange(event:Event):void{
			this.showCurrentState();
		}
		
		private function showCurrentState():void{
			var user_money:uint = super.context.owner.model.money;
			var user_level:uint = super.context.owner.model.level;
			var item_cost:uint = this.item.cost;
			var item_level:uint = this.item.level;
			
			var enough_level:Boolean = user_level >= item_level;
			var enough_money:Boolean = user_money >= item_cost;
			var already_have:Boolean = super.context.owner.hasGoods(this.item.name);
			
			this.available = enough_level && enough_money && !already_have;
//			if(!this.available) this.lock();
//			else this.clip.gotoAndStop('default');
			
			this.displayDefault();
			if(!enough_money) this.displayNotEnoughMoney();
			if(!enough_level) this.displayNotEnoughLevel();			
			if(already_have) this.displayAlreadyHave();
		}
		
		private function handleClick(event:MouseEvent):void{
			if(this.available){
				this.displaySelect();
				super.dispatchEvent(new Event(Event.SELECT));
			}
		}
		
		private function handleOver(event:MouseEvent):void{
			this.clearHintTimeout();
			var show:Function = ShopItemHint.get().show;
			var pos:Point = this.clip.localToGlobal(new Point());
			this.intervalID = setTimeout(show, 1000, this.item, pos);
		}
		
		private function handleOut(event:MouseEvent):void{
			this.clearHintTimeout();
		}
		
		private function clearHintTimeout():void{
			clearTimeout(this.intervalID);
		}
		
		public override function lightOn():void{
			super.lightOn();
			this.clip.gotoAndStop('selected');
		}
		
		public override function lightOff():void{
			super.lightOff();
			this.clip.gotoAndStop('default');
		}
		
		private function displayNotEnoughMoney():void{
			this.clip.cost.visible = true;
			this.clip.avatar.filters = [new BlurFilter(3, 3, 2)];
		}
		
		private function displayNotEnoughLevel():void{
			this.clip.cost.visible = false;
			this.clip.avatar.filters = [new BlurFilter(5, 5, 2), this.getGrayColorFilter()];
		}
		
		private function displayAlreadyHave():void{
			this.clip.cost.visible = false;
			this.clip.avatar.filters = [this.getGrayColorFilter()];
		}
		
		private function displaySelect():void{
			this.clip.cost.visible = true;
			this.lightOn();
		}
		
		private function displayDefault():void{
			this.clip.cost.visible = true;
			this.lightOff();
		}
		
		public function lock():void{
			//this.clip.avatar.filters = [new BlurFilter(5, 5, 2)];
			//this.clip.gotoAndStop('unavailable');
			//Tweener.removeTweens(button);
			//Tweener.addTween(button, {_Glow_blurX:amount * 10, _Glow_blurY:amount * 10, _Glow_strength:amount * 5, time:.5});
		}
		
		private function getGrayColorFilter():ColorMatrixFilter{
			const value:Number = 0.6;
			return new ColorMatrixFilter([
				0, 0, value, 0, 0,
				0, 0, value, 0, 0,
				0, 0, value, 0, 0,
				0, 0, value, .65, 0
			]);
		}
	}
}
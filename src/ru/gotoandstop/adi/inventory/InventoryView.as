package ru.gotoandstop.adi.inventory{
	import ru.gotoandstop.adi.ITemp;
	import adiwars.clips.InventoryClip;
	import ru.gotoandstop.adi.command.Invoker;
	import ru.gotoandstop.adi.shop.ShopItemHint;
	import ru.gotoandstop.adi.ui.ItemContainer;
	import ru.gotoandstop.adi.ui.PrevNextInfoController;
	import ru.gotoandstop.adi.ui.SliderButtonsController;
	import ru.gotoandstop.adi.user.Goods;
	import ru.gotoandstop.adi.values.IntValue2;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class InventoryView extends Sprite{
		private var step:uint;
		public var container:ItemContainer;
		public var clip:InventoryClip;
		
		private var current:IntValue2;
		private var total:IntValue2;
		private var controller:PrevNextInfoController;
		private var dic:Dictionary;
		private var informers:Vector.<ITemp>;
		
		public function InventoryView(char:DisplayObject, step:uint, suite:Goods){
			this.step = step;
			this.informers = new Vector.<ITemp>();
			
			this.dic = new Dictionary();
			this.clip = new InventoryClip();
			super.addChild(this.clip);
			
			var weared:WearedItemContainer = new WearedItemContainer(
				suite, 
				this.clip.weared.weapon,
				this.clip.weared.jacket,
				this.clip.weared.pants,
				this.clip.weared.boots
			);
			
			this.clip.avatar.addChild(char);
			
			this.container = new ItemContainer(3, 3);
			this.container.setLayout('vercital', 320, new Point(80, 80), 'easeInSine');
			this.clip.goodsPoint.addChild(this.container);
			
			this.current = new IntValue2();
			this.total = new IntValue2();
			this.controller = new PrevNextInfoController(this.clip.goodsUpButton, this.clip.goodsDownButton, this.clip.goodsPageField);
			this.controller.init(this.container.current, this.container.total);
			
			this.addInformer(weared);
		}
		
		public function configureSlideButtons(controller:SliderButtonsController):void{
			controller.init(this.clip.goodsDownButton, this.clip.goodsUpButton, this.clip.goodsPageField);
		}
		
		public function initCharParamsController(si:Invoker, sd:Invoker, agi:Invoker, agd:Invoker, aci:Invoker, acd:Invoker):void{
			this.createLine(this.clip.sButton, si, sd);
			this.createLine(this.clip.agButton, agi, agd);
			this.createLine(this.clip.accButton, aci, acd);
		}
		
		private function dispose():void{
			this.disposeInformers();
			
			this.removeLine(this.clip.sButton);
			this.removeLine(this.clip.agButton);
			this.removeLine(this.clip.accButton);
		}
		
		private function createLine(bu:*, p:Invoker, m:Invoker):void{
			bu.m.visible = false;
			bu.x -= 10;
			
			this.createButton(bu.p, p);
			this.createButton(bu.m, m);
		}
		
		private function removeLine(bu:*):void{
			this.deleteButton(bu.p);
			this.deleteButton(bu.m);
		}
		
		private function createButton(target:IEventDispatcher, action:Invoker):void{
			this.dic[target] = action;
			target.addEventListener(MouseEvent.CLICK, this.handleButton);
		}
		
		private function deleteButton(target:IEventDispatcher):void{
			this.dic[target] = null;
			target.removeEventListener(MouseEvent.CLICK, this.handleButton);
		}
		
		private function handleButton(event:MouseEvent):void{
			var command:Invoker = this.dic[event.currentTarget] as Invoker;
			if(command){
				command.executeCommand();
			}
		}
		
		public override function addChild(child:DisplayObject):DisplayObject{
			child.y = this.container.numChildren * this.step;
			return this.container.addChild(child);
		}
		
		public function clear():void{
			while(this.container.numChildren) this.container.removeChildAt(0);
		}
		
		public function addInformer(i:ITemp):void{
			this.informers.push(i);
		}
		
		private function disposeInformers():void{
			for each(var i:ITemp in this.informers){
				i.dispose();
			}
			this.informers = new Vector.<ITemp>();
		}
	}
}
package adiwars.dialogs{	
	import adiwars.GoodsItem;
	import adiwars.ITemp;
	import adiwars.clips.ShopDialogClip;
	import adiwars.core.Context;
	import adiwars.shop.ShopItemHint;
	import adiwars.shop.ShopItemView;
	import adiwars.ui.ButtonController;
	import adiwars.ui.GroupController;
	import adiwars.ui.ItemContainer;
	import adiwars.ui.PrevNextInfoController;
	import adiwars.ui.UICommandEvent;
	import adiwars.values.IntValue;
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	import remote.RemoteEvent;
	import remote.RemoteRequest;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ShopDialog extends Dialog{
		private const STEP_X:uint = 113;
		private const STEP_Y:uint = 148;
		
		private var temps:Vector.<ITemp>;
		
		private var itemsContainer:ItemContainer;
		private var view:ShopDialogClip;
		private var controller:PrevNextInfoController;
		
		private var currentContainer:ItemContainer;
		private var suiteContainer:ItemContainer;
		private var weaponContainer:ItemContainer;
		
		private var currentPage:IntValue;
		private var pagesNumber:IntValue;
		
		private var type:String;
		
		private var _selectedItem:ShopItemView;
		private function get selectedItem():ShopItemView{
			return this._selectedItem;
		}
		private function set selectedItem(value:ShopItemView):void{
			this._selectedItem = value;
			this.updateBuyButton();
		}

		private var items:Vector.<ShopItemView>;
		
		private var buttons:GroupController;
		
		public function ShopDialog(context:Context){
			super(context);
			this.view = new ShopDialogClip();
			this.view.x = -730;
			super.container.addChild(this.view);
			this.createListeners();
			
			ShopItemHint.get().init(this.view.itemInfo);
			
			this.currentPage = new IntValue();
			this.pagesNumber = new IntValue();
			
			this.controller = new PrevNextInfoController(this.view.prevPageButton, this.view.nextPageButton, this.view.pageField);
			this.controller.init(this.currentPage, this.pagesNumber);
			
			this.buttons = new GroupController(this.view.suiteButton, this.view.weaponButton);
			this.temps = new Vector.<ITemp>();
			this.temps.push(new ButtonController(this.view.suiteButton, this.view.suiteButtonOver));
			this.temps.push(new ButtonController(this.view.weaponButton, this.view.weaponButtonOver));
			this.temps.push(this.buttons);
			
			this.init();
			Tweener.addTween(this.view, {time:0.8, x:0, transition:'easeOutElastic'});
		}
		
		private function init():void{
			const col:uint = 5;
			const row:uint = 2;
			
			var hor_tween:String = 'easeInSine';
			var ver_tween:String = 'easeOutBack';
			
			this.suiteContainer = new ItemContainer(row, col);
			this.suiteContainer.setLayout('horizontal', this.STEP_X*col, new Point(this.STEP_X, this.STEP_Y), hor_tween);
			
			this.weaponContainer = new ItemContainer(row, col);
			this.weaponContainer.setLayout('horizontal', this.STEP_X*col, new Point(this.STEP_X, this.STEP_Y), hor_tween);
			
			this.itemsContainer = new ItemContainer(2, 1);
			this.itemsContainer.setLayout('vertical', this.STEP_Y*row*1.5, new Point(0, this.STEP_Y*row*1.5), ver_tween);
			this.itemsContainer.addChild(this.suiteContainer);
			this.itemsContainer.addChild(this.weaponContainer);
			
			this.view.items.addChild(this.itemsContainer);
			this.disable();
			this.updateItems();
		}
		
		private function updateItems():void{
			var r:RemoteRequest = new RemoteRequest();
			r.addEventListener(RemoteEvent.COMPLETE, this.handleComplete);
			r.getItems();
		}
		
		private function handleComplete(event:RemoteEvent):void{
			var items:XML = event.response;
			var owned_items:XMLList = items.item.(@owned==1);
			var owned_names:Vector.<String> = new Vector.<String>();
			for each(var owned:XML in owned_items) owned_names.push(owned.@name);
			super.context.owner.refreshGoods(owned_names);
			
			this.fill();
			this.toSuites(true);//ype = 'suite';
		}
		
		/**
		 * Создает вьюшки твоаров 
		 */
		private function fill():void{
			this.items = new Vector.<ShopItemView>();
			var list:Vector.<GoodsItem> = super.context.getGoodiesList();
			
			for each(var item:GoodsItem in list){
				var is_suite:Boolean = item.type == 'suite';
				var cont:DisplayObjectContainer = is_suite ? this.suiteContainer : this.weaponContainer;
				
				this.createItem(new ShopItemView(cont, super.context, item));
			}
		}
		
		private function createItem(item:ShopItemView):void{
			item.addEventListener(Event.SELECT, this.handleItemSelect);
			this.items.push(item);
		}
		
		private function destroyItems():void{
			for each(var item:ShopItemView in this.items){
				item.destroy();
				item.removeEventListener(Event.SELECT, this.handleItemSelect);
			}
		}
		
		private function updateBuyButton():void{
			if(this.selectedItem){
				this.view.buyButton.filters = [];
				this.view.buyButton.mouseEnabled = true;
			}else{
				const value:Number = 0.6;
				this.view.buyButton.filters = [new ColorMatrixFilter([
					0, 0, value, 0, 0,
					0, 0, value, 0, 0,
					0, 0, value, 0, 0,
					0, 0, value, .65, 0
				])];
				this.view.buyButton.mouseEnabled = false;
			}
		}
		
		public override function close():void{
			super.close();
			
			for each(var temp:ITemp in this.temps){
				temp.dispose();
			}
			
			this.destroyListeners();
			Tweener.addTween(this.view, {time:0.4, x:-730, rotation:0, transition:'easeInQuad', onComplete: this.onHideComplete});
		}
		
		private function onHideComplete():void{
			super.container.removeChild(this.view);
		}
		
		private function createListeners():void{
			this.view.buyButton.addEventListener(MouseEvent.CLICK, this.handleBuyButton);
			this.view.closeButton.addEventListener(MouseEvent.CLICK, this.handleClose);
			this.view.nextPageButton.addEventListener(MouseEvent.CLICK, this.handleNext);
			this.view.prevPageButton.addEventListener(MouseEvent.CLICK, this.handlePrev);
			this.view.suiteButton.addEventListener(MouseEvent.CLICK, this.handleSuite);
			this.view.weaponButton.addEventListener(MouseEvent.CLICK, this.handleWeapon);
		}
		
		private function destroyListeners():void{
			this.view.buyButton.removeEventListener(MouseEvent.CLICK, this.handleBuyButton);
			this.view.closeButton.removeEventListener(MouseEvent.CLICK, this.handleClose);
			this.view.nextPageButton.removeEventListener(MouseEvent.CLICK, this.handleNext);
			this.view.prevPageButton.removeEventListener(MouseEvent.CLICK, this.handlePrev);
			this.view.suiteButton.removeEventListener(MouseEvent.CLICK, this.handleSuite);
			this.view.weaponButton.removeEventListener(MouseEvent.CLICK, this.handleWeapon);
		}
		
		private function handleClose(event:MouseEvent):void{
			super.dispatchEvent(UICommandEvent.command('close'));
			this.destroyListeners();
		}
		
		private function handleSuite(event:MouseEvent):void{
			this.toSuites();
		}
		
		private function handleWeapon(event:MouseEvent):void{
			this.toWeapons();
		}
		
		private function handleNext(event:MouseEvent):void{
			if(this.currentPage.value < this.pagesNumber.value){
				this.currentPage.value ++;//increase();
//				this.currentContainer.currentPage ++;
				this.currentContainer.next();
			}
		}
		
		private function handlePrev(event:MouseEvent):void{
			if(this.currentPage.value > 0){
				this.currentPage.value --;//decrease();
//				this.currentContainer.currentPage --;
				this.currentContainer.prev();
			}
		}
		
		private function handleBuyButton(event:MouseEvent):void{
			var request:RemoteRequest = this.createBuy();
			request.buy(this.selectedItem.name);
		}
		
		private function createBuy():RemoteRequest{
			var request:RemoteRequest = new RemoteRequest();
			request.addEventListener(RemoteEvent.COMPLETE, this.handleBuy);
			request.addEventListener(RemoteEvent.ERROR, this.handleBuyError);
			return request;
		}
		
		private function destroyBuy(request:RemoteRequest):void{
			request.removeEventListener(RemoteEvent.COMPLETE, this.handleBuy);
			request.removeEventListener(RemoteEvent.ERROR, this.handleBuyError);
		}
		
		private function handleBuy(event:RemoteEvent):void{
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyBuy(request);
			
//			<shop>
//				<item id="1338931" money="1120" success="TRUE" item="202"/>
//			  </shop>
			
			//super.context.owner.a
			
			var new_money_value:uint = event.response.item.@money;
			super.context.owner.model.money = new_money_value;
			
			trace('after buying you have', new_money_value);
			trace(event.response) 
			
			this.handleClose(null);
		}
		
		private function handleBuyError(event:RemoteEvent):void{
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyBuy(request);
			
			trace(event)
		}
		
		private function toWeapons(justUpdate:Boolean=false):void{
			if(!justUpdate && this.type == 'weapon') return;
			this.type = 'weapon';
			
			trace(this.currentContainer.saved, this.currentContainer.current.value)
			
			if(currentContainer) this.currentContainer.save();
			
			trace(this.currentContainer.saved)
			
			this.currentContainer = this.weaponContainer;
			this.pagesNumber.value = this.currentContainer.total.value;//pagesNumber);
			this.currentPage.value = this.currentContainer.saved;//current.value;
			
			this.buttons.select(this.view.weaponButton);
			
			if(!justUpdate) this.itemsContainer.next();
		}
		
		private function toSuites(justUpdate:Boolean=false):void{
			if(!justUpdate && this.type == 'suite') return;
			this.type = 'suite';
			
			trace(this.suiteContainer.current.value, this.suiteContainer.saved)
			
			if(currentContainer) this.currentContainer.save();
			
			this.currentContainer = this.suiteContainer;
			this.pagesNumber.value = this.currentContainer.total.value;//pagesNumber);
			this.currentPage.value = this.currentContainer.saved;//current.value;
			
			this.buttons.select(this.view.suiteButton);
			
			if(!justUpdate) this.itemsContainer.prev();
		}
		
		private function handleItemSelect(event:Event):void{
			const item:ShopItemView = event.target as ShopItemView;
			trace(item)
			if(this.selectedItem){
				this.selectedItem.lightOff();
			}
			this.selectedItem = item;
		}
	}
}
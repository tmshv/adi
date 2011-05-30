package adiwars.dialogs{
	import adiwars.ITemp;
	import adiwars.clips.BagDialogClip;
	import adiwars.core.Context;
	import adiwars.inventory.ItemHint;
	import adiwars.skills.SkillHint;
	import adiwars.states.AchivmentsState;
	import adiwars.states.InventoryState;
	import adiwars.states.Screen;
	import adiwars.states.ScreenSlider;
	import adiwars.states.SkillsState;
	import adiwars.ui.ButtonController;
	import adiwars.ui.GroupController;
	import adiwars.ui.UICommandEvent;
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import remote.RemoteEvent;
	import remote.RemoteRequest;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class InventoryDialog extends Dialog{
		private var view:BagDialogClip;
		private var temps:Vector.<ITemp>;
		private var stateMachine:ScreenSlider;
		
		private var buttons:GroupController;
		
		public function InventoryDialog(context:Context){
			super(context);
			this.view = new BagDialogClip();
			this.view.x = -700;
			super.container.addChild(this.view);
			
			this.buttons = new GroupController(this.view.invButton, this.view.achivButton, this.view.skillButton);
			
			this.temps = new Vector.<ITemp>();
			this.temps.push(new ButtonController(this.view.invButton, this.view.invButtonOver));
			this.temps.push(new ButtonController(this.view.achivButton, this.view.achivButtonOver));
			this.temps.push(new ButtonController(this.view.skillButton, this.view.skillButtonOver));
			this.temps.push(this.buttons);
			
			SkillHint.instance.init(this.view.skillHint, super.context);
			ItemHint.instance.init(this.view.itemHint, super.context);
			
			this.init();			
			Tweener.addTween(this.view, {time:0.8, x:0, transition:'easeOutElastic'});
		}
		
		private function init():void{
			this.stateMachine = new ScreenSlider(this.view.point, 600);
			this.stateMachine.register(new InventoryState(super.context));
			this.stateMachine.register(new AchivmentsState(super.context));
			this.stateMachine.register(new SkillsState(super.context));
			
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
			
			this.enable();
			this.switchToState('inv');
		}
		
		public override function disable():void{
			this.destroyListeners();
		}
		
		public override function enable():void{
			this.createListeners();
		}
		
		public override function close():void{
			super.close();
			for each(var temp:ITemp in this.temps){
				temp.dispose();
			}
			
			this.disable();
			Tweener.addTween(this.view, {time:0.4, x:-730, rotation:0, transition:'easeInQuad', onComplete: this.onHideComplete});
		}
		
		private function onHideComplete():void{
			super.container.removeChild(this.view);
		}
		
		private function createListeners():void{
			this.view.closeButton.addEventListener(MouseEvent.CLICK, this.handleClose);
			
			this.view.invButton.addEventListener(MouseEvent.CLICK, this.handleStateButtonClick);
			this.view.achivButton.addEventListener(MouseEvent.CLICK, this.handleStateButtonClick);
			this.view.skillButton.addEventListener(MouseEvent.CLICK, this.handleStateButtonClick);
		}
		
		private function destroyListeners():void{
			this.view.closeButton.removeEventListener(MouseEvent.CLICK, this.handleClose);
			
			this.view.invButton.removeEventListener(MouseEvent.CLICK, this.handleStateButtonClick);
			this.view.achivButton.removeEventListener(MouseEvent.CLICK, this.handleStateButtonClick);
			this.view.skillButton.removeEventListener(MouseEvent.CLICK, this.handleStateButtonClick);
		}
		
		private function handleStateButtonClick(event:MouseEvent):void{
			const button:DisplayObject = event.currentTarget as DisplayObject;
			var state:String;
			switch(button.name){
				case 'invButton':
					state = 'inv';
					break;
				
				case 'achivButton':
					state = 'achiv';
					break;
				
				case 'skillButton':
					state = 'skill';
					break;
			}
			this.switchToState(state);
		}
		
		private function switchToState(state:String):void{
			trace('bag to state', state)
			
			var button_name:String;
			switch(state){
				case 'inv':
					button_name = 'invButton';
					break;
				
				case 'achiv':
					button_name = 'achivButton';
					break;
				
				case 'skill':
					button_name = 'skillButton';
					break;
			}
			var btn:DisplayObject = this.view.getChildByName(button_name);
			this.buttons.select(btn);
			
			this.stateMachine.activateState(state);
		}
		
		private function handleClose(event:MouseEvent):void{
			super.dispatchEvent(UICommandEvent.command('close'));
			this.destroyListeners();
		}
	}
}
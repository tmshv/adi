package adiwars.dialogs{
	import adiwars.clips.InputDialogClip;
	import adiwars.core.Context;
	import adiwars.ui.UICommandEvent;
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	[Event(name="command", type="adiwars.UICommandEvent")]
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class InputDialog extends Dialog{
		private var view:InputDialogClip;
		
		public function InputDialog(title:String, context:Context){
			super(context);
			
			this.view = new InputDialogClip();
			this.view.cacheAsBitmap = true;
			this.view.x = -730;
			this.view.titlefield.text = title;
			
			super.container.addChild(this.view);
			this.createListeners();
			
			Tweener.addTween(this.view, {time:0.8, x:0, transition:'easeOutElastic'});
		}
		
		public override function close():void{
			super.close();
			this.destroyListeners();
			Tweener.addTween(this.view, {time:0.4, x:-730, rotation:0, transition:'easeInQuad', onComplete: this.onHideComplete});
		}
		
		private function onHideComplete():void{
			super.container.removeChild(this.view);
		}
		
		private function createListeners():void{
			this.view.closeButton.addEventListener(MouseEvent.CLICK, this.handleCancel);
			this.view.confirmButton.addEventListener(MouseEvent.CLICK, this.handleCancel);
		}
		
		private function destroyListeners():void{
			this.view.closeButton.removeEventListener(MouseEvent.CLICK, this.handleCancel);
			this.view.confirmButton.removeEventListener(MouseEvent.CLICK, this.handleCancel);
		}
		
		private function handleCancel(event:MouseEvent):void{
			super.dispatchEvent(UICommandEvent.command('close'));
			this.destroyListeners();
		}
		
		private function handleOk(event:MouseEvent):void{
			this.destroyListeners();
			super.dispatchEvent(UICommandEvent.command('confirm'));
		}
	}
}
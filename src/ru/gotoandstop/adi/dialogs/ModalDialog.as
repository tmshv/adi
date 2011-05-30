package ru.gotoandstop.adi.dialogs{
	import adiwars.clips.ModalDialogClip;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.ui.UICommandEvent;
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ModalDialog extends Dialog{
		private var view:ModalDialogClip;
		
		public function ModalDialog(context:Context, content:IDialogContent, title:String){
			super(context);
			var layout:DisplayObject = content.getLayout();
			content.setDialog(this);
			
			this.view = new ModalDialogClip();
			this.view.cacheAsBitmap = true;
			this.view.x -= 700;
			
			this.view.titlefield.text = title;
			if(layout) this.view.content.addChild(layout);
			
			super.container.addChild(this.view);
			this.createListeners();
			Tweener.addTween(this.view, {time:0.8, x:0, transition:'easeOutElastic'});
		}
		
		public override function close():void{
			super.close();
			this.destroyListeners();
			
			trace('modal dialog must be closed')
			
			
			Tweener.addTween(this.view, {time:0.4, x:-700, rotation:0, transition:'easeInQuad', onComplete: this.onHideComplete});
		}
		
		private function onHideComplete():void{
			super.container.removeChild(this.view);
		}
		
		private function createListeners():void{
			this.view.done.addEventListener(MouseEvent.CLICK, this.handleConfirm);
		}
		
		private function destroyListeners():void{
			this.view.done.removeEventListener(MouseEvent.CLICK, this.handleConfirm);
		}
		
		private function handleConfirm(event:MouseEvent):void{
			this.destroyListeners();
			super.dispatchEvent(UICommandEvent.command('confirm'));
		}
	}
}
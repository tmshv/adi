package adiwars.dialogs{
	import adiwars.clips.BattleLoseClip;
	import adiwars.core.Context;
	import adiwars.ui.UICommandEvent;
	
	import caurina.transitions.Tweener;
	
	import flash.events.MouseEvent;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class LoseDialog extends Dialog{
		private var view:BattleLoseClip;
		
		public function LoseDialog(money:uint, experience:uint, context:Context){
			super(context);
			
			this.view = new BattleLoseClip();
			this.view.cacheAsBitmap = true;
			this.view.x -= 730;
			
			this.view.expField.text = experience.toString();
			this.view.moneyField.text = money.toString();
			
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
			this.view.confirmButton.addEventListener(MouseEvent.CLICK, this.handleConfirm);
		}
		
		private function destroyListeners():void{
			this.view.confirmButton.removeEventListener(MouseEvent.CLICK, this.handleConfirm);
		}
		
		private function handleConfirm(event:MouseEvent):void{
			this.destroyListeners();
			super.dispatchEvent(UICommandEvent.command('confirm'));
		}
	}
}
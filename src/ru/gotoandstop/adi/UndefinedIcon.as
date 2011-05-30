package ru.gotoandstop.adi{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class UndefinedIcon extends Sprite{
		private var image:BitmapData;
		
		public function UndefinedIcon(width:uint=100, height:uint=100){
			super();
			this.image = new BitmapData(width, height, false, 0x000000);
			super.addChild(new Bitmap(this.image));
			super.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			super.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
			this.noise();
		}
		
		private function handleEnterFrame(event:Event):void{
			this.noise();
		}
		
		private function handleRemovedFromStage(event:Event):void{
			super.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			super.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
			this.image.dispose();
		}
		
		private function noise():void{
			this.image.noise(Math.random()*10000, 100, 150, 7, true);
		}
	}
}
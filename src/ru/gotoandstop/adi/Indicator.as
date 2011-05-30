package ru.gotoandstop.adi{
	import adiwars.clips.AdiwarsPreloadImage;
	import adiwars.clips.PreloadLogo;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Indicator extends Sprite{
		private const MAX:uint = 100;
		
		private var image:AdiwarsPreloadImage;
		private var indicator:MovieClip;
		
		private var target:IEventDispatcher;
		
		public function Indicator(){
			FilterShortcuts.init();
			
			this.image = new AdiwarsPreloadImage();
			//this.image = new Sprite();
			this.image.graphics.beginFill(0xff00ff);
			this.image.graphics.drawRect(0, 0, 700, 600);
			
			super.addChild(this.image);
			this.blurOut(0);
			
			this.indicator = new PreloadLogo();
			this.indicator.x = 350;
			this.indicator.y = 300;
			this.indicator.stop();
			super.addChild(this.indicator);
		}
		
		public function indicate(ratio:Number):void{			
			var max:uint = this.indicator.totalFrames;
			var value:uint = (max * ratio);
			this.indicator.gotoAndStop(value);
			
			this.blurOut(ratio);
		}
		
		private function blurOut(ratio:Number):void{
			var value:Number = this.MAX - (this.MAX * ratio);
			Tweener.removeTweens(this.image.clip);
			Tweener.addTween(this.image.clip, {_Blur_blurX:value, _Blur_blurY:value, time:.5});
		}
		
		public function setTarget(target:IEventDispatcher):void{
			this.removeTarget();
			this.target = target;
			this.target.addEventListener(ProgressEvent.PROGRESS, this.handleProgress);
			this.indicate(0);
		}
		
		private function removeTarget():void{
			if(this.target){
				this.target.removeEventListener(ProgressEvent.PROGRESS, this.handleProgress);
			}
		}
		
		private function handleProgress(event:ProgressEvent):void{
			this.indicate(event.bytesLoaded / event.bytesTotal);
		}
	}
}
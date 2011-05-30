package adiwars.battle{
	import adiwars.ITemp;
	import adiwars.character.Char;
	import adiwars.character.events.CharEvent;
	import adiwars.clips.CritBubble;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class CritEmmiter implements ITemp{
		private var char:Char;
		private var source:DisplayObjectContainer
		
		public function CritEmmiter(char:Char, source:DisplayObjectContainer){
			this.char = char;
			this.source = source;
			this.char.addEventListener(CharEvent.DO_ACTION, this.handleDoAction);
		}
		
		public function dispose():void{
			this.char.removeEventListener(CharEvent.DO_ACTION, this.handleDoAction);
		}
		
		private function handleDoAction(event:CharEvent):void{
			if(event.animation == 'crit'){
				this.flowBubble(new CritBubble());
			}
		}
		
		private function flowBubble(bubble:DisplayObject):void{
			bubble.addEventListener(Event.ENTER_FRAME, this.handleBubbleEnterFrame);
			this.source.addChild(bubble);
		}
		
		private function handleBubbleEnterFrame(event:Event):void{
			var bubble:MovieClip = event.target as MovieClip;
			if(bubble.currentFrame == bubble.totalFrames){
				this.removeBubble(bubble);
			}
		}
		
		private function removeBubble(bubble:DisplayObject):void{
			bubble.removeEventListener(Event.ENTER_FRAME, this.handleBubbleEnterFrame);
			if(this.source.contains(bubble)){
				this.source.removeChild(bubble);
			}
		}
	}
}
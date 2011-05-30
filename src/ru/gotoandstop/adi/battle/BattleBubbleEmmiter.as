package ru.gotoandstop.adi.battle{
	import ru.gotoandstop.adi.ITemp;
	import ru.gotoandstop.adi.character.Char;
	import ru.gotoandstop.adi.character.events.CharEvent;
	import adiwars.clips.ActionBubble;
	import adiwars.clips.DamageBubble;
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class BattleBubbleEmmiter implements ITemp{
		private var char:Char;
		private var source:DisplayObjectContainer
		
		public function BattleBubbleEmmiter(char:Char, source:DisplayObjectContainer){
			this.char = char;
			this.source = source;
			this.char.addEventListener(CharEvent.DO_ACTION, this.handleDoAction);
			this.char.addEventListener(CharEvent.DAMAGE, this.handleDamage);
		}
		
		public function dispose():void{
			this.char.removeEventListener(CharEvent.DO_ACTION, this.handleDoAction);
			this.char.removeEventListener(CharEvent.DAMAGE, this.handleDamage);
		}
		
		private function handleDoAction(event:CharEvent):void{
			trace(event.animation)
			
			var text:String = this.getTextForAction(event.animation);
			if(text) this.flowBubble(this.getAction(text), 100);
		}
		
		private function handleDamage(event:CharEvent):void{
			var old:uint = this.char.model.lastHealthValue;
			var cur:uint = this.char.model.currentHealth;
			var value:uint = old - cur;
			
			if(value) this.flowBubble(this.getDamage(value.toString()), 200);
		}
		
		private function getDamage(message:String):DisplayObject{
			var bubble:DamageBubble = new DamageBubble();
			bubble.field.text = message;
			return bubble;
		}
		
		private function getAction(message:String):DisplayObject{
			var bubble:ActionBubble = new ActionBubble();
			bubble.field.text = message;
			return bubble;
		}
		
		private function flowBubble(bubble:DisplayObject, distance:uint):void{
			this.source.addChild(bubble);
			
			Tweener.addTween(bubble, {y: -distance, alpha: 0, time: 3, transition:'easeIsQuad', onComplete:this.onTweenComplete});
		}
		
		private function onTweenComplete():void{
			while(this.source.numChildren) this.source.removeChildAt(0);
		}
		
		private function getTextForAction(action:String):String{
			var value:String;
			switch(action){
				case 'poison':
					value = 'отравление';
					break;
				
				case 'poison':
					value = 'отравление';
					break;
				
				case 'rage':
					value = 'ярость';
					break;
				
				case 'dodge':
					value = 'уворот';
					break;
				
				case 'poison':
					value = 'отравление';
					break;
				
				case 'starofdeath':
					value = 'звезда смерти';
					break;
			}
			
			return value;
		}
	}
}
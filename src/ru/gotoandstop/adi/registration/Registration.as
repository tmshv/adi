package ru.gotoandstop.adi.registration{
	import ru.gotoandstop.adi.character.CharType;
	import adiwars.clips.RegistrationStateClip;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.setTimeout;
	
	/**
	 *
	 * @author Roman Timashev
	 */
	public class Registration extends Sprite{
		private var selectedChar:Sprite;
		private var view:RegistrationStateClip;
		
		private const SELECTED_AMOUNT:Number = 1;
		private const OVERED_AMOUNT:Number = .5;
		
		public var confirmButton:InteractiveObject;
		
		public function Registration(){
			var log:RegistrationStateClip = new RegistrationStateClip();
			super.addChild(log);
			
			FilterShortcuts.init();
			
			this.confirmButton = log.characterName.done;
			
			this.createButton(log.btnVader);
			this.createButton(log.btnLuke);
			this.createButton(log.btnLeia);
			this.createButton(log.btnChewbacca);
			
			setTimeout(this.select, 500, log.btnLuke);
			
			this.view = log;
			this.view.characterName.titlefield.text = 'Имя персонажа';
		}
		
		public function getSelectedChar():String{
			var type:String;
			switch(this.selectedChar.name){
				case 'btnVader':
					type = CharType.VADER;
					break;
				
				case 'btnLuke':
					type = CharType.LUKE;
					break;
				
				case 'btnLeia':
					type = CharType.LEIA;
					break;
				
				case 'btnChewbacca':
					type = CharType.CHEWBACCA;
					break;
			}
			return type;
		}
		
		public function setName(value:String):void{
			this.view.characterName.input.field.text = value;
		}
		
		public function getTypedNick():String{
			return this.view.characterName.input.field.text;
		}
		
		private function createButton(button:Sprite):void{
			button.addEventListener(MouseEvent.MOUSE_OVER, this.handleCharButtonOver);
			button.addEventListener(MouseEvent.MOUSE_OUT, this.handleCharButtonOut);
			button.addEventListener(MouseEvent.CLICK, this.handleCharButtonClick);
		}
		
		private function handleCharButtonOver(event:MouseEvent):void{
			const button:Sprite = event.currentTarget as Sprite;
			
			if(button == this.selectedChar){
				
			}else{
				this.glow(button, this.OVERED_AMOUNT);
			}
		}
		
		private function handleCharButtonOut(event:MouseEvent):void{
			const button:Sprite = event.currentTarget as Sprite;
			
			if(button == this.selectedChar){
				this.glow(button, this.SELECTED_AMOUNT);
			}else{
				this.glow(button);
			}
		}
		
		private function handleCharButtonClick(event:MouseEvent):void{
			const button:Sprite = event.currentTarget as Sprite;
			this.select(button);
		}
		
		private function glow(button:Sprite, amount:Number=0):void{
			Tweener.removeTweens(button);
			Tweener.addTween(button, {_Glow_blurX:amount * 10, _Glow_blurY:amount * 10, _Glow_strength:amount * 5, time:.5});
		}
		
		private function select(button:Sprite):void{
			this.deselect();
			this.selectedChar = button;
			
			this.glow(button, this.SELECTED_AMOUNT);
		}
		
		private function deselect():void{
			if(this.selectedChar){
				this.glow(this.selectedChar);
			}
		}
	}
}
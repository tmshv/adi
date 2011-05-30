package adiwars.battle{
	import adiwars.character.Char;
	import adiwars.character.events.CharEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="complete", type="flash.events.Event")]

	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Timeline extends EventDispatcher{
		private var definition:BattleDefinition;
		
		private var user:Char;
		private var opponent:Char;
		
		private var userStepCompleted:Boolean;
		private var opponentStepCompleted:Boolean;
		
		public var userID:String = '1';
		public var opponentID:String = '2';
		
		private var currentStep:XML;
		
		public function Timeline(){
			
		}
		
		public function play(definition:BattleDefinition, chars:Vector.<Char>):void{
			this.definition = definition;
			
			this.user = chars[0];
			this.opponent = chars[1];
			
			this.createListenersForChar(this.user);
			this.createListenersForChar(this.opponent);
		}
		
		private function createListenersForChar(char:Char):void{
			char.addEventListener(CharEvent.ANIMATION_STATE, this.handleAnimationState);
			char.addEventListener(CharEvent.COMPLETE, this.handleActionComplete);
		}
		
		private function removeListenersForChar(char:Char):void{
			char.removeEventListener(CharEvent.ANIMATION_STATE, this.handleAnimationState);
			char.removeEventListener(CharEvent.COMPLETE, this.handleActionComplete);
		}
		
		private function executeAction(char:Char, action:String, damage:int=-1):void{
			char.doAction(action);
			if(damage >= 0) char.setDamage(damage);
		}
		
		private function handleAnimationState(event:CharEvent):void{
			var feeded_char:Char = this.getEnemyCharTo(event.target as Char);
			
			var feeded_char_id:String = feeded_char.definition.ownerID;
			var fighter:XML = this.currentStep.fighter.(@id == feeded_char_id)[0];
			var action:String = fighter.@action;
			var damage:String = fighter.@health;
			
			if(action == event.animation){
				this.executeAction(feeded_char, action, this.parseDamageFromXML(damage));
			}
		}
		
		private function handleActionComplete(event:CharEvent):void{
			const char:Char = event.target as Char;
			if(char == this.user){
				this.userStepCompleted = true;
			}else if(char == this.opponent){
				this.opponentStepCompleted = true;
			}
			
			if(this.userStepCompleted && this.opponentStepCompleted){
				//	trace('step is complete')
				this.nextStep();
			}
		}
		
		private function doStep(step:XML):void{
			//trace('do step')
			//trace(this.currentStep.toXMLString())
			
			var fighters:XMLList = this.currentStep..fighter;
			var first:XML = fighters[0];
			var first_char:Char = this.getCharByID(first.@id);
			
			//Определение условия окончания степа
			this.userStepCompleted = true;
			this.opponentStepCompleted = true;
			
			if(fighters.length() > 1){
				this.userStepCompleted = false;
				this.opponentStepCompleted = false;
			}else{
				if(first_char == this.user){
					this.userStepCompleted = false;
					this.opponentStepCompleted = true;
				}else{
					this.userStepCompleted = true;
					this.opponentStepCompleted = false;
				}
			}
			
			this.executeAction(this.getCharByID(first.@id), first.@action, this.parseDamageFromXML(first.@health));
		}
		
		private function nextStep():void{
			try{
				this.currentStep = this.definition.readStep();
				this.doStep(this.currentStep);
			}catch(error:Error){
				super.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function parseDamageFromXML(value:String):int{
			var damage:Number = parseFloat(value);
			if(!damage && value=='') damage = -1;
			
			return Math.ceil(damage);
		}
		
		private function getCharByID(id:String):Char{
			if(id == this.userID){
				return this.user;
			}else if(id == this.opponentID){
				return this.opponent;
			}else{
				return null;
			}
		}
		
		private function getCharByFighter(fighter:XML):Char{
			if(fighter.@id == this.userID){
				return this.user;
			}else if(fighter.@id == this.opponentID){
				return this.opponent;
			}else{
				return null;
			}
		}
		
		private function getEnemyCharByID(charID:String):Char{
			if(charID == this.opponentID){
				return this.getCharByID(this.userID);
			}else{
				return this.getCharByID(this.opponentID);
			}
		}
		
		private function getEnemyCharTo(char:Char):Char{
			if(char == this.opponent){
				return this.user;
			}else{
				return this.opponent;
			}
		}
	}
}
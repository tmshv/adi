package adiwars.battle{
	import adiwars.character.CharDefinition;
	import adiwars.core.Context;
	import adiwars.core.mvc.BaseModel;
	import adiwars.core.mvc.IModel;
	import adiwars.ui.GameItem;
	
	import flash.events.EventDispatcher;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class BattleDefinition extends EventDispatcher{
		public static function createByXML(definition:XML):BattleDefinition{
			var battle:BattleDefinition = new BattleDefinition();
			battle.setDefinition(definition);
			return battle;
		}
		
		private var definition:XML;
		
		private var _stepsNumber:uint;
		public function get stepsNumber():uint{
			return this._stepsNumber;
		}
		
		public var award:BattleAward;
		
		private var count:uint;
		
		public function BattleDefinition(){
			super();
		}
		
		public function getChars():Vector.<CharDefinition>{
			var result:Vector.<CharDefinition> = new Vector.<CharDefinition>();
			var chars:XMLList = this.definition..char;
			for each(var char:XML in chars){
				result.push(CharDefinition.createFromXML(char));
			}
			return result;
		}
		
		/**
		 * 
		 * @return 
		 * @throw step is undefined
		 */
		public function readStep():XML{
			//trace('battle definition read the step')
			
			var result:XML = this.definition..step[this.count];
			
			if(!result){
				throw new Error('step is undefined');
			}
			
			this.count ++;
			return result;
		}
		
		public function resetReading():void{
			this.count = 0;
		}
		
		private function setDefinition(definition:XML):void{
			var award:XML = definition..results[0];
			var level_up_value:uint = award.@lvlup;
			var level_up:Boolean = Boolean(level_up_value);
			this.award = new BattleAward(award.@money, award.@exp, award.@id, level_up, award.@newlvl, award.@newexp);
			if(level_up){
				this.award.skillPoints =  award.@skillpoints;
				this.award.paramsPoints = award.@parampoints;
			}
			
			this.definition = definition;
			var steps:XMLList = definition..step;
			this._stepsNumber = steps.length();
		}
		
		public override function toString():String{
			return this.definition ? this.definition.toXMLString() : null;
		}
	}
}
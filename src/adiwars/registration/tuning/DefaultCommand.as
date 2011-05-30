package adiwars.registration.tuning{
	import adiwars.command.ICommand;
	import adiwars.values.IntValue2;
	
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class DefaultCommand implements ICommand{
		private var objs:Array;
		
		public var availablePoints:uint;
		public var strength:uint;
		public var agility:uint;
		public var accuracy:uint;
		
		public function DefaultCommand(s:IntValue2, ag:IntValue2, acc:IntValue2, available:IntValue2, sv:uint, agv:uint, accv:uint, availablePoints:uint){
			this.objs = new Array(s, ag, acc, available);
			
			this.strength = sv;
			this.agility  = agv;
			this.accuracy = accv;
			this.availablePoints = availablePoints;
		}
		
		public function execute():void{
			this.setup(this.objs[0], this.strength);
			this.setup(this.objs[1], this.agility);
			this.setup(this.objs[2], this.accuracy);
			this.setup(this.objs[3], this.availablePoints);
		}
		
		private function setup(char:IntValue2, value:uint):void{
			char.setValue(value);
		}
	}
}
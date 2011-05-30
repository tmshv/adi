package adiwars.tuning{
	import adiwars.command.ICommand;
	import adiwars.values.IntValue2;
	
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class DecreaseCommand implements ICommand{
		private var receiver:IntValue2;
		private var available:IntValue2;
		
		public function DecreaseCommand(receiver:IntValue2, available:IntValue2){
			this.receiver = receiver;
			this.available = available;
		}
		
		public function execute():void{
			if(!this.receiver.isEmpty()){
				this.available.increase();
			}
			this.receiver.decrease();
		}
	}
}
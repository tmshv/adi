package adiwars.command{
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Invoker{
		private var command:ICommand;
		
		public function Invoker(command:ICommand){
			this.setCommand(command);
		}
		
		public function setCommand(command:ICommand):void{
			this.command = command;
		}
		
		public function executeCommand():void{
			this.command.execute();
		}
	}
}
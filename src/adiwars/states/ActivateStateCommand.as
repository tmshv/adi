package adiwars.states{
	import adiwars.command.ICommand;
	
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ActivateStateCommand implements ICommand{
		private var state:Screen;
		
		public function ActivateStateCommand(state:Screen){
			this.state = state;
		}
		
		public function execute():void{
			this.state.activate();
		}
	}
}
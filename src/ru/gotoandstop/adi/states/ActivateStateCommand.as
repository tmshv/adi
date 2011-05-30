package ru.gotoandstop.adi.states{
	import ru.gotoandstop.adi.command.ICommand;
	
	
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
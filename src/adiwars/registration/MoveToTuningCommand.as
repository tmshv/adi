package adiwars.registration{
	import adiwars.command.ICommand;
	import adiwars.states.Screen;
	import adiwars.states.ScreenSlider;
	import adiwars.values.StringValue;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class MoveToTuningCommand implements ICommand{
		private var t:StringValue;
		private var n:StringValue;
		private var s:Screen;
		
		public function MoveToTuningCommand(t:StringValue, n:StringValue, state:Screen){
			this.t = t;
			this.n = n;
			this.s = state;
		}
		
		public function execute():void{
			this.s.send(this.n.value, this.t.value);
			this.s.activate();
		}
	}
}
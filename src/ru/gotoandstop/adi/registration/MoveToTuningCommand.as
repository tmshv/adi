package ru.gotoandstop.adi.registration{
	import ru.gotoandstop.adi.command.ICommand;
	import ru.gotoandstop.adi.states.Screen;
	import ru.gotoandstop.adi.states.ScreenSlider;
	import ru.gotoandstop.adi.values.StringValue;
	
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
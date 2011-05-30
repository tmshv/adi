package adiwars.test{
	import adiwars.core.Context;
	import adiwars.states.ApplicationStateKey;
	import adiwars.states.ScreenSlider;
	import adiwars.states.TuneState;
	
	import flash.display.Sprite;
	
	[SWF(width=700, height=600, backgroundColor=0x000000, frameRate=50)]
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class InteractiveTune extends Sprite{
		public function InteractiveTune(){
			super();
			
			var c:Context = Context.create(null, new Sprite, new Sprite);
			
			var s:ScreenSlider = new ScreenSlider(this, 700);
			s.register(new TuneState(c));
			
			s.activateState(ApplicationStateKey.TUNE);
		}
	}
}
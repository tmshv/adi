package adiwars.user{
	import adiwars.informers.ValueInformer;
	import adiwars.values.IntValue2;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ExperienceInformer extends ValueInformer{
		public function ExperienceInformer(model:IntValue2, line:MovieClip, field:TextField)
		{
			super(model, line, field);
		}
	}
}
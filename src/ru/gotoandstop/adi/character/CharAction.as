package ru.gotoandstop.adi.character{
	/**
	 *
	 * @author Timashev Roman
	 */
	public class CharAction{
		public static const STAY:String = 'stay';
		public static const SHOT:String = 'shot';
		
		public static const STAB:String = 'stab';
		public static const DOUBLESTAB:String = 'doublepizda';
		public static const HIT:String = 'pizda';
		//public static const HIT:String = 'pizda';
		
		public static function parseSequence(sequence:String):Vector.<String>{
			var result:Vector.<String> = new Vector.<String>();
			var frames:Array = sequence.split(',');
			for each(var frame:String in frames){
				result.push(frame);
			}
			return result;
		}
		
		private var _action:String;
		
		public function CharAction(action:String){
			this._action = action;
			this.createTimeline();
		}
		
		private function createTimeline():void{
			
		}
	}
}
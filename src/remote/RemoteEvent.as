package remote{
	import flash.events.Event;
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class RemoteEvent extends Event{
		public static const COMPLETE:String = 'complete';
		public static const ERROR:String = 'error';
		
		private var _response:XML;
		public function get response():XML{
			return this._response;
		}
		
		public function RemoteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, response:XML=null){
			super(type, bubbles, cancelable);
			this._response = response;
		}
		
		public override function clone():Event{
			return new RemoteEvent(super.type, super.bubbles, super.cancelable, this.response);
		}
	}
}
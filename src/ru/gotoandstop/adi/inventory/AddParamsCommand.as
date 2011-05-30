package ru.gotoandstop.adi.inventory{
	import ru.gotoandstop.adi.command.IAsyncCommand;
	import ru.gotoandstop.adi.user.Owner;
	import ru.gotoandstop.adi.values.IntValue2;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import ru.gotoandstop.adi.remote.RemoteEvent;
	import ru.gotoandstop.adi.remote.RemoteRequest;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class AddParamsCommand extends EventDispatcher implements IAsyncCommand{
		private var s:IntValue2;
		private var ag:IntValue2;
		private var ac:IntValue2;
		private var owner:Owner;
		
		public function AddParamsCommand(s:IntValue2, ag:IntValue2, ac:IntValue2, owner:Owner){
			this.s = s;
			this.ag = ag;
			this.ac = ac;
			this.owner = owner;
		}
		
		public function execute():void{
			var request:RemoteRequest = new RemoteRequest();
			request.addEventListener(RemoteEvent.COMPLETE, this.handleTuning);
			request.addEventListener(RemoteEvent.ERROR, this.handleTuningError);
			request.tune(this.s.value, this.ag.value, this.ac.value);
		}
		
		private function destroyTuning(request:RemoteRequest):void{
			request.removeEventListener(RemoteEvent.COMPLETE, this.handleTuning);
			request.removeEventListener(RemoteEvent.ERROR, this.handleTuningError);
		}
		
		private function handleTuning(event:RemoteEvent):void{
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyTuning(request);
//			
//			var info:XML = event.response..info[0];
//			var char:XML = info.char;
//			
//			this.owner.char.strength = char.@strength;
//			this.owner.char.agility = char.@agility;
//			this.owner.char.accuracy = char.@accuracy;
//			this.owner.paramsPoints.value = char.@paramPoints;
			
			trace('asa aasd alkf jkl lkjweo uoiua ')
			trace(event.response)
			
			super.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function handleTuningError(event:RemoteEvent):void{
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyTuning(request);
			trace('error occured while reg:', event);
		}
	}
}
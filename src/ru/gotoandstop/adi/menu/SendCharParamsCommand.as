package ru.gotoandstop.adi.menu{
	import ru.gotoandstop.adi.command.IAsyncCommand;
	import ru.gotoandstop.adi.command.ICommand;
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
	public class SendCharParamsCommand extends EventDispatcher implements IAsyncCommand{
		private var strength:IntValue2;
		private var agility:IntValue2;
		private var accuracy:IntValue2;
		
		private var owner:Owner;
		
		public function SendCharParamsCommand(strength:IntValue2, agility:IntValue2, accuracy:IntValue2, lol:Owner){
			this.strength = strength;
			this.agility = agility;
			this.accuracy = accuracy;
			
			this.owner = lol;
		}
		
		public function execute():void{
			super.dispatchEvent(new Event(Event.COMPLETE));
			
			var request:RemoteRequest = new RemoteRequest();
			request.addEventListener(RemoteEvent.COMPLETE, this.handleTuning);
			request.addEventListener(RemoteEvent.ERROR, this.handleTuningError);
			//request.registerNewUser(this.nick.value, this.type.value, this.strength.value, this.agility.value, this.accuracy.value);
		}
		
		private function destroyTuning(request:RemoteRequest):void{
			request.removeEventListener(RemoteEvent.COMPLETE, this.handleTuning);
			request.removeEventListener(RemoteEvent.ERROR, this.handleTuningError);
		}
		
		private function handleTuning(event:RemoteEvent):void{
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyTuning(request);
			
			var a:uint;
			var s:uint
			var ag:uint;
			var ac:uint;
			var h:uint;
			
			this.owner.char.strength = s;
			this.owner.char.agility = ag;
			this.owner.char.accuracy = ac;
			this.owner.char.health = h;
			this.owner.paramsPoints.value = a;
			
			super.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function handleTuningError(event:RemoteEvent):void{
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyTuning(request);
			trace('error occured while reg');
		}
	}
}
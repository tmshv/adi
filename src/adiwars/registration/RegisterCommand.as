package adiwars.registration{
	import adiwars.command.IAsyncCommand;
	import adiwars.user.Owner;
	import adiwars.values.IntValue2;
	import adiwars.values.StringValue;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import remote.RemoteEvent;
	import remote.RemoteRequest;

	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class RegisterCommand extends EventDispatcher implements IAsyncCommand{
		private var nick:StringValue;
		private var type:StringValue;
		private var strength:IntValue2;
		private var agility:IntValue2;
		private var accuracy:IntValue2;
		
		private var owner:Owner;
		
		public function RegisterCommand(nick:StringValue, type:StringValue, strength:IntValue2, agility:IntValue2, accuracy:IntValue2, lol:Owner){
			this.nick = nick;
			this.type = type;
			this.strength = strength;
			this.agility = agility;
			this.accuracy = accuracy;
			
			this.owner = lol;
		}  
		public function execute():void{
			var request:RemoteRequest = new RemoteRequest();
			request.addEventListener(RemoteEvent.COMPLETE, this.handleRegistration);
			request.addEventListener(RemoteEvent.ERROR, this.handleRegistrationError);
			request.registerNewUser(this.nick.value, this.type.value, this.strength.value, this.agility.value, this.accuracy.value);
		}
		
		private function destroyRegistraion(request:RemoteRequest):void{
			request.removeEventListener(RemoteEvent.COMPLETE, this.handleRegistration);
			request.removeEventListener(RemoteEvent.ERROR, this.handleRegistrationError);
		}
		
		private function handleRegistration(event:RemoteEvent):void{
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyRegistraion(request);
			
			this.owner.parseRemoteRequest(event.response);	
			super.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function handleRegistrationError(event:RemoteEvent):void{
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyRegistraion(request);
			trace('error occured while reg');
		}
	}
}
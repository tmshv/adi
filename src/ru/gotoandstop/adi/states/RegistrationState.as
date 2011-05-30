package ru.gotoandstop.adi.states{
	import ru.gotoandstop.adi.character.CharType;
	import ru.gotoandstop.adi.command.Invoker;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.registration.MoveToTuningCommand;
	import ru.gotoandstop.adi.registration.RegController;
	import ru.gotoandstop.adi.values.StringValue;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ru.gotoandstop.adi.remote.RemoteEvent;
	import ru.gotoandstop.adi.remote.RemoteRequest;
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class RegistrationState extends Screen{
		private var layout:DisplayObject;
		internal override function getLayout():DisplayObject{
			return this.layout;
		}
		
		private var c:RegController;
		
		public function RegistrationState(context:Context){
			super(null, context, ApplicationStateKey.REG);
		}
		
		internal override function init():void{
			var type:StringValue = new StringValue('');
			var nick:StringValue = new StringValue('');
			var tuning:Screen = super.manager.getState(ApplicationStateKey.TUNE);
			
			this.c = new RegController(context, type, nick, new Invoker(new MoveToTuningCommand(type, nick, tuning)));
			this.layout = this.c.clip;
		}
		
		public override function enable():void{
			super.manager.addLayout(this.layout);
			super.enable();
		}
		
		public override function disable():void{
			if(super.manager && this.layout) super.manager.removeLayout(this.layout);
			super.disable();
		}
	}
}
package ru.gotoandstop.adi.states{
	import ru.gotoandstop.adi.character.CharType;
	import ru.gotoandstop.adi.command.ICommand;
	import ru.gotoandstop.adi.command.IMacroCommand;
	import ru.gotoandstop.adi.command.Invoker;
	import ru.gotoandstop.adi.command.MacroCommand;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.registration.RegisterCommand;
	import ru.gotoandstop.adi.tuning.DecreaseCommand;
	import ru.gotoandstop.adi.registration.tuning.DefaultCommand;
	import ru.gotoandstop.adi.tuning.IncreaseCommand;
	import ru.gotoandstop.adi.registration.tuning.TuningController;
	import ru.gotoandstop.adi.ui.UICommandEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import ru.gotoandstop.adi.remote.RemoteEvent;
	import ru.gotoandstop.adi.remote.RemoteRequest;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class TuneState extends Screen{
		private var layout:DisplayObject;
		internal override function getLayout():DisplayObject{
			return this.layout;
		}
		
		private var controller:TuningController;
		private var nickAndType:Array;
		
		public function TuneState(context:Context){
			super(null, context, ApplicationStateKey.TUNE);
		}
		
		internal override function init():void{
			var to_menu:ICommand = new ActivateStateCommand(super.manager.getState(ApplicationStateKey.MENU));
			this.controller = new TuningController(super.context, to_menu);
			this.layout = this.controller.getClip();
		}
		
		public override function enable():void{
			super.manager.addLayout(this.layout);
			super.enable();
		}
		
		public override function disable():void{
			if(super.manager && this.layout) super.manager.removeLayout(this.layout);
			super.disable();
		}
		
		public override function send(...params):void{
			trace('params for tuning', params)
			this.nickAndType = params;
			this.controller.update(this.nickAndType[0], this.nickAndType[1]);
		}
	}
}
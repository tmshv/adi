package adiwars.states{
	import adiwars.character.CharType;
	import adiwars.command.ICommand;
	import adiwars.command.IMacroCommand;
	import adiwars.command.Invoker;
	import adiwars.command.MacroCommand;
	import adiwars.core.Context;
	import adiwars.registration.RegisterCommand;
	import adiwars.tuning.DecreaseCommand;
	import adiwars.registration.tuning.DefaultCommand;
	import adiwars.tuning.IncreaseCommand;
	import adiwars.registration.tuning.TuningController;
	import adiwars.ui.UICommandEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import remote.RemoteEvent;
	import remote.RemoteRequest;
	
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
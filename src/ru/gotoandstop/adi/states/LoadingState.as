package ru.gotoandstop.adi.states{
	import ru.gotoandstop.adi.Indicator;
	import ru.gotoandstop.adi.core.Context;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class LoadingState extends Screen{
		private var layout:Indicator;
		internal override function getLayout():DisplayObject{
			return this.layout;
		}
		
		public function LoadingState(context:Context, indicator:Indicator){
			super(null, context, ApplicationStateKey.LOADING);
			this.layout = indicator;
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
package adiwars.raiting{
	import adiwars.clips.RaitingClip;
	import adiwars.clips.RaitingItemClip;
	import adiwars.command.Invoker;
	import adiwars.core.Context;
	import adiwars.ui.GameItem;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class RaitingItem extends EventDispatcher{
		public var firstName:String;
		public var lastName:String;
		public var userID:String;
		public var level:uint;
		public var picURL:String;
		public var top:uint;
		
		public function RaitingItem(definition:XML){
			super();//container, context);
			
			this.userID = definition.@id
			this.level = definition.@lvl;
			//exp
			this.top = definition.@top;
			this.firstName = definition.@firstName;
			this.lastName = definition.@lastName;
			this.picURL = definition.@userpic;
		}
	}
}
package ru.gotoandstop.adi.remote{
	import flash.events.IEventDispatcher;

	/**
	 *
	 * @author Timashev Roman
	 */
	public interface ISocialAPI extends IEventDispatcher{
		function getBaseUserInfo(uids:String):void;
		function getUserFriends():void;
	}
}
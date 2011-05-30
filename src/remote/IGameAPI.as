package remote{
	import flash.events.IEventDispatcher;

	/**
	 *
	 * @author Timashev Roman
	 */
	public interface IGameAPI extends IEventDispatcher{
		function getUserInfo():void;
		function registerNewUser(nick:String, charType:String, strength:uint, agility:uint, accuracy:uint):void;
		function getBattleResult(opponentID:String):void;
		function getOpponents():void;
		function getConfig():void;
		function buy(item:String):void;
		function getTop30():void;
		function getTopFriends(list:Vector.<String>):void;
		function getAchievements(uid:String=null):void;
		function getSkills():void;
		function getItems():void;
		function updateSuite(list:Vector.<String>):void;
		function tune(strength:uint, agility:uint, accuracy:uint):void;
		function skillUp(skill:String):void;
	}
}
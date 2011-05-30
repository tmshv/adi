package adiwars.core{
	/**
	 *
	 * @author Timashev Roman
	 */
	public class Config{
		public var width:uint;
		public var height:uint;
		public var userProfile:XML;
		public var userID:String;
		public var apiID:String;
		public var authKey:String;
		public var secretKey:String;// = 'k1roFpK4Oe';//'KotJNqAw7F';
		public var gameAPIURL:String;// = 'http://starwars.nlomarketing.ru/api.php';
		//public const GAME_SERVER_URL:String = 'http://adiwars.ideafixe.ru';
		public var context:XML;
		public var xml:XML;
		public var friends:Vector.<String>;
		public var inviteFunction:Function;
		public var firstRequest:String;
		
		public function Config(){
			
		}
	}
}
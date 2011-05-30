package ru.gotoandstop.adi.vkontakte{
	/**
	 * Описывает содержимое первого запроса к АПИ
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class FirstRequest{
		private var _source:XML;
		public function get source():XML{
			return this._source;
		}
		
		public var url:String;
//		public var friends:Vector.<uint>;
		public var useTestMode:Boolean;
		public var profile:XML;
		
		public function FirstRequest(request:XML, userID:uint){
			this._source = request;
			this.url = request.url;
			this.useTestMode = Boolean(parseInt(request.test));
			
			this.profile = request.profile.item.(uid == userID)[0];
//			this.friends = this.getFriendsID(request.profile..user, userID);
		}
		
//		private function getFriendsID(list:XMLList, excludeID:uint):Vector.<uint>{
//			var result:Vector.<uint> = new Vector.<uint>();
//			for each(var item:XML in list){
//				var id:uint = item.uid;
//				if(id != excludeID) result.push(item.uid);
//			}
//			return result;
//		}
	}
}
//<response>
//	<url>http://cs5029.vkontakte.ru/u1338931/2fe08b899beaed.zip</url>
//	<isapp>1<isapp>
//	<profile list="true">
//		<item>
//			<uid&gt;1338931&lt;/uid&gt;%0D   &lt;first_name&gt;Роман&lt;/first_name&gt;%0D   &lt;last_name&gt;Тимашев&lt;/last_name&gt;%0D   &lt;sex&gt;2&lt;/sex&gt;%0D   &lt;bdate&gt;12.3.1989&lt;/bdate&gt;%0D  &lt;/item&gt;%0D &lt;/profile&gt;%0D &lt;settings&gt;1282&lt;/settings&gt;%0D&lt;/respons
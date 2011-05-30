package remote{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class VirtualSocialAPIBuilder implements IRemoteRequestBuilder{
		public function VirtualSocialAPIBuilder(){
			super();
		}
		
		public function createSocial():ISocialAPI{
			return new VIrtualSocialAPI();
		}
		
		public function createGame():IGameAPI{
			return null;
		}
	}
}
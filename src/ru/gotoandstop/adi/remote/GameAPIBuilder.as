package ru.gotoandstop.adi.remote{
	import ru.gotoandstop.adi.core.Config;
	
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class GameAPIBuilder implements IRemoteRequestBuilder{
		private var config:Config;
		
		public function GameAPIBuilder(config:Config){
			this.config = config;
		}
		
		public function createSocial():ISocialAPI{
			return null;
		}
		
		public function createGame():IGameAPI{
			return new GameAPI(this.config);
		}
	}
}
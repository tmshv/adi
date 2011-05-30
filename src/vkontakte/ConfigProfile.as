package vkontakte{
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ConfigProfile{
		private var result:XML;
		public function get profile():XML{
			return this.result;
		}
		
		public function ConfigProfile(vkontakteProfile:XML){
			if(vkontakteProfile){
				const id:uint = vkontakteProfile.uid;
				const first_name:String = vkontakteProfile.first_name;
				const last_name:String = vkontakteProfile.last_name;
				
				this.result = <profile id={id} firstName={first_name} lastName={last_name} />;
			}else{
				this.result = <profile id="" firstName="" lastName="" />;
			}
		}
	}
}
package ru.gotoandstop.adi.test{
	import ru.gotoandstop.adi.core.Config;
	import ru.gotoandstop.adi.core.Context;
	
	import com.junkbyte.console.Cc;
	
	import flash.display.Sprite;
	
	import ru.gotoandstop.adi.social.ISocialGameApplication;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class InitialInfoViewer extends Sprite implements ISocialGameApplication{
		private var config:Config;
		private var context:Context;
		
		//private var console:
		
		public function InitialInfoViewer(){
			super();
		}
		
		protected function init():void{
			var allowed_domain:String = super.loaderInfo.loaderURL;
			
			var init_url:String = this.config.context.value.(@key=='initFileURL');
			
			trace('tester started')
			
			Cc.startOnStage(this);
			Cc.log('init');
			
			Cc.log('context:');
			Cc.log(this.config.context.toXMLString());
			
			Cc.log('profile:');
			Cc.log(this.config.userProfile.toXMLString());
			
			Cc.log('first request:');
			Cc.log(this.config.firstRequest);
		}
		
		public function launch(config:Config):void{
			this.doLaunch(config);
		}
		
		private function doLaunch(config:Config):void{
			this.config = config;
			this.init();
		}
	}
}
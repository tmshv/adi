package adiwars.states{
	import adiwars.character.Char;
	import adiwars.character.CharAction;
	import adiwars.character.CharDefinition;
	import adiwars.character.CharType;
	import adiwars.clips.MainMenuChewbaccaClip;
	import adiwars.clips.MainMenuLeiaClip;
	import adiwars.clips.MainMenuLukeClip;
	import adiwars.clips.MainMenuVaderClip;
	import adiwars.core.Context;
	import adiwars.core.mvc.BaseView;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class MenuChar extends Sprite{
		public function MenuChar(type:String){
			super();
			
			var char:MovieClip = this.getClip(type);
			super.addChild(char);
			super.mouseChildren = false;
		}
		
		private function getClip(type:String):MovieClip{
			var clip:MovieClip;
			switch(type){
				case CharType.CHEWBACCA:
					clip = new MainMenuChewbaccaClip();
					break;
				
				case CharType.LEIA:
					clip = new MainMenuLeiaClip();
					break;
				
				case CharType.LUKE:
					clip = new MainMenuLukeClip();
					break;
				
				case CharType.VADER:
					clip = new MainMenuVaderClip();
					break;
				
				default:
					clip = new MainMenuVaderClip();
					break;
			}
			return clip;
		}
	}
}
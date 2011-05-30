package adiwars.battle{
	import adiawars.clips.LeiaClip;
	
	import adiwars.GoodsItem;
	import adiwars.character.Char;
	import adiwars.character.CharDefinition;
	import adiwars.character.CharType;
	import adiwars.clips.ChewbaccaClip;
	import adiwars.clips.LukClip;
	import adiwars.clips.VaderClip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Fighter{
		public static var clipContainer:Sprite;
		
		public var char:Char;
		private var clip:MovieClip;
		
		public function Fighter(def:CharDefinition, suite:Vector.<GoodsItem>, pos:Point, m:Point){
			this.char = this.createChar(def, pos, m);
			this.char.suite = suite;
		}
		
		private function createChar(definition:CharDefinition, position:Point, scaleMultiplier:Point):Char{
			var clip:MovieClip;
			const type:String = definition.type;
//			const type:String = CharType.LEIA;
			switch(type){
				case CharType.CHEWBACCA:
					clip = new ChewbaccaClip();
					break;
				
				case CharType.LEIA:
					clip = new LeiaClip();
					break;
				
				case CharType.LUKE:
					clip = new LukClip();
					break;
				
				case CharType.VADER:
					clip = new VaderClip();
					break;
				
				default:
					clip = new VaderClip();
					break;
			}
			
			clip.x = position.x;
			clip.y = position.y;
			clip.scaleX *= scaleMultiplier.x;
			clip.scaleY *= scaleMultiplier.y;
			Fighter.clipContainer.addChild(clip);
			
			var char:Char = new Char(clip, definition);
			this.clip = clip;
			return char;
		}
	}
}
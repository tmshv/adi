package ru.gotoandstop.adi.test{
	import adiawars.clips.LeiaClip;
	
	import ru.gotoandstop.adi.GoodsItem;
	import ru.gotoandstop.adi.battle.BattleDefinition;
	import ru.gotoandstop.adi.battle.Fighter;
	import ru.gotoandstop.adi.battle.Timeline;
	import ru.gotoandstop.adi.character.Char;
	import ru.gotoandstop.adi.character.CharDefinition;
	import ru.gotoandstop.adi.character.CharType;
	import ru.gotoandstop.adi.character.events.CharEvent;
	import adiwars.clips.ChewbaccaClip;
	import adiwars.clips.LukClip;
	import adiwars.clips.VaderClip;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.user.Goods;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ru.gotoandstop.math.Calculate;
	
	[SWF(width=700, height=600, backgroundColor=0x000000, frameRate=5)]
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class BattleInSuite extends Sprite{
		private var _charsContainer:Sprite;
		private var timeline:Timeline;
		private var suite:Goods;
		
		public function BattleInSuite(){
			super();
			this._charsContainer = new Sprite();
			this._charsContainer.y = 300;
			super.addChild(this._charsContainer);
			Fighter.clipContainer = this._charsContainer;
			
			var def:BattleDefinition = BattleDefinition.createByXML(<battle>
				<char owner="1" type="leia" health="76" weapon="0"/>
				<char owner="2" type="luke" health="76" weapon="0"/>
				<step trace="skill_6">
				  <fighter id="1" action="stab" health="76"/>
				  <fighter id="2" action="hit" health="49.4"/>
				</step>
				<step trace="kontrattack2">
				  <fighter id="2" action="stab" health="49.4"/>
				  <fighter id="1" action="dodge" health="76"/>
				</step>
				<step trace="kontrattack2">
				  <fighter id="1" action="stab" health="76"/>
				  <fighter id="2" action="hit" health="34.4"/>
				</step>
				<step trace="skill_6">
				  <fighter id="1" action="stab" health="76"/>
				  <fighter id="2" action="hit" health="21.3"/>
				</step>
				<step trace="dodge2">
				  <fighter id="2" action="disorientation" health="21.3"/>
				  <fighter id="1" action="dodge" health="76"/>
				</step>
				<step trace="crit1">
				  <fighter id="1" action="crit" health="76"/>
				</step>
				<step trace="crit1">
				  <fighter id="1" action="stab" health="76"/>
				  <fighter id="2" action="superhit" health="0"/>
				</step>
				<step>
				  <fighter id="2" action="death" health="0"/>
				</step>
				<step>
				  <fighter id="1" action="win" health="76"/>
				</step>
				<results id="1" exp="8" lvlup="0" money="8"/>
			  </battle>
			);
			
			var config:XML = <config>
				<char name="vader" strength="9" agility="9" accuracy="9" />
				<char name="luke" strength="8" agility="9" accuracy="10" />
				<char name="leia" strength="7" agility="10" accuracy="10" />
				<char name="chewbacca" strength="11" agility="7" accuracy="9" />
				<item type="suite" name="101" frame="1" image="adiwars.clips.icons.Boots1" titl="Superstar II" strength="1" agility="1" health="1" cost="10" lvl="1"></item>
				<item type="suite" name="102" frame="2" image="adiwars.clips.icons.Boots2" titl="Stan Smith 1 - Good" strength="2" agility="2" health="2" cost="10" lvl="2"></item>
				<item type="suite" name="103" frame="3" image="adiwars.clips.icons.Boots3" titl="R2D2 C3PO TOP TEN" strength="3" agility="3" health="3" cost="10" lvl="3"></item>
				<item type="suite" name="104" frame="4" image="adiwars.clips.icons.Boots4" titl="Superstar 2.0 Rebels" strength="4" agility="4" health="4" cost="10" lvl="4"></item>
				<item type="suite" name="105" frame="5" image="adiwars.clips.icons.Boots5" titl="Boba Fett ZX 800" strength="5" agility="5" health="5" cost="10" lvl="3"></item>
				<item type="suite" name="106" frame="6" image="adiwars.clips.icons.Boots6" titl="Han Solo SL-72" strength="6" agility="6" health="6" cost="10" lvl="3"></item>
				<item type="suite" name="107" frame="7" image="adiwars.clips.icons.Boots7" titl="Superstar 2.0 Imperials" strength="7" agility="7" health="7" cost="10" lvl="3"></item>
				<item type="suite" name="108" frame="8" image="adiwars.clips.icons.Boots8" titl="Darth vader Samba" strength="8" agility="8" health="8" cost="10" lvl="3"></item>
				<item type="suite" name="109" frame="9" image="adiwars.clips.icons.Boots9" titl="Chewbacca JOGGING Hi" strength="9" agility="9" health="9" cost="10" lvl="3"></item>
				<item type="suite" name="110" frame="10" image="adiwars.clips.icons.Boots10" titl="Forum Mid Death Stars" strength="10" agility="10" health="10" cost="10" lvl="3"></item>
				<item type="suite" name="111" frame="11" image="adiwars.clips.icons.Boots11" titl="Jabba The Hutt Attitude" strength="11" agility="11" health="11" cost="10" lvl="3"></item>
				<item type="suite" name="112" frame="12" image="adiwars.clips.icons.Boots12" titl="Nizza Hi Wookiees" strength="12" agility="12" health="12" cost="10" lvl="3"></item>
				<item type="suite" name="201" frame="1" image="adiwars.clips.icons.Pants1" titl="Firebird" strength="12" agility="12" health="12" cost="10" lvl="1"></item>
				<item type="suite" name="202" frame="2" image="adiwars.clips.icons.Pants2" titl="ADI Firebird 1" strength="12" agility="12" health="12" cost="10" lvl="2"></item>
				<item type="suite" name="203" frame="3" image="adiwars.clips.icons.Pants3" titl="Firebird 1 Green" strength="12" agility="12" health="12" cost="10" lvl="3"></item>
				<item type="suite" name="204" frame="4" image="adiwars.clips.icons.Pants4" titl="Firebird 1 Blue" strength="12" agility="12" health="12" cost="10" lvl="4"></item>
				<item type="suite" name="301" frame="1" image="shirt1" titl="TREFOIL TEE" strength="12" agility="12" health="12" cost="10" lvl="1"></item>
				<item type="suite" name="302" frame="2" image="shirt2" titl="TREFOIL TEE" strength="12" agility="12" health="12" cost="10" lvl="2"></item>
				<item type="suite" name="303" frame="3" image="shirt3" titl="Imperial vs. Rebels Footballs" strength="12" agility="12" health="12" cost="10" lvl="3"></item>
				<item type="suite" name="304" frame="4" image="shirt4" titl="Chewbacca Basketball" strength="12" agility="12" health="12" cost="10" lvl="4"></item>
				<item type="suite" name="305" frame="5" image="shirt5" titl="Yoda vs. Vader Tennis" strength="12" agility="12" health="12" cost="10" lvl="4"></item>
				<item type="suite" name="306" frame="6" image="shirt6" titl="Foosball Darth Vader" strength="12" agility="12" health="12" cost="10" lvl="4"></item>
				<item type="suite" name="401" frame="1" image="adiwars.clips.icons.Jacket1" titl="Jedi Superstar" strength="1" agility="1" health="1" cost="10" lvl="1"></item>
				<item type="suite" name="402" frame="2" image="adiwars.clips.icons.Jacket2" titl="Wookiees Hooded Flock" strength="2" agility="2" health="2" cost="10" lvl="2"></item>
				<item type="suite" name="403" frame="3" image="adiwars.clips.icons.Jacket3" titl="Boba Fett TT" strength="3" agility="3" health="3" cost="10" lvl="3"></item>
				<item type="suite" name="404" frame="4" image="adiwars.clips.icons.Jacket4" titl="Dark Side Superstar" strength="4" agility="4" health="4" cost="10" lvl="4"></item>
				<item type="suite" name="405" frame="5" image="adiwars.clips.icons.Jacket5" titl="Dsrth Vader Hooded Flock" strength="5" agility="5" health="5" cost="10" lvl="4"></item>
				<item type="suite" name="406" frame="6" image="adiwars.clips.icons.Jacket6" titl="Jacket Mix" strength="6" agility="6" health="6" cost="10" lvl="4"></item>
				<item type="suite" name="407" frame="7" image="adiwars.clips.icons.Jacket7" titl="Chewbacca Coat" strength="7" agility="7" health="7" cost="10" lvl="4"></item>
				<item type="weapon" name="500"  image="adiwars.clips.icons.Sword7" titl="Белый Лазерный Меч" damage="5" level="1" pic="adiwars.clips.icons.Sword7" cost="1" title="Белый Лазерный Меч">Описание лазерного меча</item>
				<item type="weapon" name="501"  image="adiwars.clips.icons.Blaster6" titl="DL-44" damage="5" level="1" pic="adiwars.clips.icons.Blaster6" cost="100" title="DL-44">Описание бластера</item>
			</config>;
			
			this.suite = new Goods();
			var goods:Goods = new Goods();
			var items:XMLList = config..item;
			for each(var i:XML in items){
				if(goods.isGoodies(i.@type)){
					goods.addItem(i);
				}
			}
			var list:Vector.<GoodsItem> = goods.getList();
			var used:Object = new Object();
			
			for each(var item:GoodsItem in list){
				var suite_type:String = item.name.substr(0, 1);
				if(used[suite_type]) continue;
				else{
					this.suite.add(item);
					used[suite_type] = item;
				}
			}
			this.r(list);
			
			
			var chars_definition:Vector.<CharDefinition> = def.getChars();
			var user_def:CharDefinition = chars_definition[0];
			var opponent_def:CharDefinition = chars_definition[1];
			
			var user:Fighter = new Fighter(user_def, this.suite.getList(), new Point(150, 0), new Point(1, 1));
			var opp:Fighter = new Fighter(opponent_def, this.suite.getList(), new Point(550, 0), new Point(-1, 1));
			
			var chars:Vector.<Char> = new Vector.<Char>();
			chars.push(user.char);
			chars.push(opp.char);
			
			this.timeline = new Timeline();
			this.timeline.play(def, chars);
		}
		
		private function r(list:Vector.<GoodsItem>):void{
			for(var i:uint; i<4; i++){
				var rn:uint = Calculate.random(0, list.length-1, true);
				var item:GoodsItem = list[rn];
				this.suite.add(item);
			}
		}
	}
}
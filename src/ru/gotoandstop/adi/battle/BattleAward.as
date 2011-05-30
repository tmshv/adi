package ru.gotoandstop.adi.battle{
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class BattleAward{
		public var money:uint;
		public var experienceAdded:uint;
		public var experience:uint;
		//public var skill:String;
		public var levelUp:Boolean;
		public var level:uint;
		public var winner:String;
		
		public var skillPoints:uint;
		public var paramsPoints:uint;
		
		public function BattleAward(money:uint, experienceAdded:uint, winner:String, levelUp:Boolean, level:uint, exp:uint){
			this.money = money;
			this.experienceAdded = experienceAdded;
			this.experience = exp;
			this.winner = winner;
			this.levelUp = levelUp;
			this.level = level;
		}
	}
}
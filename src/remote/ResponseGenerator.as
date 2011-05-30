package remote{
	/**
	 * Класс для преобразования ответа сервера Контакта в универсальный внутриигровой формат
	 * @author Timashev Roman
	 */
	public class ResponseGenerator{
		public static function createUserInfoResponse(list:Vector.<Array>):XML{
			var xml:XML = <userList></userList>;
			for each(var user:Array in list){
				var item:XML = <userInfo id={user[0]} firstName={user[1]} lastName={user[2]} userpic={user[3]} userpicBig={user[4]}/>
				xml.appendChild(item);
			}
			return xml;
		}
		
		public static function userInfo(
			id:String,
			level:uint,
			char:uint,
			skillpoint:uint,
			experience:uint,
			money:uint,
			totalbattles:uint,
			battles:uint,
			health:uint,
			strength:uint,
			agility:uint,
			accuracy:uint
		):XML{
			
			var xml:XML = <userInfo
				id={id}
				level={level}
				char={char}
				skillpoint={skillpoint}
				experience={experience}
				money={money}
				totalbattles={totalbattles}
				battles={battles}>
				
				<char
					health={health}
					strength={strength}
					agility={agility}
					accuracy={accuracy}
				/>
			</userInfo>;
			
			return xml;
		}
	}
}
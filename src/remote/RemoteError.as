package remote{
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class RemoteError extends Error{
		public function RemoteError(id:uint){
			super('', id);//message, id);
		}
		
		public function toXML():XML{
			return <error id={super.errorID}/>;
		}
	}
}
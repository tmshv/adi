package ru.gotoandstop.adi.remote{
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	internal class RemoteErrorGenerator{
		public static function xmlParsingError():RemoteError{
			return new RemoteError(101);
		}
		
		public static function someError():RemoteError{
			return new RemoteError(100);
		}
		
		public static function xmlUserIsUndefined():RemoteError{
			return new RemoteError(201);
		}
	}
}
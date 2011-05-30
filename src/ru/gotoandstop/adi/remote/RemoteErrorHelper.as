package ru.gotoandstop.adi.remote{
	/**
	 *
	 * @author Timashev Roman
	 */
	public class RemoteErrorHelper{
		private var _errorType:uint;
		public function get errorType():uint{
			return this._errorType;
		}
		
		private var _errorCode:uint;
		public function get errorCode():uint{
			return this._errorCode;
		}
		
		private var _errorID:uint;
		public function get errorID():uint{
			return this._errorID;
		}
		
		private var _errorMessage:String;
		private function errorMessage():String{
			return this._errorMessage;
		}
		
		public function RemoteErrorHelper(xml:XML){
			this._errorID = xml.@id;
			this._errorType = this._errorID / 100;
			this._errorCode = this._errorID - this._errorType * 100;
			
			this._errorMessage = xml.text();
		}
	}
}
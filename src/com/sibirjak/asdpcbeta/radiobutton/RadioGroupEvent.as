package com.sibirjak.asdpcbeta.radiobutton {

	import flash.events.Event;

	/**
	 * @author Jens Struwe 26.07.2011
	 */
	public class RadioGroupEvent extends Event {

		public static var CHANGE : String = "slider_change";
		
		private var _value : *;

		public function RadioGroupEvent(type : String, value : *) {
			_value = value;
			
			super(type);
		}

		public function get value() : * {
			return _value;
		}
	}
}

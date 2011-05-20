package com.sibirjak.asdpcbeta.selectbox {

	import flash.events.Event;

	/**
	 * @author Jens Struwe 30.03.2011
	 */
	public class SelectBoxEvent extends Event {

		public static const SELECTION_CHANGED : String = "selectBox_selection_changed";
		
		private var _selectedIndex : uint;

		public function SelectBoxEvent(type : String) {
			super(type);
		}

		public function get selectedIndex() : uint {
			return _selectedIndex;
		}

		public function set selectedIndex(selectedIndex : uint) : void {
			_selectedIndex = selectedIndex;
		}
		
	}
}

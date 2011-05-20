package com.sibirjak.asdpc.overview {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.common.Example;

	public class ButtonExample extends Example {
		private var _count : uint;

		public function ButtonExample() {
			var button : Button = new Button();
			button.setSize(80, 24);
			button.label = "Click: " + _count;
			button.addEventListener(ButtonEvent.CLICK, buttonClickHandler);
			addChild(button);
		}
		
		private function buttonClickHandler(event : ButtonEvent) : void {
			Button(event.target).label = "Click: " + ++_count;
		}
	}
}
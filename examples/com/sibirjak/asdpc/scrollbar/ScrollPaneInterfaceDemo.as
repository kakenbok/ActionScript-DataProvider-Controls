package com.sibirjak.asdpc.scrollbar {
	import com.sibirjak.asdpc.common.interfacedemo.WindowContainer;
	import com.sibirjak.asdpcbeta.scrollbar.ScrollPane;

	import flash.display.Sprite;

	/**
	 * @author Jens Struwe 23.04.2010
	 */
	public class ScrollPaneInterfaceDemo extends Sprite {

		protected var _scrollPane : ScrollPane;
		
		public function ScrollPaneInterfaceDemo() {

			var windowContainer : WindowContainer = new WindowContainer();
			addChild(windowContainer);

		}
	}
}

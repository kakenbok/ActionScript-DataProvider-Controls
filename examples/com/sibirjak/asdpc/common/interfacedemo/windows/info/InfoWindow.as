package com.sibirjak.asdpc.common.interfacedemo.windows.info {
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpcbeta.window.Window;

	/**
	 * @author jes 29.01.2010
	 */
	public class InfoWindow extends Window {

		[Embed(source="assets/information.png")]
		private var _info : Class;

		public function InfoWindow(view : IView) {
			_title = "Info";
			setStyle(Window.style.windowIconSkin, _info);
			
			documents = [
				"Display info", new DisplayListInfoTab(view),
				"Style info", new StyleInfoTab(view)
			];
		}

	}
}

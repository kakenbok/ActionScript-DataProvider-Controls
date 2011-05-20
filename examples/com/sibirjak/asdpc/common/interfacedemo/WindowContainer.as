/**
 * ActionScript Data Provider Controls
 * 
 * Copyright (c) 2010 Jens Struwe, http://www.sibirjak.com/
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.sibirjak.asdpc.common.interfacedemo {
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpcbeta.core.managers.PopUpManager;
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.WindowEvent;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	/**
	 * @author jes 25.11.2009
	 */
	public class WindowContainer extends View {
		
		private static var _instance : WindowContainer;

		private var _draggingWindow : Window;
		
		public static function getInstance() : WindowContainer {
			if (!_instance) _instance = new WindowContainer();
			return _instance;
		}

		override public function addChild(window : DisplayObject) : DisplayObject {
			super.addChild(window);
			
			window.addEventListener(MouseEvent.ROLL_OVER, windowRollOverHandler);
			window.addEventListener(MouseEvent.ROLL_OUT, windowRollOutHandler);
			window.addEventListener(MouseEvent.MOUSE_DOWN, windowMouseDownHandler);

			window.addEventListener(WindowEvent.START_DRAG, windowStartDragHandler);
			window.addEventListener(WindowEvent.STOP_DRAG, windowStopDragHandler);
			window.addEventListener(WindowEvent.RESTORE_START, windowStartRestoreHandler);
			return window;
		}

		override protected function cleanUpCalled() : void {
			
			var i : int = -1;
			var window : Window;
			while (++i < numChildren) {
				window = getChildAt(i) as Window;
				window.removeEventListener(MouseEvent.ROLL_OVER, windowRollOverHandler);
				window.removeEventListener(MouseEvent.ROLL_OUT, windowRollOutHandler);
				window.removeEventListener(MouseEvent.MOUSE_DOWN, windowMouseDownHandler);

				window.removeEventListener(WindowEvent.START_DRAG, windowStartDragHandler);
				window.removeEventListener(WindowEvent.STOP_DRAG, windowStopDragHandler);
				window.removeEventListener(WindowEvent.RESTORE_START, windowStartRestoreHandler);
			}
			
		}

		private function windowRollOverHandler(event : MouseEvent) : void {
			if (!_draggingWindow) {
				
				var window : Window = event.currentTarget as Window;

				if (_lockTopWindow) {
					if (_lockTopWindow == window) _lockTopWindow = null;
					else return;
				}
				
				bringToFront(window);
			}
		}
		
		private var _lockTopWindow : Window;
		
		private function windowRollOutHandler(event : MouseEvent) : void {
			if (!_draggingWindow) {
				var window : Window = event.currentTarget as Window;
				if (PopUpManager.getInstance().hasPopUp()) {
					_lockTopWindow = window;
				}
			}
		}
		
		private function windowMouseDownHandler(event : MouseEvent) : void {
			if (_lockTopWindow) {
				_lockTopWindow = null;
				var window : Window = event.currentTarget as Window;
				if (_lockTopWindow != window) bringToFront(window);
			}
			
		}

		private function bringToFront(window : Window) : void {
			var container : DisplayObjectContainer = window.parent;
			container.setChildIndex(window, container.numChildren - 1);
		}

		private function windowStartDragHandler(event : WindowEvent) : void {
			var window : Window = event.currentTarget as Window;
			bringToFront(window);
			
			_draggingWindow = window;
		}

		private function windowStopDragHandler(event : WindowEvent) : void {
			_draggingWindow = null;
		}

		private function windowStartRestoreHandler(event : WindowEvent) : void {
			var window : Window = event.currentTarget as Window;
			bringToFront(window);
		}

	}
}

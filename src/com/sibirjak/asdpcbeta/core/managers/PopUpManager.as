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
package com.sibirjak.asdpcbeta.core.managers {
	import com.sibirjak.asdpc.core.managers.StageProxy;
	import com.sibirjak.asdpc.core.skins.GlassFrame;

	import org.as3commons.collections.LinkedMap;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jes 08.12.2009
	 */
	public class PopUpManager {
		
		/* static */
		
		private static var _instance : PopUpManager;
		public static function getInstance() : PopUpManager {
			if (!_instance) _instance = new PopUpManager();
			return _instance;
		}
		
		private var _popUps : LinkedMap;
		
		public function PopUpManager() {
			_popUps = new LinkedMap();
		}

		public function createPopUp(popUp : DisplayObject, modal : Boolean = false) : void {
			if (_popUps.hasKey(popUp)) return;
			
			var disabledBackground : GlassFrame;
			
			if (modal) {
				disabledBackground = new GlassFrame(0xFFFFFF, .3);
				disabledBackground.setSize(StageProxy.stage.stageWidth, StageProxy.stage.stageHeight);
				StageProxy.popUpContainer.addChild(disabledBackground);
				
				StageProxy.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
				StageProxy.stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 1);
			}
			
			StageProxy.popUpContainer.addChild(popUp);		
			_popUps.add(popUp, [popUp, disabledBackground]);
		}
		
		public function bringToFront(popUp : DisplayObject) : void {
			if (!_popUps.hasKey(popUp)) return;

			var popUpValues : Array = _popUps.itemFor(popUp);
			var disabledBackground : GlassFrame = popUpValues[1];
			
			if (disabledBackground) {
				StageProxy.popUpContainer.setChildIndex(disabledBackground, StageProxy.popUpContainer.numChildren - 1);
			}
			StageProxy.popUpContainer.setChildIndex(popUp, StageProxy.popUpContainer.numChildren - 1);
		}

		public function removePopUp(popUp : DisplayObject) : void {
			if (!_popUps.hasKey(popUp)) return;
			
			StageProxy.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
			StageProxy.stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);

			var popUpValues : Array = _popUps.itemFor(popUp);
			var disabledBackground : GlassFrame = popUpValues[1];

			if (disabledBackground) {
				StageProxy.popUpContainer.removeChild(disabledBackground);			
			}
			StageProxy.popUpContainer.removeChild(popUp);			

			_popUps.removeKey(popUp);
		}
		
		public function hasPopUp() : Boolean {
			return _popUps.size > 0;			
		}

		public function freeModalWindow(popUp : DisplayObject) : void {
			if (!_popUps.hasKey(popUp)) return;
			
			var popUpValues : Array = _popUps.itemFor(popUp);
			var disabledBackground : GlassFrame = popUpValues[1];

			if (disabledBackground) {
				StageProxy.popUpContainer.removeChild(disabledBackground);
				popUpValues[1] = null;		
			}
		}

		private function mouseLeaveHandler(event : Event) : void {
			event.stopImmediatePropagation();
		}

		private function mouseMoveHandler(event : MouseEvent) : void {
			event.stopImmediatePropagation();
		}

	}

}

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
package com.sibirjak.asdpc.core.managers {
	import flash.display.Sprite;
	import flash.display.Stage;

	/**
	 * Stage manager.
	 * 
	 * <p>The StageProxy provides access to the Stage instance also to
	 * non visual objects such as the PopUpManager is.</p>
	 * 
	 * <p>The StageProxy maintains a container for popup windows as well
	 * as a container for tooltips, which should be displayed at the very
	 * top of the application. If a container does not exist yet, the
	 * StateProxy adds it the time it gets initialised.</p>
	 * 
	 * <p>The StageProxy will usually be automatically initialised at the
	 * place a View instance is added to the stage. However, in some cases
	 * it may be necessary to manually set up the StageProxy. Getting a
	 * StageProxy property without a prior initialisation will throw
	 * an error.</p>
	 * 
	 * @author jes 06.01.2010
	 */
	public class StageProxy {
		
		/**
		 * The Stage instance.
		 */
		private static var _stage : Stage;

		/**
		 * The popup container.
		 */
		private static var _popUpContainer : Sprite;

		/**
		 * The tooltip container.
		 */
		private static var _toolTipContainer : Sprite;
		
		/**
		 * Initialises the StageProxy.
		 * 
		 * <p>If no tooltip container is set up beforehand, the tooltip container
		 * is added on top of the application (stage.addChild(...)).</p>
		 * 
		 * <p>If no popup container is set up beforehand, the popup container
		 * is added just beneath the tooltip container.</p>
		 * 
		 * @param stage The Stage instance.
		 */
		static public function set stage(stage : Stage) : void {
			if (_stage) return;

			_stage = stage;
			
			// check if tooltip container is available

			if (!_toolTipContainer) {
				_toolTipContainer = stage.addChild(new Sprite()) as Sprite;
				_toolTipContainer.name = "toolTipContainer";
				_toolTipContainer.mouseEnabled = false;
				_toolTipContainer.mouseChildren = false;
			}

			// check if popup container is available

			if (!_popUpContainer) {
				var toolTipIndex : int = StageProxy.stage.getChildIndex(_toolTipContainer);
				_popUpContainer = StageProxy.stage.addChildAt(new Sprite(), toolTipIndex) as Sprite;
				_popUpContainer.name = "popUpContainer";
			}

		}

		/**
		 * Returns the sole Stage instance.
		 * 
		 * @return The Stage instance.
		 * @throws Error If the stage is not set yet.
		 */
		static public function get stage() : Stage {
			if (!_stage) {
				throw new Error("StageProxy: Tried to get a Stage instance before initialising.");
			}
			return _stage;
		}
		
		/**
		 * Sets a sprite to be the popup container.
		 * 
		 * <p>The popup container is usually automatically initialised
		 * but may be manually set at the very start of the application.
		 * If a popup container is already set, it is not possible to
		 * reset it.</p>
		 * 
		 * @param popUpContainer The popup container.
		 */
		static public function set popUpContainer(popUpContainer : Sprite) : void {
			if (_popUpContainer) return;

			_popUpContainer = popUpContainer;
			_popUpContainer.name = "popUpContainer";
		}
		
		/**
		 * Returns the sole popup container instance.
		 * 
		 * @return The popup container instance.
		 * @throws Error If the popup container is not set yet.
		 */
		static public function get popUpContainer() : Sprite {
			if (!_popUpContainer) {
				throw new Error("StageProxy: Tried to get the popup container before initialising.");
			}
			return _popUpContainer;
		}
		
		/**
		 * Sets a sprite to be the tooltip container.
		 * 
		 * <p>The tooltip container is usually automatically initialised
		 * but may be manually set at the very start of the application.
		 * If a tooltip container is already set, it is not possible to
		 * reset it.</p>
		 * 
		 * @param toolTipContainer The tooltip container.
		 */
		static public function set toolTipContainer(toolTipContainer : Sprite) : void {
			if (_popUpContainer) return;

			_toolTipContainer = toolTipContainer;
			_toolTipContainer.name = "toolTipContainer";
		}

		/**
		 * Returns the sole tooltip container instance.
		 * 
		 * @return The tooltip container instance.
		 * @throws Error If the tooltip container is not set yet.
		 */
		static public function get toolTipContainer() : Sprite {
			if (!_toolTipContainer) {
				throw new Error("StageProxy: Tried to get the tool tip container before initialising.");
			}
			return _toolTipContainer;
		}
		
	}
}

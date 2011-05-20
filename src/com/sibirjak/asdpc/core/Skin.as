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
package com.sibirjak.asdpc.core {

	/**
	 * Programmatic skin base implementation.
	 * 
	 * <p>The Skin is a View wich automatically removes and redraws
	 * all content after its update() method is invoked.</p>
	 * 
	 * @author jes 15.07.2009
	 */
	public class Skin extends View implements ISkin {

		/* changeable properties or styles */

		/**
		 * Name constant for the style invalidation property.
		 */
		protected const UPDATE_PROPERTY_STYLE : String = "style";
		
		/**
		 * Skin constructor.
		 * 
		 * <p>A Skin cannot receive or dispatch mouse events.</p>
		 */
		public function Skin() {
			mouseEnabled = false;
			mouseChildren = false;
		}

		/**
		 * Implements an empty body for the drawSkin interface.
		 * 
		 * <p>Since the Skin uses the view life cycle, its draw()
		 * method is used instead.</p>
		 * 
		 * @inheritDoc
		 */
		public final function drawSkin() : void {
			// cannot be overridden from here
		}
		
		/**
		 * Breaks the inheritance chain for the init() method.
		 * 
		 * <p>Properties for a Skin have to be determined within the 
		 * draw method.</p>
		 * 
		 * @inheritDoc
		 */
		override final protected function init() : void {
			// cannot be overridden from here
		}

		/**
		 * If a style changes, the skins is redrawn completely. If only the size
		 * has changed, a subclass may implement its custom resize method such as
		 * a scale9 scaling.
		 * 
		 * @inheritDoc
		 */
		override final protected function update() : void {
			
			if (isInvalid(UPDATE_PROPERTY_STYLE)) {
				redraw();
				return;
			}

			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				updateSize();
				return;
			}
			
			// for any other update property
			// e.g. if called validateNow() without any property
			redraw();
		}
		
		/**
		 * Calls invalidate() automatically after a style change
		 * notification has been received.
		 * 
		 * @inheritDoc
		 */
		override final protected function styleChanged(property : String, value : *) : void {
			// cannot be overridden from here

			invalidateProperty(UPDATE_PROPERTY_STYLE);
		}

		/**
		 * If not overridden, this method redraws all content.
		 * 
		 * <p>Override the method to work with scale9grid scaling rather
		 * than redrawing all content completely.</p>
		 * 
		 * @see com.sibirjak.asdpc.core.skins.BackgroundSkin.updateSize()
		 */
		protected function updateSize() : void {
			redraw();
		}

		/**
		 * Removes all content, calls draw().
		 * 
		 * <p>All content gets automatically removed and the draw() method
		 * called.</p>
		 */
		private function redraw() : void {
			// cannot be overridden from here

			while (numChildren) {
				removeChildAt(0);
			}
			
			graphics.clear();
		
			draw();
		}

	}
}

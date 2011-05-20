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
	 * Programmatic skin interface.
	 * 
	 * <p>A programmatic skin should implement this interface in order to
	 * get its methods invoked in a defined order.</p>
	 * 
	 * @author jes 14.08.2009
	 */
	public interface ISkin extends IDisplayObject {

		/**
		 * Sets the skin dimensions.
		 * 
		 * <p>The dimensions will initially be set from the owner view before the
		 * skin is added to the display hierarchy.</p>
		 * 
		 * @param width The skin width.
		 * @param height The skin height.
		 */
		function setSize(width : int, height : int) : void;

		/**
		 * Commands the skin to draw its content.
		 * 
		 * <p>The method is invoked after the skin has been added to the
		 * parent display object and every time a skin should be updated,
		 * e.g. if its size changed.</p>
		 * 
		 * <p>Updating a skin usually requires a full redraw. The drawSkin() method
		 * of an ISkin implementor should therefore remove all content before
		 * it redraws.</p>
		 */
		function drawSkin() : void;

	}
}

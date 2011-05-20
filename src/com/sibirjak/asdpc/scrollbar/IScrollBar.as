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
package com.sibirjak.asdpc.scrollbar {
	import com.sibirjak.asdpc.core.IControl;
	import com.sibirjak.asdpc.core.IView;

	import flash.display.DisplayObject;

	/**
	 * ScrollBar public interface.
	 * 
	 * @author jes 09.07.2009
	 */
	public interface IScrollBar extends IView, IControl {
		
		/**
		 * Sets the scrollbar owner.
		 * 
		 * <p>The scrollbar listens to the owners mouse wheel events.</p>
		 * 
		 * <p>Can only be set before the scrollbar ist added to the stage.</p>
		 */
		function set owner(owner : DisplayObject) : void;	

		/**
		 * @private
		 */
		function set direction(direction : String) : void;	
		
		/**
		 * Sets or returns the scrollbar direction.
		 * 
		 * <p>Can only be set before the scrollbar ist added to the stage.</p>
		 */
		function get direction() : String;
		
		/**
		 * @private
		 */
		function set enabled(enabled : Boolean) : void;
		
		/**
		 * Enables or disables the scrollbar.
		 * 
		 * <p>Returns true, if the scrollbar is currently enabled.</p>
		 * 
		 * @return true, if the scrollbar is enabled.
		 */
		function get enabled() : Boolean;
		
		/**
		 * Sets button, thumb and track scroll amounts.
		 * 
		 * @param buttonScroll The amout of pixels to scroll by a single button click.
		 * @param thumbScroll The minimal amout of pixels to scroll by moving the thumb.
		 * @param trackScroll The amout of pixels to scroll by click onto the scroll track.
		 */		
		function setScrollProperties(buttonScroll : uint, thumbScroll : uint, trackScroll : uint) : void;
		
		/**
		 * @private
		 */
		function set documentSize(documentSize : uint) : void;
		
		/**
		 * Sets or returns the document size.
		 * 
		 * <p>The document size is the entire height or width of the scrollbar owner.</p>
		 */
		function get documentSize() : uint;
		
		/**
		 * Scrolls to the given position.
		 * 
		 * <p>The method corrects the passed position and returns the
		 * corrected value.</p>
		 * 
		 * @param documentPosition The pixel position to scroll to.
		 * @return The corrected document position.
		 */
		function scrollTo(documentPosition : int) : int;
		
		/**
		 * The current document position.
		 */
		function get documentPosition() : int;
		
	}
}

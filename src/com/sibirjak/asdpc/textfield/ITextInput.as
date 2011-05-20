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
package com.sibirjak.asdpc.textfield {
	import com.sibirjak.asdpc.textfield.core.ITextField;

	/**
	 * TextInput public interface.
	 * 
	 * @author jes 04.11.2009
	 */
	public interface ITextInput extends ITextField {

		/**
		 * @private
		 */
		function set defaultText(text : String) : void;
		
		/**
		 * Sets or returns the text that is displayed if the use has not added text yet.
		 */
		function get defaultText() : String;

		/**
		 * Sets the focus into the TextInput instance.
		 */
		function setFocus() : void;
		
		/**
		 * Removes the focus from the TextInput instance.
		 */
		function clearFocus() : void;
		
		/**
		 * Preselects the text within the given range.
		 * 
		 * @param startIndex The first char index.
		 * @param startIndex The last char index.
		 */
		function setSelection(startIndex : uint, endIndex : uint) : void;

		/**
		 * Scrolls the text of the internal text field horizontally.
		 * 
		 * @param scrollPosition The index of the char to scroll to.
		 */
		function scrollTo(scrollPosition : uint) : void;
		
	}
}

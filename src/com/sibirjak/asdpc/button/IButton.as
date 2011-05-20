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
package com.sibirjak.asdpc.button {
	import com.sibirjak.asdpc.core.IBindableView;
	import com.sibirjak.asdpc.core.IControl;

	/**
	 * Button public interface.
	 * 
	 * @author jes 14.07.2009
	 */
	public interface IButton extends IBindableView, IControl {
		
		/**
		 * @private
		 */
		function set label(label : String) : void;
		
		/**
		 * The label displayed within the button.
		 */
		function get label() : String;
		
		/**
		 * @private
		 */
		function set selectedLabel(label : String) : void;
		
		/**
		 * The label text for the selected state.
		 */
		function get selectedLabel() : String;

		/**
		 * Sets a tool tip.
		 */
		function set toolTip(toolTip : String) : void;
		
		/**
		 * Sets a tool tip displayed in selected state.
		 */
		function set selectedToolTip(toolTip : String) : void;

		/**
		 * @private
		 */
		function set enabled(enabled : Boolean) : void;
		
		/**
		 * Enables or disables a button.
		 * 
		 * <p>True, if the button is currently enabled.</p>
		 */
		function get enabled() : Boolean;

		/**
		 * @private
		 */
		function set toggle(toggle : Boolean) : void;
		
		/**
		 * Converts a click button into a toggle button.
		 * 
		 * <p>True, if the button is a toggle button.</p>
		 * 
		 * <p>Can be set only before the button is added to the display list.</p>
		 * 
		 * <p>If toggle == true, auto repeat is not available.</p>
		 */
		function get toggle() : Boolean;
		
		/**
		 * @private
		 */
		function set selected(selected : Boolean) : void;
		
		/**
		 * Selectes or deselects a toggle button.
		 * 
		 * <p>True, if a toggle button is currently selected.</p>
		 * 
		 * <p>Setting to true has effect only to toggle buttons.</p>
		 */
		function get selected() : Boolean;
		
		/**
		 * @private
		 */
		function set autoRepeat(autoRepeat : Boolean) : void;

		/**
		 * Returns true, if the button has auto repeat enabled.
		 * 
		 * <p>Setting to true has effect only to click buttons.</p>
		 * 
		 * <p>You may specify repeat delay and rate via button styles.</p>
		 */
		function get autoRepeat() : Boolean;
		
	}
}

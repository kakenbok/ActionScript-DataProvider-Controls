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
	import com.sibirjak.asdpc.core.managers.IStyleManagerClient;
	import com.sibirjak.asdpc.core.managers.IViewPropertyManagerClient;

	/**
	 * View public interface.
	 * 
	 * @author jes 09.07.2009
	 */
	public interface IView extends IDisplayObjectContainer, IStyleManagerClient, IViewPropertyManagerClient {

		/*
		 * Global
		 */

		/**
		 * True, if the View is included in the display list.
		 */
		function get addedToStage() : Boolean;

		/*
		 * Geometry
		 */

		/**
		 * Sets the view dimensions.
		 * 
		 * <p>The dimensions must be set before the view is added to
		 * the display list in order to have these value available during
		 * the entire view life cycle.</p>
		 * 
		 * <p>The size can be reset at any time of the view life. Setting
		 * the size after the view has been added to the display list
		 * usually resizes the particular view and all of its children.</p>
		 * 
		 * @param width The view width.
		 * @param height The view height.
		 */
		function setSize(width : int, height : int) : void;

		/**
		 * Moves a view.
		 * 
		 * <p>This is rather a convenient method than a reliable access
		 * point. You may use view.x and view.y instead.</p>
		 * 
		 * @param x The x position.
		 * @param y The y position.
		 */
		function moveTo(x : int, y : int) : void;
		
		/*
		 * View life cycle public interface
		 */

		/**
		 * Commands a view to immediately validate all of its
		 * invalidate properties.
		 * 
		 * <p>A good place is after a number of properties has been
		 * set to a view, and the view should now update its
		 * representation.</p>
		 */
		function validateNow() : void;
		
		/**
		 * Commands a view to immediately clean up all of its content.
		 * 
		 * <p>The view is supposed to clean up any event listeners,
		 * property bindings and all other references.</p>
		 * 
		 * <p>The view is also in charge to clean up its children.</p>
		 */
		function cleanUp() : void;

		/**
		 * @copy com.sibirjak.asdpc.core.managers.ViewPropertyManager#setViewProperty()
		 */
		function setViewProperty(property : String, value : *) : void;
		
		/**
		 * Gets a property value.
		 * 
		 * @param property The name of the property.
		 * @return The value of the property.
		 */
		function getViewProperty(property : String) : *;

		/*
		 * Style handling
		 */

		/**
		 * @copy com.sibirjak.asdpc.core.managers.StyleManager#setDefaultStyles()
		 */
		function setDefaultStyles(defaultStyles : Array) : void;

		/**
		 * @copy com.sibirjak.asdpc.core.managers.StyleManager#getDefaultStyles()
		 */
		function getDefaultStyles() : Array;

		/**
		 * @copy com.sibirjak.asdpc.core.managers.StyleManager#setStyle()
		 */
		function setStyle(property : String, value : *, selectorChain : Array = null, excludeChain : Array = null) : void;
		
		/**
		 * @copy com.sibirjak.asdpc.core.managers.StyleManager#setStyles()
		 */
		function setStyles(styles : Array, selectorChain : Array = null, excludeChain : Array = null) : void;

		/**
		 * @copy com.sibirjak.asdpc.core.managers.StyleManager#getStyle()
		 */
		function getStyle(property : String) : *;

	}
}

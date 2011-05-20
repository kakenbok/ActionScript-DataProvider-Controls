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
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;

	/**
	 * Interface to many of the native Flash DisplayObject methods.
	 * 
	 * @author jes 23.07.2009
	 */
	public interface IDisplayObject extends IEventDispatcher {

		/*
		 * Name
		 */
		
		function set name(name : String) : void;

		function get name() : String;

		/*
		 * Position
		 */
		
		function set x(x : Number) : void;

		function get x() : Number;

		function set y(y : Number) : void;

		function get y() : Number;

		/*
		 * Dimensions
		 */

		function get width() : Number;

		function get height() : Number;

		function set scaleX(scaleX : Number) : void;

		function get scaleX() : Number;

		function set scaleY(scaleY : Number) : void;

		function get scaleY() : Number;

		/*
		 * Visibility
		 */

		function set visible(visible : Boolean) : void;

		function get visible() : Boolean;

		function set alpha(alpha : Number) : void;

		function get alpha() : Number;

		/*
		 * Mask
		 */

		function get mask() : DisplayObject;
		
		function set mask(value : DisplayObject) : void;

		/*
		 * Mouse
		 */

		function set mouseEnabled(mouseEnabled : Boolean) : void; 

		/*
		 * Display hierarchy
		 */

		function get stage() : Stage;

	}
}

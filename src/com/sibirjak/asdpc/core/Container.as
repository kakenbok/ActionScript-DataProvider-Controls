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
	import com.sibirjak.asdpc.core.managers.StyleManager;

	import flash.display.Sprite;

	/**
	 * Sprite with style inheritance support.
	 * 
	 * <p>In order of a working style management the display list must not
	 * be interrupted by non IStyleManagerClient instances such as Sprite is.
	 * In all the cases we only need a lightweight display object container
	 * we should use the Container then rather than the more heavy View.</p>
	 * 
	 * @author jes 15.12.2009
	 */
	public class Container extends Sprite implements IStyleManagerClient {

		/**
		 * StyleManager instance.
		 */
		protected var _styleManager : StyleManager;
		
		/**
		 * Container constructor.
		 */
		public function Container() {
			_styleManager = new StyleManager(this);
		}

		/*
		 * IStyleManagerClient
		 */

		/**
		 * @inheritDoc
		 */
		public final function get styleManager() : StyleManager {
			return _styleManager;
		}

		/**
		 * @inheritDoc
		 */
		public function styleManagerStyleChangeHandler(property : String, value : *) : void {
		}
		
	}
}

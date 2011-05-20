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
	import com.sibirjak.asdpc.core.IDisplayObject;

	/**
	 * StyleManagerClient interface.
	 * 
	 * <p>Any Flash display object can implement this interface an thus get styling
	 * capabilities.</p>
	 * 
	 * <p>Each StyleManagerClient hosts its own distinctive StyleManager instance.</p>
	 * 
	 * @author jes 17.08.2009
	 */
	public interface IStyleManagerClient extends IDisplayObject {
		
		/**
		 * The clients StyleManager instance.
		 * 
		 * <p>This instance is usually set within the client's constructor.</p>
		 */
		function get styleManager() : StyleManager;

		/**
		 * Notifies the client about a change of a style value for that it
		 * defines a default style.
		 * 
		 * <p>To generally get notifications from the style manager, you need to
		 * declare all particular styles via the StyleManager.setDefaultStyles()
		 * method. You do this at best in the constructor of the client.</p>
		 * 
		 * <p>If this method has been called, you should update your client to
		 * reflect the changes in its visualisation.</p>
		 * 
		 * @param property The style name.
		 * @param value The style value.
		 */
		function styleManagerStyleChangeHandler(property : String, value : *) : void;

	}
}

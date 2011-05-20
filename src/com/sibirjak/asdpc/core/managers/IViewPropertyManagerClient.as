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

	/**
	 * ViewPropertyManagerClient interface.
	 * 
	 * <p>An IViewPropertyManagerClient can host an unlimited number of
	 * property-value-pairs, which are accessible throughout the entire
	 * display list.</p> 
	 * 
	 * <p>Each ViewPropertyManagerClient hosts its own distinctive
	 * ViewPropertyManager instance.</p>
	 * 
	 * @author jes 03.12.2009
	 */
	public interface IViewPropertyManagerClient {

		/**
		 * The clients ViewPropertyManager instance.
		 * 
		 * <p>The ViewPropertyManager instance is usually set
		 * within the client's constructor.</p>
		 */
		function get viewPropertyManager() : ViewPropertyManager;

	}
}

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
package com.sibirjak.asdpc.core.dataprovider.adapter {
	import com.sibirjak.asdpc.core.dataprovider.IDataSourceAdapter;

	/**
	 * Array to IDataProvider adapter.
	 * 
	 * @author jes 29.07.2009
	 */
	public class ArrayAdapter implements IDataSourceAdapter {
		
		/**
		 * The adapted array.
		 */
		private var _array : Array;
		
		/**
		 * ArrayAdapter constructor.
		 * 
		 * @param array The array to adapt.
		 */
		public function ArrayAdapter(array : Array) {
			_array = array;
		}

		/*
		 * IDataProvider
		 */
		
		/**
		 * @inheritDoc
		 */
		public function itemAt(index : uint) : * {
			return _array[index];
		}

		/**
		 * @inheritDoc
		 */
		public function get size() : uint {
			return _array.length;
		}
		
		/*
		 * IDataSourceAdapter
		 */

		/**
		 * @inheritDoc
		 */
		public function get dataSource() : * {
			return _array;
		}

		/**
		 * @inheritDoc
		 */
		public function cleanUp() : void {
			// no listener to clean up
		}

		/*
		 * Info
		 */

		/**
		 * toString() function.
		 */
		public function toString() : String {
			return "[ArrayAdapter] items:" + size;
		}
		
	}
}

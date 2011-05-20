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
package com.sibirjak.asdpc.core.dataprovider {
	import flash.events.EventDispatcher;

	/**
	 * Convenient base class for event dispatching data source adapters.
	 * 
	 * @author jes 29.07.2009
	 */
	public class DataProviderEventDispatcher extends EventDispatcher {

		/**
		 * Dispatches a DataProviderEvent event of kind ITEM_ADDED.
		 * 
		 * @param index The index where the items have been added.
		 * @param numItems The number of items added.
		 */
		protected final function dispatchItemsAdded(index : uint, numItems : uint) : void {
			dispatchEvent(new DataProviderEvent(
				DataProviderEvent.ITEM_ADDED, index, numItems
			));
		}

		/**
		 * Dispatches a DataProviderEvent event of kind ITEM_REMOVED.
		 * 
		 * @param index The index where the items have been removed.
		 * @param numItems The number of items removed.
		 */
		protected final function dispatchItemsRemoved(index : uint, numItems : uint) : void {
			dispatchEvent(new DataProviderEvent(
				DataProviderEvent.ITEM_REMOVED, index, numItems
			));
		}

		/**
		 * Dispatches a DataProviderEvent event of kind RESET.
		 */
		protected final function dispatchReset() : void {
			dispatchEvent(new DataProviderEvent(DataProviderEvent.RESET));
		}

	}
}

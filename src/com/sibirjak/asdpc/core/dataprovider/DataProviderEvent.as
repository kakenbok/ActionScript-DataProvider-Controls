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
	import flash.events.Event;

	/**
	 * DataProvider event.
	 * 
	 * @author jes 24.07.2009
	 */
	public class DataProviderEvent extends Event {
		
		/**
		 * Event type of all data provider events.
		 */
		public static const DATA_PROVIDER_CHANGED : String = "data_provider_changed";
		
		/**
		 * Event kind ITEM_ADDED
		 */
		public static const ITEM_ADDED : String = "itemAdded";

		/**
		 * Event kind ITEM_REMOVED
		 */
		public static const ITEM_REMOVED : String = "itemRemoved";

		/**
		 * Event kind RESET
		 */
		public static const RESET : String = "reset";

		/**
		 * The event kind.
		 */
		public var kind : String;

		/**
		 * The affected index.
		 * 
		 * <p>Not set (-1) for the RESET event kind.</p>
		 */
		public var index : int;

		/**
		 * The number of affected items.
		 * 
		 * <p>Not set (0) for the RESET event kind.</p>
		 */
		public var numItems : uint;

		/**
		 * DataProviderEvent constructor.
		 * 
		 * @param kind The event kind.
		 * @param theIndex The affected index.
		 * @param theNumItems The number of affected items.
		 */
		public function DataProviderEvent(theKind : String, theIndex : int = -1, theNumItems : uint = 0) {
			kind = theKind;
			index = theIndex;
			numItems = theNumItems;
			
			super(DATA_PROVIDER_CHANGED, false, false);
		}

	}
}

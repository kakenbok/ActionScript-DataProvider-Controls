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
	import com.sibirjak.asdpc.core.dataprovider.DataProviderEventDispatcher;
	import com.sibirjak.asdpc.core.dataprovider.IDataSourceAdapter;

	import org.as3commons.collections.framework.ICollectionFx;
	import org.as3commons.collections.framework.IList;
	import org.as3commons.collections.fx.events.CollectionEvent;
	import org.as3commons.collections.fx.events.ListEvent;

	/**
	 * ArrayList to IDataProvider adapter.
	 * 
	 * @author jes 29.07.2009
	 */
	public class ListAdapter extends DataProviderEventDispatcher implements IDataSourceAdapter {

		/**
		 * The adapted ArrayList.
		 */
		private var _list : IList;
		
		/**
		 * ArrayListAdapter constructor.
		 * 
		 * @param list The ArrayList to adapt.
		 */
		public function ListAdapter(list : IList) {
			_list = list;

			if (_list is ICollectionFx) {
				ICollectionFx(_list).addEventListener(CollectionEvent.COLLECTION_CHANGED, collectionChangedHandler);
			}
		}

		/*
		 * IDataProvider
		 */
		
		/**
		 * @inheritDoc
		 */
		public function itemAt(index : uint) : * {
			return _list.itemAt(index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get size() : uint {
			return _list.size;
		}
		
		/*
		 * IDataSourceAdapter
		 */

		/**
		 * @inheritDoc
		 */
		public function get dataSource() : * {
			return _list;
		}

		/**
		 * @inheritDoc
		 */
		public function cleanUp() : void {
			if (_list is ICollectionFx) {
				ICollectionFx(_list).removeEventListener(CollectionEvent.COLLECTION_CHANGED, collectionChangedHandler);
			}
		}

		/*
		 * Info
		 */

		/**
		 * toString() function.
		 */
		override public function toString() : String {
			return "[ArrayListAdapter] items:" + size;
		}
			
		/*
		 * Private
		 */
		
		/**
		 * Handler for changes of the ArrayList data.
		 */
		private function collectionChangedHandler(event : ListEvent) : void {
			
			switch (event.kind) {

				case CollectionEvent.ITEM_ADDED:
					dispatchItemsAdded(event.index, event.numItems);
					break;

				case CollectionEvent.ITEM_REMOVED:
					dispatchItemsRemoved(event.index, event.numItems);
					break;

				case CollectionEvent.ITEM_REPLACED:
					dispatchItemsRemoved(event.index, 1);
					dispatchItemsAdded(event.index, 1);
					break;

				case CollectionEvent.RESET:
					dispatchReset();
					break;
			}
			
		}
		
	}
}

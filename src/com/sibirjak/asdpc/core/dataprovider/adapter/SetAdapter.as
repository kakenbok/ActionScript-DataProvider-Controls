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
	import com.sibirjak.asdpc.core.dataprovider.Index;

	import org.as3commons.collections.framework.ICollectionFx;
	import org.as3commons.collections.framework.ISet;
	import org.as3commons.collections.framework.ISetIterator;
	import org.as3commons.collections.fx.events.CollectionEvent;
	import org.as3commons.collections.fx.events.SetEvent;

	/**
	 * Set to IDataProvider adapter.
	 * 
	 * @author jes 29.07.2009
	 */
	public class SetAdapter extends DataProviderEventDispatcher implements IDataSourceAdapter {

		/**
		 * The adapted Set.
		 */
		private var _set : ISet;

		/**
		 * Set item to index map.
		 */
		private var _index : Index;
		
		/**
		 * SetAdapter constructor.
		 * 
		 * @param theSet The set to adapt.
		 */
		public function SetAdapter(theSet : ISet) {
			_set = theSet;
			
			createIndex();
		}

		/*
		 * IDataProvider
		 */
		
		/**
		 * @inheritDoc
		 */
		public function itemAt(index : uint) : * {
			return _index.itemAt(index);
		}

		/**
		 * @inheritDoc
		 */
		public function get size() : uint {
			return _set.size;
		}

		/*
		 * IDataSourceAdapter
		 */

		/**
		 * @inheritDoc
		 */
		public function get dataSource() : * {
			return _set;
		}

		/**
		 * @inheritDoc
		 */
		public function cleanUp() : void {
			if (_set is ICollectionFx) {
				ICollectionFx(_set).removeEventListener(CollectionEvent.COLLECTION_CHANGED, collectionChangedHandler);
			}
		}

		/*
		 * IEventDispatcher
		 */

		/**
		 * Creates the Set item to index map at the point the first listener is registered to the adapter.
		 * 
		 * @inheritDoc
		 */
		override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			if (!_index) createIndex();
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/*
		 * Info
		 */

		/**
		 * toString() function.
		 */
		override public function toString() : String {
			return "[SetAdapter] items:" + size;
		}

		/*
		 * Private
		 */
		
		/**
		 * Initialises the Set item to index map.
		 */
		private function createIndex() : void {
			_index = new Index();

			_index.init(_set.iterator());

			//trace ("add event listener to " + _set + " in SetAdapter");
			if (_set is ICollectionFx) {
				ICollectionFx(_set).addEventListener(CollectionEvent.COLLECTION_CHANGED, collectionChangedHandler);
			}
		}

		/**
		 * Handler for changes of the Set data.
		 */
		private function collectionChangedHandler(event : SetEvent) : void {
			var iterator : ISetIterator;
			var index : uint;

			switch (event.kind) {

				case CollectionEvent.ITEM_ADDED:
					iterator = event.iterator() as ISetIterator;
					index = _index.addItemsAfter(iterator.previousItem, [event.item]);
					dispatchItemsAdded(index, 1);
					break;

				case CollectionEvent.ITEM_REMOVED:
					iterator = event.iterator() as ISetIterator;
					index = _index.removeItemsAfter(iterator.previousItem, 1);
					dispatchItemsRemoved(index, 1);
					break;

				case CollectionEvent.ITEM_REPLACED:
					// dispatched by LinkedSetFx
					iterator = event.iterator() as ISetIterator;
					index = _index.indexOf(iterator.previousItem);
					
					dispatchItemsRemoved(index + 1, 1);
					dispatchItemsAdded(index + 1, 1);
					break;

				case CollectionEvent.RESET:
					_index.clear();
					_index.init(_set.iterator());

					dispatchReset();
					break;

			}
		}
		
	}
}

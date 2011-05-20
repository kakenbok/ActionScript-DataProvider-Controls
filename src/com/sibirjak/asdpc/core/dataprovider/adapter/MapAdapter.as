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
	import com.sibirjak.asdpc.core.dataprovider.IMapAdapter;
	import com.sibirjak.asdpc.core.dataprovider.Index;

	import org.as3commons.collections.framework.ICollectionFx;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.collections.framework.IMapIterator;
	import org.as3commons.collections.fx.events.CollectionEvent;
	import org.as3commons.collections.fx.events.MapEvent;

	/**
	 * Map to IDataProvider adapter.
	 * 
	 * @author jes 29.07.2009
	 */
	public class MapAdapter extends DataProviderEventDispatcher implements IMapAdapter, IDataSourceAdapter {
		
		/**
		 * The adapted Map.
		 */
		private var _map : IMap;

		/**
		 * Map item to index map.
		 */
		private var _index : Index;
		
		/**
		 * MapAdapter constructor.
		 * 
		 * @param map The map to adapt.
		 */
		public function MapAdapter(map : IMap) {
			_map = map;
		}
		
		/*
		 * IDataProvider
		 */
		
		/**
		 * @inheritDoc
		 */
		public function itemAt(index : uint) : * {
			if (!_index) createIndex();

			return _map.itemFor(_index.itemAt(index));
		}

		/**
		 * @inheritDoc
		 */
		public function get size() : uint {
			return _map.size;
		}

		/*
		 * IMapAdapter
		 */

		/**
		 * @inheritDoc
		 */
		public function getKeyAt(index : uint) : * {
			if (!_index) createIndex();
			
			return _index.itemAt(index);
		}

		/*
		 * IDataSourceAdapter
		 */

		/**
		 * @inheritDoc
		 */
		public function get dataSource() : * {
			return _map;
		}

		/**
		 * @inheritDoc
		 */
		public function cleanUp() : void {
			if (_map is ICollectionFx) {
				ICollectionFx(_map).removeEventListener(CollectionEvent.COLLECTION_CHANGED, collectionChangedHandler);
			}
		}

		/*
		 * IEventDispatcher
		 */

		/**
		 * Creates the Map item to index map at the point the first listener is registered to the adapter.
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
			return "[MapAdapter] items:" + size;
		}

		/*
		 * Private
		 */
		
		/**
		 * Initialises the Map item to index map.
		 */
		private function createIndex() : void {
			_index = new Index();

			_index.init(_map.keyIterator());

			if (_map is ICollectionFx) {
				ICollectionFx(_map).addEventListener(CollectionEvent.COLLECTION_CHANGED, collectionChangedHandler);
			}
		}

		/**
		 * Handler for changes of the Map data.
		 */
		private function collectionChangedHandler(event : MapEvent) : void {
			var iterator : IMapIterator;
			var index : uint;

			switch (event.kind) {

				case CollectionEvent.ITEM_ADDED:
					iterator = event.iterator() as IMapIterator;
					index = _index.addItemsAfter(iterator.previousKey, [event.key]);
					dispatchItemsAdded(index, 1);
					break;

				case CollectionEvent.ITEM_REMOVED:
					iterator = event.iterator() as IMapIterator;
					index = _index.removeItemsAfter(iterator.previousKey, 1);
					dispatchItemsRemoved(index, 1);
					break;

				case CollectionEvent.ITEM_REPLACED:
					// dispatched by MapFx, LinkedMapFx and not by SortedMapFx
					iterator = event.iterator() as IMapIterator;
					index = _index.indexOf(iterator.previousKey);
					
					dispatchItemsRemoved(index + 1, 1);
					dispatchItemsAdded(index + 1, 1);
					break;

				case CollectionEvent.RESET:
					_index.clear();
					_index.init(_map.keyIterator());

					dispatchReset();
					break;

			}
		}
		
	}
}

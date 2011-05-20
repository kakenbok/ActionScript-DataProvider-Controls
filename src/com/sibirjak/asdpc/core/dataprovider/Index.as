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
	import org.as3commons.collections.framework.IIterator;

	import flash.utils.Dictionary;

	/**
	 * Maintains a data source index for not index based collections.
	 * 
	 * <p>The Index is technically an ArraySet where items can be accessed
	 * via an index or via the item directly. Items have to be unique.</p>
	 * 
	 * @author jes 30.07.2009
	 */
	public class Index {

		/**
		 * The indexed items.
		 */
		protected var _items : Array;

		/**
		 * The item to index map.
		 */
		protected var _index : Dictionary;

		/**
		 * The number of indexed items.
		 */
		protected var _size : uint;
		
		/**
		 * Index constructor.
		 */
		public function Index() {
			_items = new Array();
			_index = new Dictionary();
		}
		
		/*
		 * Add items
		 */

		/**
		 * Initialises the Index.
		 * 
		 * <p>If the index already contains items, new items will be appended.</p>
		 * 
		 * @param source Either an Array or an IIterator. 
		 */
		public function init(source : *) : void {
			var i : uint;

			if (source is IIterator) {
				var iterator : IIterator = source;
				var item : *;
				while (iterator.hasNext()) {
					item = iterator.next();
					i = _items.push(item);
					_index[item] = i - 1;
					_size++;
				}
				
			} else { // array
				var array : Array = source;
				for (i = 0; i < array.length; i++) {
					_index[array[i]] = i;
					_size++;
				}
			}
			
		}

		/**
		 * Adds a list of items after the given one.
		 * 
		 * @param itemBefore The item after that the new items should be added.
		 * @param items The items to add.
		 * @param The index on that the items have been added.
		 */
		public function addItemsAfter(itemBefore : *, items : Array) : int {
			if (itemBefore && _index[itemBefore] === undefined) return -1;

			var index : uint;
			var indexBefore : uint = itemBefore ? _index[itemBefore] : -1;
			index = indexBefore + 1;
			
			_items = _items.slice(0, index).concat(items).concat(_items.slice(index));
			
			_size += items.length;
			
			updateIndexAt(index);

			return index;
		}
		
		/**
		 * Adds a list of items at start.
		 * 
		 * @param items The items to add at start.
		 * @param The index on that the items have been added.
		 */
		public function addItemsAtStart(items : Array) : int {
			return addItemsAfter(null, items);
		}

		/**
		 * Adds a list of items at end.
		 * 
		 * @param items The items to add at end.
		 * @param The index on that the items have been added.
		 */
		public function addItemsAtEnd(items : Array) : int {
			if (_size) {
				return addItemsAfter(_items[_size - 1], items);
			} else {
				return addItemsAfter(null, items);
			}
		}

		/*
		 * Remove items
		 */

		/**
		 * Removes a number of items after the given one.
		 * 
		 * @param itemBefore The item after that the items should be removed.
		 * @param numItems The number of items to remove.
		 * @param The index on that the items have been removed.
		 */
		public function removeItemsAfter(itemBefore : *, numItems : uint) : int {
			if (itemBefore && _index[itemBefore] === undefined) return -1;

			var indexBefore : uint = itemBefore ? _index[itemBefore] : -1;
			var index : uint = indexBefore + 1;

			var removed : Array = _items.splice(index, numItems);
			for (var i : uint = 0; i < removed.length; i++) {
				delete _index[removed[i]];
			}
			
			_size -= i;
			
			updateIndexAt(index);

			return index;
		}
		
		/**
		 * Removes a number of items at start.
		 * 
		 * @param numItems The number of items to remove.
		 * @param The index on that the items have been removed.
		 */
		public function removeItemsAtStart(numItems : uint) : int {
			return removeItemsAfter(null, numItems);
		}

		/**
		 * Removes a number of items at end.
		 * 
		 * @param numItems The number of items to remove.
		 * @param The index on that the items have been removed.
		 */
		public function removeItemsAtEnd(numItems : uint) : int {
			if (_size > numItems) {
				return removeItemsAfter(_items[_size - numItems - 1], numItems);
			} else {
				return removeItemsAfter(null, numItems);
			}
		}

		/*
		 * Get or test items
		 */

		/**
		 * Returns true, if the item is in the Index.
		 * 
		 * @param item The item to test.
		 * @return true, if the item is contained by the Index.
		 */
		public function hasItem(item : *) : Boolean {
			return _index[item] !== undefined;
		}

		/**
		 * Returns the item at the given position.
		 * 
		 * @param index The position.
		 * @return The item at that position or undefined, if no such item exists.
		 */
		public function itemAt(index : uint) : * {
			return _items[index];
		}

		/**
		 * Returns the index for a given item.
		 * 
		 * @param item The item.
		 * @return The item index or -1, if the item is not contained by the Index.
		 */
		public function indexOf(item : *) : int {
			if (_index[item] === undefined) return -1;
			return _index[item];
		}
		
		/*
		 * ICollection
		 */
		
		/**
		 * Clears the Index.
		 */
		public function clear() : void {
			_items = new Array();
			_index = new Dictionary();
			_size = 0;
		}
		
		/**
		 * Returns the number of indexed items.
		 * 
		 * @return The number of indexed items.
		 */
		public function get size() : uint {
			return _size;
		}
		
		/*
		 * Private
		 */
		
		/**
		 * Updates the item to index map starting from the given position.
		 */
		private function updateIndexAt(index : uint) : void {
			for (var i : uint = index; i < _items.length; i++) {
				_index[_items[i]] = i;
			}
		}
		
	}
}

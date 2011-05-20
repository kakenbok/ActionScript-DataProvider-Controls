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
package com.sibirjak.asdpc.listview.core {
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.utils.NumericComparator;

	/**
	 * Manager for item indices.
	 * 
	 * <p>The ItemIndexManager maintains a subset of indices of a data provider
	 * and modifies the subset after insert or deletion operations.</p>
	 * 
	 * <p>Example: A multiselect list stores its selected indices in an ItemIndexManager
	 * instance. If items are removed from or added to the data provider, all selected
	 * indices after the removal or insertion point require an update.</p>
	 * 
	 * @author jes 11.12.2009
	 */
	public class ItemIndexManager extends SortedList {
		
		/**
		 * ItemIndexManager constructor.
		 */
		public function ItemIndexManager() {
			super(new NumericComparator());
		}

		/**
		 * Updates the index of all succeeding items.
		 * 
		 * @param index Index where items have been added.
		 * @param numItems Number of items added.
		 */
		public function itemsAddedAt(index : uint, numItems : uint) : void {
			var itemIndex : int = firstIndexOfEqual(index);
			var firstIndexToUpdate : uint;

			// no open item at index 
			if (itemIndex < 0) {
				firstIndexToUpdate = - itemIndex - 1;

			// open item at index exists	
			} else {
				firstIndexToUpdate = itemIndex;
			}
			
			for (var i : uint = firstIndexToUpdate; i < _array.length; i++) {
				_array[i] += numItems;
			}
		}

		/**
		 * Updates the index of all succeeding items.
		 * 
		 * @param index Index where items have been removed.
		 * @param numItems Number of items removed.
		 * @return An array of all removed indices.
		 */
		public function itemsRemovedAt(index : uint, numItems : uint) : Array {
			
			var itemIndex : int = firstIndexOfEqual(index);
			var firstIndexToUpdate : uint;
			var removedItems : Array = new Array();

			// no open item at index 
			if (itemIndex < 0) {
				firstIndexToUpdate = - itemIndex - 1;

			// open item at index exists	
			} else {
				firstIndexToUpdate = itemIndex;
			}
			
			for (var i : uint = firstIndexToUpdate; i < _array.length; i++) {
				if (_array[i] < index + numItems) {
					removedItems.push(_array[i]);
					remove(_array[i]);
					i--;				
				} else {
					_array[i] -= numItems;
				}
			}
			
			return removedItems;

		}

		/**
		 * Returns the number of items before the given index.
		 * 
		 * @param index Index to test.
		 * @return The number of items stored with a lesser index.
		 */
		public function numItemsBefore(index : uint) : uint {
			var itemIndex : int = firstIndexOfEqual(index);
			
			// no open item at index 
			if (itemIndex < 0) {
				return - itemIndex - 1;

			// open item at index exists	
			} else {
				return itemIndex;
			}
		}

		/**
		 * Adds an index to the list.
		 * 
		 * @param index The index to add.
		 * @return true, if the index has been added or false, if the index is already contained.
		 */
		public function addIndex(index : uint) : Boolean {
			if (has(index)) return false;
			add(index);
			return true;
		}

		/**
		 * Removes an index from the list.
		 * 
		 * @param index The index to remove.
		 * @return true, if the index has been removed or false, if the index was not contained.
		 */
		public function removeIndex(index : uint) : Boolean {
			return remove(index);
		}

		/**
		 * Empties the index list.
		 * 
		 * <p>Returns an array of all maintained indices before
		 * cleaning up.</p>
		 * 
		 * @return An array of all removed indices.
		 */
		public function removeAllIndices() : Array {
			var items : Array = toArray();
			super.clear();
			return items;
		}

		/**
		 * Tests, if an index is contained.
		 * 
		 * @param index The index to test.
		 * @return true, if the index is contained, else false.
		 */
		public function hasIndex(index : uint) : Boolean {
			var itemIndex : int = firstIndexOfEqual(index);
			return itemIndex >= 0;
		}

		/**
		 * Returns the first stored index.
		 * 
		 * @return The first index or -1 if the index list is emtpy.
		 */
		public function get firstIndex() : int {
			return _array.length ? _array[0] : -1;
		}

		/**
		 * Returns an array of all stored indices.
		 * 
		 * @return An array of all stored indices.
		 */
		public function get indices() : Array {
			return _array;
		}
		
	}
}

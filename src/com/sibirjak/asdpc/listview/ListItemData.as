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
package com.sibirjak.asdpc.listview {
	import com.sibirjak.asdpc.core.asdpc_internal;
	
	use namespace asdpc_internal;

	/**
	 * Plain data object representing list item data and list item state.
	 * 
	 * @author jes 14.12.2009
	 */
	public class ListItemData {

		/*
		 * Properties
		 */

		/**
		 * The position of the item in the list.
		 */
		private var _listIndex : uint;

		/**
		 * The items containing collection.
		 */
		private var _parentItem : *;

		/**
		 * The postion of the item in the containing collection.
		 */
		private var _itemIndex : uint;

		/**
		 * The item.
		 */
		private var _item : *;

		/**
		 * The key of the item, if the containing collection is a map.
		 */
		private var _itemKey : *;

		/**
		 * Selection status of the list item.
		 */
		private var _selected : Boolean;
		
		/*
		 * Getter
		 */

		/**
		 * The position of the item in the listView.
		 */
		public function get listIndex() : int {
			return _listIndex;
		}
		
		/**
		 * The item's containing collection.
		 * 
		 * <p>ListView: Returns the listView's data source.</p>
		 * 
		 * <p>TreeView: Returns the parent nodes data source.</p>
		 */
		public function get parentItem() : * {
			return _parentItem;
		}

		/**
		 * The position of the item in the containing collection.
		 * 
		 * <p>ListView: Returns the position of the item in the listView's
		 * data source.</p>
		 * 
		 * <p>TreeView: Returns the position of the item in the parent
		 * nodes data source. The first child of the root node will have
		 * a listIndex of 2 and an itemIndex of 1.</p>
		 */
		public function get itemIndex() : uint {
			return _itemIndex;
		}

		/**
		 * The item.
		 */
		public function get item() : * {
			return _item;
		}

		/**
		 * The key of the item if the containing collection is an IMap.
		 */
		public function get itemKey() : * {
			return _itemKey;
		}

		/**
		 * True if the list item is selected.
		 */
		public function get selected() : Boolean {
			return _selected;
		}
		
		/*
		 * Internal setter
		 */

		/**
		 * Sets the list index.
		 * 
		 * @param listIndex The list index.
		 */
		asdpc_internal function setListIndex_internal(listIndex : uint) : void {
			_listIndex = listIndex;
		}
		
		/**
		 * Sets the parent collection.
		 * 
		 * @param parentItem The parent collection.
		 */
		asdpc_internal function setParentItem_internal(parentItem : *) : void {
			_parentItem = parentItem;
		}
		
		/**
		 * Sets the item index.
		 * 
		 * @param itemIndex The item index.
		 */
		asdpc_internal function setItemIndex_internal(itemIndex : uint) : void {
			_itemIndex = itemIndex;
		}
		
		/**
		 * Sets the item.
		 * 
		 * @param item The item.
		 */
		asdpc_internal function setItem_internal(item : *) : void {
			_item = item;
		}

		/**
		 * Sets the item key.
		 * 
		 * @param itemKey The item key.
		 */
		asdpc_internal function setItemKey_internal(itemKey : *) : void {
			_itemKey = itemKey;
		}

		/**
		 * Sets the selected flag.
		 * 
		 * @param selected The selected flag.
		 */
		asdpc_internal function setSelected_internal(selected : Boolean) : void {
			_selected = selected;
		}

	}
}

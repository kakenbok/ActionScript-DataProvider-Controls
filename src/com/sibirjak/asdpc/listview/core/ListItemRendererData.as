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
	import com.sibirjak.asdpc.core.asdpc_internal;
	import com.sibirjak.asdpc.listview.ListItemData;
	import com.sibirjak.asdpc.listview.ListView;
	
	use namespace asdpc_internal;

	/**
	 * Data object passed to a IListItemRenderer and representing the item to render.
	 * 
	 * <p>While the ListItemData only describes an item of a data source,
	 * the ListItemRendererData provides more information about the visual
	 * state of the ListView. The ListItemRendererData object also provides
	 * operations to modify the list. A ListItemData object is available outside
	 * of the ListView. A ListItemRendererData object is only visble to
	 * ListItemRenderer instances and their children.</p>
	 * 
	 * @author jes 08.07.2009
	 */
	public class ListItemRendererData {
		
		/**
		 * ListItemData instance.
		 */
		protected var _listItemData : ListItemData;

		/**
		 * ListView reference.
		 */
		protected var _listView : ListView;

		/**
		 * Flag to indicate, if the item is the first item of the listView.
		 */
		protected var _isFirst : Boolean;

		/**
		 * Flag to indicate, if the item is the last item of the listView.
		 */
		protected var _isLast : Boolean;

		/*
		 * ListItemRenderer
		 */
		
		/**
		 * True, if the item is the first item of the listView.
		 */
		public function get isFirst() : Boolean {
			return _isFirst;
		}

		/**
		 * True, if the item is the last item of the listView.
		 */
		public function get isLast() : Boolean {
			return _isLast;
		}

		/*
		 * ListItemData
		 */

		/**
		 * The internal ListItemData object.
		 */
		public function get listItemData() : ListItemData {
			return _listItemData;
		}

		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemData#listIndex
		 */
		public function get listIndex() : int {
			return _listItemData.listIndex;
		}
		
		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemData#parentItem
		 */
		public function get parentItem() : * {
			return _listItemData.parentItem;
		}

		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemData#itemIndex
		 */
		public function get itemIndex() : uint {
			return _listItemData.itemIndex;
		}

		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemData#item
		 */
		public function get item() : * {
			return _listItemData.item;
		}

		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemData#itemKey
		 */
		public function get itemKey() : * {
			return _listItemData.itemKey;
		}

		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemData#selected
		 */
		public function get selected() : Boolean {
			return _listItemData.selected;
		}

		/*
		 * ListItemRenderer operations
		 */

		/**
		 * Notifies the listView about a roll over event.
		 */
		public function notifyRollOver() : void {
			_listView.notifyRollOverRendererAt_internal(listIndex);
		}

		/**
		 * Notifies the listView about a roll out event.
		 */
		public function notifyRollOut() : void {
			_listView.notifyRollOutRendererAt_internal(listIndex);
		}

		/**
		 * Notifies the listView about a mouse down event.
		 * 
		 * @param ctrlKey Indicates, if the ctrl key has been pressed simultaneously.
		 */
		public function notifyMouseDown() : void {
			_listView.notifyMouseDownRendererAt_internal(listIndex);
		}

		/**
		 * Notifies the listView about a click event.
		 * 
		 * @param ctrlKey Indicates, if the ctrl key has been pressed simultaneously.
		 */
		public function notifyClick() : void {
			_listView.notifyClickRendererAt_internal(listIndex);
		}

		/**
		 * Notifies the listView, that the item is to select.
		 */
		public function select() : void {
			_listView.selectItemAt_internal(listIndex);
		}
		
		/**
		 * Notifies the listView, that the item is to deselect.
		 */
		public function deselect() : void {
			_listView.deselectItemAt_internal(listIndex);
		}

		/*
		 * asdpc_internal
		 */

		/**
		 * Sets the ListItemData object.
		 * 
		 * @param listItemData The ListItemData object.
		 */
		asdpc_internal function setListItemData_internal(listItemData : ListItemData) : void {
			_listItemData = listItemData;
		}
		
		/**
		 * Sets the ListView reference.
		 * 
		 * @param list The ListView reference.
		 */
		asdpc_internal function setListView_internal(list : ListView) : void {
			_listView = list;
		}
		
		/**
		 * Sets the isFirst flag.
		 * 
		 * @param isFirst The isFirst flag.
		 */
		asdpc_internal function setIsFirst_internal(isFirst : Boolean) : void {
			_isFirst = isFirst;
		}
		
		/**
		 * Sets the isLast flag.
		 * 
		 * @param isLast The isLast flag.
		 */
		asdpc_internal function setIsLast_internal(isLast : Boolean) : void {
			_isLast = isLast;
		}
		
		/*
		 * Info
		 */

		/**
		 * toString() function.
		 */
		public function toString() : String {
			return "[ListItemRendererData] listIndex:" + listIndex + " item:" + item + " selected:" + selected;
		}
	}
}

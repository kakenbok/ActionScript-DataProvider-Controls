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
	import com.sibirjak.asdpc.core.IBindableView;
	import com.sibirjak.asdpc.core.IControl;

	/**
	 * ListView public interface.
	 * 
	 * @author jes 08.07.2009
	 */
	public interface IListView extends IBindableView, IControl {
		
		/*
		 * Data source
		 */

		/**
		 * @private
		 */
		function set dataSource(dataSource : *) : void;
		
		/**
		 * Sets or returns the list data source.
		 */
		function get dataSource() : *;		

		/**
		 * @private
		 */
		function set dataSourceAdapterFunction(dataSourceAdapterFunction : Function) : void;
		
		/**
		 * Sets or returns a custom data source adapter function.
		 */
		function get dataSourceAdapterFunction() : Function;

		/**
		 * The number of items currently displayed in the listView.
		 */
		function get numItems() : uint;		

		/**
		 * Returns a ListItemData object for the item at the given index.
		 * 
		 * @return A ListItemData object for the item at the given index.
		 */
		function getListItemDataAt(listIndex : uint) : ListItemData;		

		/*
		 * User interface
		 */

		/**
		 * @private
		 */
		function set direction(direction : String) : void;
		
		/**
		 * Sets or gets the list direction.
		 * 
		 * <p>Can only be set before the list ist added to the stage.</p>
		 */
		function get direction() : String;

		/**
		 * @private
		 */
		function set select(select : Boolean) : void;
		
		/**
		 * Defines or returns the list selection behaviour.
		 * 
		 * <p>If set to false, items clicked by mouse won't be selected.</p>
		 */
		function get select() : Boolean;

		/**
		 * @private
		 */
		function set deselect(select : Boolean) : void;
		
		/**
		 * Defines or returns the list deselection behaviour.
		 * 
		 * <p>If set to false, selected items won't be deselected.</p>
		 */
		function get deselect() : Boolean;

		/**
		 * @private
		 */
		function set multiselect(multiselect : Boolean) : void;
		
		/**
		 * Sets or returns the list to be a multiselect list.
		 * 
		 * <p>Does not have effects if select is set to false.</p>
		 */
		function get multiselect() : Boolean;
		
		/**
		 * Sets an item renderer.
		 * 
		 * <p>Can currently only be set before the list ist added to the stage.</p>
		 */
		function set itemRenderer(renderer : Class) : void;

		/*
		 * Scroll position
		 */

		/**
		 * The current scroll postion of the list.
		 * 
		 * <p>Returns -1, if the list is empty.</p>
		 */
		function get firstVisibleIndex() : int;
		
		/**
		 * The max scroll postion of the list.
		 * 
		 * <p>Returns -1, if the list is empty.</p>
		 */
		function get maxScrollIndex() : int;
		
		/**
		 * Scrolls to the specified item.
		 * 
		 * @param listIndex The index of the item to scroll to.
		 */
		function scrollToItemAt(listIndex : uint) : void;

		/*
		 * Selection
		 */

		/**
		 * Selects the item at the given position.
		 * 
		 * @param listIndex The index of the item to select.
		 */
		function selectItemAt(listIndex : uint) : void;

		/**
		 * Deselects the item at the given position.
		 * 
		 * @param listIndex The index of the item to deselect.
		 */
		function deselectItemAt(listIndex : uint) : void;
		
		/**
		 * The list index of the first selected item.
		 * 
		 * <p>Always -1, if multiselect is set to true.</p>
		 */
		function get selectedIndex() : int;

		/**
		 * The first selected item.
		 * 
		 * <p>Always null, if multiselect is set to true.</p>
		 */
		function get selectedItemData() : ListItemData;

		/**
		 * An array of all selected indices.
		 * 
		 * <p>Always empty, if multiselect is set to false.</p>
		 */
		function get selectedIndices() : Array;

		/**
		 * An array of all selected items data.
		 * 
		 * <p>Always empty, if multiselect is set to false.</p>
		 */
		function get selectedItemsData() : Array;
	}
}

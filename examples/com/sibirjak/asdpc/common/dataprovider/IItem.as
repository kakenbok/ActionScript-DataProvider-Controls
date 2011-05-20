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
package com.sibirjak.asdpc.common.dataprovider {
	import com.sibirjak.asdpc.listview.ListItemData;

	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.framework.IIterable;

	import flash.events.IEventDispatcher;

	/**
	 * @author jes 04.11.2009
	 */
	public interface IItem extends IIterable, IEventDispatcher {

		/*
		 * IItem
		 */

		function set name(name : String) : void;

		function get name() : String;

		function set category(category : String) : void;
		
		function get category() : String;
		
		/*
		 * Factories
		 */

		function i_createItem() : IItem;

		function get i_nextChildIndex() : uint;

		/*
		 * Collection interface
		 */

		function i_setItems(array : Array) : void;

		function i_addItemAtStart(item : *) : void;

		function i_addItemBefore(dataOfItemAfter : ListItemData, item : *) : void;

		function i_addItemAfter(dataOfItemBefore : ListItemData, item : *) : void;

		function i_addItemAtEnd(item : *) : void;


		function i_removeItem(dataOfItem : ListItemData) : void;

		function i_removeAll() : void;


		function i_reverse() : void;

		function i_sort(comparator : IComparator) : void;

	}
}

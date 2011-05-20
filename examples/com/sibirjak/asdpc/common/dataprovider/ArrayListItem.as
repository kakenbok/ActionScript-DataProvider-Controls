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
	import org.as3commons.collections.fx.ArrayListFx;

	import flash.events.Event;

	/**
	 * @author jes 04.08.2009
	 */
	public class ArrayListItem extends ArrayListFx implements IItem {

		private var _name : String;
		private var _category : String;
		private var _nextChildIndex : uint = 1;

		/*
		 * Item interface
		 */

		public function set name(name : String) : void {
			_name = name;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get name() : String {
			return _name;
		}
		
		public function set category(category : String) : void {
			_category = category;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get category() : String {
			return _category;
		}
		
		/*
		 * Factories
		 */

		public function i_createItem() : IItem {
			return DataSourceCreator.createChildItem(this);
		}
		
		public function get i_nextChildIndex() : uint {
			return _nextChildIndex++;
		}

		/*
		 * Collection interface
		 */

		public function i_setItems(array : Array) : void {
			this.array = array;
		}
		
		public function i_addItemAtStart(item : *) : void {
			addFirst(item);
		}

		public function i_addItemBefore(dataOfItemAfter : ListItemData, item : *) : void {
			addAt(dataOfItemAfter.itemIndex, item);
		}

		public function i_addItemAfter(dataOfItemBefore : ListItemData, item : *) : void {
			addAt(dataOfItemBefore.itemIndex + 1, item);
		}

		public function i_addItemAtEnd(item : *) : void {
			addLast(item);
		}
		
		public function i_removeItem(dataOfItem : ListItemData) : void {
			removeAt(dataOfItem.itemIndex);
		}
		
		public function i_removeAll() : void {
			clear();
		}
		
		public function i_reverse() : void {
			reverse();
		}
		
		public function i_sort(comparator : IComparator) : void {
			sort(comparator);
		}
		
		/*
		 * Info
		 */

		public function toString() : String {
			return "[ArrayListItem] name:" + _name + " category:" + _category + " children:" + size;
		}
		
	}
}

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
	import org.as3commons.collections.fx.SortedMapFx;

	import flash.events.Event;

	/**
	 * @author jes 22.01.2010
	 */
	public class SortedMapItem extends SortedMapFx implements IItem {

		private var _number : int;
		private var _category : String;
		private var _nextChildIndex : uint = 1;

		public function SortedMapItem() {
			super(new ItemComparator());
			
			_number = Math.round(Math.random() * 1000);
		}

		/*
		 * Item interface
		 */

		public function get number() : int {
			return _number;
		}
		
		public function set number(number : int) : void {
			_number = number;
		}

		public function set name(name : String) : void {
		}

		public function get name() : String {
			return _number + "";
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
			clear();
			
			for (var i : uint = 0; i < array.length; i++) {
				add(SortedMapItem(array[i]).number, array[i]);
			}
		}
		
		public function i_addItemAtStart(item : *) : void {
			if (first) {
				SortedMapItem(item).number = first["number"] - SortedMapItem(item).number;
			}

			add(SortedMapItem(item).number, item);
		}

		public function i_addItemBefore(dataOfItemAfter : ListItemData, item : *) : void {
			var after : SortedMapItem = dataOfItemAfter.item;
			SortedMapItem(item).number = after.number - SortedMapItem(item).number;
			add(SortedMapItem(item).number, item);
		}

		public function i_addItemAfter(dataOfItemBefore : ListItemData, item : *) : void {
			var before : SortedMapItem = dataOfItemBefore.item;
			SortedMapItem(item).number = before.number + SortedMapItem(item).number;
			add(SortedMapItem(item).number, item);
		}

		public function i_addItemAtEnd(item : *) : void {
			if (last) {
				SortedMapItem(item).number = last["number"] + SortedMapItem(item).number;
			}

			add(SortedMapItem(item).number, item);
		}
		
		public function i_removeItem(dataOfItem : ListItemData) : void {
			removeKey(dataOfItem.itemKey);
		}
		
		public function i_removeAll() : void {
			clear();
		}
		
		public function i_reverse() : void {
			// not implemented
		}
		
		public function i_sort(comparator : IComparator) : void {
			// not implemented
		}
		
		/*
		 * Info
		 */

		public function toString() : String {
			return "[SortedMapItem] number:" + _number + " category:" + _category + " children:" + size;
		}
	}
}

import com.sibirjak.asdpc.common.dataprovider.SortedMapItem;

import org.as3commons.collections.utils.NumericComparator;

internal class ItemComparator extends NumericComparator {

	override public function compare(item1 : *, item2 : *) : int {
		return super.compare(SortedMapItem(item1).number, SortedMapItem(item2).number);
	}
}

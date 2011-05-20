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
	import flash.events.Event;

	/**
	 * ListItem event.
	 * 
	 * <p>This event is dispatched by the listView in response to user
	 * interactivity.</p>
	 * 
	 * @author jes 14.12.2009
	 */
	public class ListItemEvent extends Event {

		/**
		 * Event type ROLL_OVER
		 * 
		 * <p>Dispatched if the mouse enters the list item area.</p>
		 * 
		 * @eventType listItem_rollOver
		 */
		public static const ROLL_OVER : String = "listItem_rollOver";

		/**
		 * Event type ROLL_OUT
		 * 
		 * <p>Dispatched if the mouse leaves the list item area.</p>
		 * 
		 * @eventType listItem_rollOut
		 */
		public static const ROLL_OUT : String = "listItem_rollOut";

		/**
		 * Event type MOUSE_DOWN
		 * 
		 * <p>Dispatched if the user presses the mouse over a list item.</p>
		 * 
		 * @eventType listItem_mouseDown
		 */
		public static const MOUSE_DOWN : String = "listItem_mouseDown";

		/**
		 * Event type CLICK
		 * 
		 * <p>Dispatched if the user clicks a list item.</p>
		 * 
		 * @eventType listItem_click
		 */
		public static const CLICK : String = "listItem_click";
		
		/**
		 * Event type SELECTION_CHANGED
		 * 
		 * <p>Dispatched if the user has selected or deselected a list item.</p>
		 * 
		 * @eventType listItem_selectionChanged
		 */
		public static const SELECTION_CHANGED : String = "listItem_selectionChanged";

		/**
		 * The list item data of the affected list item. 
		 */
		protected var _data : ListItemData;

		/**
		 * ListItemRendererEvent constructor.
		 * 
		 * @param type The event type.
		 * @param data The list item data of the affected list item. 
		 */
		public function ListItemEvent(type : String, data : ListItemData) {
			super(type);
			
			_data = data;
		}
		
		/*
		 * Getter
		 */

		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemData#listIndex
		 */
		public function get listIndex() : int {
			return _data.listIndex;
		}
		
		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemData#parentItem
		 */
		public function get parentItem() : * {
			return _data.parentItem;
		}

		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemData#itemIndex
		 */
		public function get itemIndex() : uint {
			return _data.itemIndex;
		}

		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemData#item
		 */
		public function get item() : * {
			return _data.item;
		}

		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemData#itemKey
		 */
		public function get itemKey() : * {
			return _data.itemKey;
		}

		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemData#selected
		 */
		public function get selected() : Boolean {
			return _data.selected;
		}

	}
}

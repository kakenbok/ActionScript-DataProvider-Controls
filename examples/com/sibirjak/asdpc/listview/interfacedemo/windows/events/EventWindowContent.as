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
package com.sibirjak.asdpc.listview.interfacedemo.windows.events {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.button.IButton;
	import com.sibirjak.asdpc.button.skins.ButtonSkin;
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.common.interfacedemo.ControlPanelBase;
	import com.sibirjak.asdpc.common.interfacedemo.windows.events.EventItem;
	import com.sibirjak.asdpc.common.interfacedemo.windows.events.EventListItemRenderer;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.listview.IListView;
	import com.sibirjak.asdpc.listview.ListView;
	import com.sibirjak.asdpc.listview.renderer.ListItemContent;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpcbeta.checkbox.CheckBox;
	import com.sibirjak.asdpcbeta.checkbox.skins.CheckBoxIconSkin;

	import org.as3commons.collections.fx.ArrayListFx;

	import flash.display.DisplayObject;

	/**
	 * @author jes 01.12.2009
	 */
	public class EventWindowContent extends ControlPanelBase {

		private var _listViewCheckBox : CheckBox;
		private var _listItemCheckBox : CheckBox;
		private var _listItemRollOverCheckBox : CheckBox;

		private var _eventListView : IListView;
		private var _dataSource : ArrayListFx;

		private var _buttonSize : uint = 13;
		private var _clearButton : IButton;
		
		private var _messageID : uint = 1;

		public function addEvent(event : EventItem) : void {

			if (event.type == EventItem.TYPE_LIST_ITEM && !_listItemCheckBox.selected) return;
			if (event.type == EventItem.TYPE_LIST_VIEW && !_listViewCheckBox.selected) return;

			if (event.type == EventItem.TYPE_LIST_ITEM && event.label.indexOf("ROLL_") == 0 && !_listItemRollOverCheckBox.selected) return;
			
			event.label = _messageID++ + " " + event.label;
			_dataSource.addAt(0, event);
			_eventListView.scrollToItemAt(0);
		}

		override protected function draw() : void {

			// list
			
			_eventListView = new ListView();
			_eventListView.setSize(_width, 192);
			_eventListView.itemRenderer = EventListItemRenderer;

			_eventListView.setStyles([
				ListView.style.itemSize, 16,
				ListView.style.scrollBarSize, 10,
				ButtonSkin.style_borderAlias, false,
				ListItemRenderer.style.overBackgroundColors, null,
				ListItemContent.style.overLabelStyles, null,
				Label.style.size, 9
			]);
			
			_dataSource = new ArrayListFx();
			_eventListView.dataSource = _dataSource;
			
			addChild(DisplayObject(_eventListView));
			
			// separator

			var separator : View = dottedSeparator();
			separator.moveTo(0, _eventListView.y + _eventListView.height + 4);
			addChild(separator);

			// checkboxes

			_listViewCheckBox = new CheckBox();
			_listViewCheckBox.setSize(50, 12);
			
			_listViewCheckBox.setStyles([
				CheckBoxIconSkin.style_size, 4,
				Label.style.bold, true
			]);
			_listViewCheckBox.selected = true;
			_listViewCheckBox.label = getListName();
			_listViewCheckBox.moveTo(2, _height - _buttonSize - 2);
			addChild(_listViewCheckBox);

			_listItemCheckBox = new CheckBox();
			_listItemCheckBox.setSize(50, 12);
			_listItemCheckBox.setStyle(CheckBoxIconSkin.style_size, 4);
			_listItemCheckBox.selected = true;
			_listItemCheckBox.label = getItemName();
			_listItemCheckBox.moveTo(50, _height - _buttonSize - 2);
			addChild(_listItemCheckBox);
			
			_listItemRollOverCheckBox = new CheckBox();
			_listItemRollOverCheckBox.setSize(70, 12);
			_listItemRollOverCheckBox.setStyle(CheckBoxIconSkin.style_size, 4);
			_listItemRollOverCheckBox.selected = false;
			_listItemRollOverCheckBox.label = "RollOver";
			_listItemRollOverCheckBox.moveTo(100, _height - _buttonSize - 2);
			
			_listItemCheckBox.bindProperty(Button.BINDABLE_PROPERTY_SELECTED, _listItemRollOverCheckBox, "visible");

			addChild(_listItemRollOverCheckBox);

			// clear button

 			_clearButton = new Button();
			_clearButton.setSize(_buttonSize, _buttonSize);
			_clearButton.setStyles([
				Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("clear"),
				Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME
			]);
			
			_clearButton.toolTip = "Remove events";

			_clearButton.moveTo(_width - (_buttonSize + 4), _height - _buttonSize - 2);
			_clearButton.addEventListener(ButtonEvent.CLICK, clearButtonClickHandler);
			addChild(DisplayObject(_clearButton));
		}
		
		protected function getListName() : String {
			return "List";
		}

		protected function getItemName() : String {
			return "Item";
		}

		private function clearButtonClickHandler(event : ButtonEvent) : void {
			_dataSource.clear();
		}

	}
}

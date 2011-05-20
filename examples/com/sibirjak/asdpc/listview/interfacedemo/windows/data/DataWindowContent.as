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
package com.sibirjak.asdpc.listview.interfacedemo.windows.data {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.button.skins.ButtonSkin;
	import com.sibirjak.asdpc.common.dataprovider.IItem;
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.common.interfacedemo.ControlPanelBase;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.listview.IListView;
	import com.sibirjak.asdpc.listview.ListItemData;
	import com.sibirjak.asdpc.listview.ListView;
	import com.sibirjak.asdpc.listview.ListViewInterfaceDemo;
	import com.sibirjak.asdpc.listview.renderer.ListItemContent;
	import com.sibirjak.asdpc.listview.renderer.ListItemIcon;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpc.treeview.renderer.TreeNodeRenderer;
	import com.sibirjak.asdpcbeta.core.managers.PopUpManager;
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.WindowEvent;
	import com.sibirjak.asdpcbeta.window.core.WindowPosition;

	import org.as3commons.collections.utils.StringComparator;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author jes 01.12.2009
	 */
	public class DataWindowContent extends ControlPanelBase {
		

		protected var _buttonSize : uint = 13;
		protected var _buttonPadding : uint = 4;
		
		protected var _listBuilder : IListView;

		protected var _buttons : Sprite;

		protected var _inputButton : Button;
		protected var _resetButton : Button;
		protected var _addAtStartButton : Button;
		protected var _addAtEndButton : Button;

		protected var _aZSortButton : Button;
		protected var _zASortButton : Button;
		protected var _reverseButton : Button;

		protected var _clearButton : Button;
		
		protected var _inputWindow : Window;
		protected var _inputWindowDocument : InputWindowContent;

		protected var _buttonStyles : Array = [
			Button.style.upIconSkin, null,
			Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
			Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME,
		];

		public function DataWindowContent(view : IView) {
			super.view = view;
		}

		override protected function viewStyleChanged(property : String, value : *) : void {
			
			if (
				property == ListItemIcon.style.iconSkin
			) {
				_listBuilder.setStyle(property, value);
			}

		}

		override protected function draw() : void {
			
			// listBuilder
			
			createListBuilder();
			
			// separator
			
			var separator : View = dottedSeparator();
			separator.moveTo(0, _listBuilder.y + _listBuilder.height + 4);
			addChild(separator);
			
			// buttons
			
			createButtons();
			setButtonPositions();
			
			// data input window
			
			_inputWindowDocument = new InputWindowContent();
			
			_inputWindow = new Window();
			_inputWindow.setSize(400, 300);

			_inputWindow.setStyles([
				Window.style.padding, 8,
				Window.style.windowIconSkin, null
			]);

			_inputWindow.document = _inputWindowDocument;
			_inputWindow.title = "Input data";
			_inputWindow.minimisePosition = new WindowPosition(function() : Point {
				return _inputButton.localToGlobal(new Point(Math.round(_inputButton.width / 2), 0));
			});
			_inputWindow.minimised = true;
			_inputWindow.minimiseOnClickOutside = true;
			_inputWindow.minimiseTriggerButton = _inputButton;

			_inputWindow.addEventListener(WindowEvent.MINIMISE_START, inputStartMinimiseHandler);
			_inputWindow.addEventListener(WindowEvent.MINIMISED, inputMinimisedHandler);
			_inputWindow.addEventListener(WindowEvent.RESTORED, inputRestoredHandler);
			_inputWindow.addEventListener("submit", inputSubmitHandler);
		}
		
		protected function getListBuilderClass() : Class {
			return ListView;
		}
		
		protected function getContentRenderer() : Class {
			return ListBuilderContentRenderer;
		}
		
		protected function setListBuilderProperties() : void {
		}

		protected function get _listView() : IListView {
			return _view as IListView;
		}

		protected function getDataSource() : IItem {
 			return ListViewInterfaceDemo.createDataSource();
		}

		protected function clear() : void {
			IItem(_listBuilder.dataSource).i_removeAll();
		}

		protected function reset() : void {
			var dataSource : IItem = getDataSource();
			_listBuilder.dataSource = dataSource;
			_listView.dataSource = dataSource;
		}

		protected function addAtStart() : void {
			var dataSource : IItem = _listBuilder.dataSource;
			dataSource.i_addItemAtStart(dataSource.i_createItem());
		}

		protected function addAtEnd() : void {
			var dataSource : IItem = _listBuilder.dataSource;
			dataSource.i_addItemAtEnd(dataSource.i_createItem());
		}

		protected function processInputContent(content : String) : Boolean {
			var text : String = content;
			var dataArray : Array = text.split("\r").join("\n").split("\n");
			
			var dataSource : IItem = ListViewInterfaceDemo.createDataSource(0);
			var item : IItem;
			
			for (var i : int = 0; i < dataArray.length; i++) {
				if (!dataArray[i]) continue;

				item = dataSource.i_createItem();
				item.name = dataArray[i];

				dataSource.i_addItemAtEnd(item);
			}

			_listView.dataSource = dataSource;
			_listBuilder.dataSource = dataSource;
			
			return true;
		}

		protected function createButtons() : void {
			
			_buttons = new Sprite();
			_buttons.y = _height - _buttonSize - 2;
			addChild(_buttons);
			
			// input

			_inputButton = new Button();
			_inputButton.setSize(27, _buttonSize);
			_inputButton.setStyles(_buttonStyles);
			_inputButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("input"));

			_inputButton.toolTip = "Input data";

			_inputButton.addEventListener(ButtonEvent.CLICK, inputButtonClickHandler);
			_buttons.addChild(_inputButton);

			// reload

			_resetButton = new Button();
			_resetButton.setSize(_buttonSize, _buttonSize);
			_resetButton.setStyles(_buttonStyles);
			_resetButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("reset"));

			_resetButton.toolTip = getResetTip();

			_resetButton.addEventListener(ButtonEvent.CLICK, resetButtonClickHandler);
			_buttons.addChild(_resetButton);

			// add before

			_addAtStartButton = new Button();
			_addAtStartButton.setSize(_buttonSize, _buttonSize);
			_addAtStartButton.setStyles(_buttonStyles);
			_addAtStartButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("add_at_start"));

			_addAtStartButton.autoRepeat = true;
			_addAtStartButton.toolTip = getAddAtStartTip();

			_addAtStartButton.addEventListener(ButtonEvent.MOUSE_DOWN, addBeforeButtonClickHandler);
			_buttons.addChild(_addAtStartButton);

			// add after

			_addAtEndButton = new Button();
			_addAtEndButton.setSize(_buttonSize, _buttonSize);
			_addAtEndButton.setStyles(_buttonStyles);
			_addAtEndButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("add_at_end"));

			_addAtEndButton.autoRepeat = true;
			_addAtEndButton.toolTip = getAddAtEndTip();

			_addAtEndButton.addEventListener(ButtonEvent.MOUSE_DOWN, addAfterButtonClickHandler);
			_buttons.addChild(_addAtEndButton);

			// a-z-sort

			_aZSortButton = new Button();
			_aZSortButton.setSize(21, _buttonSize);
			_aZSortButton.setStyles(_buttonStyles);
			_aZSortButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("a_z_sort"));

			_aZSortButton.autoRepeat = true;
			_aZSortButton.toolTip = "Sort";

			_aZSortButton.addEventListener(ButtonEvent.MOUSE_DOWN, aZButtonClickHandler);
			_buttons.addChild(_aZSortButton);

			// z-a-sort

			_zASortButton = new Button();
			_zASortButton.setSize(21, _buttonSize);
			_zASortButton.setStyles(_buttonStyles);
			_zASortButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("z_a_sort"));

			_zASortButton.autoRepeat = true;
			_zASortButton.toolTip = "Sort";

			_zASortButton.addEventListener(ButtonEvent.MOUSE_DOWN, zAButtonClickHandler);
			_buttons.addChild(_zASortButton);

			// reverse

			_reverseButton = new Button();
			_reverseButton.setSize(21, _buttonSize);
			_reverseButton.setStyles(_buttonStyles);
			_reverseButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("reverse"));

			_reverseButton.autoRepeat = true;
			_reverseButton.toolTip = "Reverse";

			_reverseButton.addEventListener(ButtonEvent.MOUSE_DOWN, reverseButtonClickHandler);
			_buttons.addChild(_reverseButton);

			// clear

 			_clearButton = new Button();
			_clearButton.setSize(_buttonSize, _buttonSize);
			_clearButton.setStyles(_buttonStyles);
			_clearButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("clear"));

			_clearButton.toolTip = getClearButtonTip();

			_clearButton.addEventListener(ButtonEvent.CLICK, clearButtonClickHandler);
			_buttons.addChild(_clearButton);
			
		}
		
		protected function getClearButtonTip() : String {
			return "Clear data";
		}
		
		protected function getAddAtStartTip() : String {
			return "Add item at start";
		}
		
		protected function getAddAtEndTip() : String {
			return "Add item at end";
		}

		protected function getResetTip() : String {
			return "Reset data";
		}

		protected function setButtonPositions() : void {
			_clearButton.x = _width - (_clearButton.width + _buttonPadding);
			_reverseButton.x = _clearButton.x - (_reverseButton.width + _buttonPadding) - 6;
			_zASortButton.x = _reverseButton.x - (_zASortButton.width + _buttonPadding);
			_aZSortButton.x = _zASortButton.x - (_aZSortButton.width + _buttonPadding);
			_addAtEndButton.x = _aZSortButton.x - (_addAtEndButton.width + _buttonPadding) - 6;
			_addAtStartButton.x = _addAtEndButton.x - (_addAtStartButton.width + _buttonPadding);
			_resetButton.x = _addAtStartButton.x - (_resetButton.width + _buttonPadding);
			_inputButton.x = _resetButton.x - (_inputButton.width + _buttonPadding);
		}

		protected function inputButtonClickHandler(event : ButtonEvent) : void {
			PopUpManager.getInstance().createPopUp(_inputWindow);
			
			_inputWindow.restorePosition = new WindowPosition(
				Math.round((stage.stageWidth - _inputWindow.width) / 2),
				Math.round((stage.stageHeight - _inputWindow.height) / 2)
			);

			_inputWindow.restore();
			
		}

		private function createListBuilder() : void {
			_listBuilder = new (getListBuilderClass())();
			_listBuilder.setSize(_width, 320);
			
			_listBuilder.name = "listbuilder";
			
			var iconFunction : Function = function (data : ListItemData) : Class {
				return IconFactory.getInstance().getIconSkin(IItem(data.item).category);
			};

			_listBuilder.setStyles([
				ButtonSkin.style_borderAlias, false,
				Label.style.size, 9,

				ListView.style.itemSize, 20,
				ListView.style.selectedItemSize, 2,
				ListView.style.scrollBarSize, 10,
				
				TreeNodeRenderer.style.expandCollapseOnDoubleClick, false,

				ListItemRenderer.style.contentRenderer, getContentRenderer(),
				ListItemRenderer.style.backgroundType, ListItemRenderer.BACKGROUND_CONTENT,
				ListItemRenderer.style.selectedBackgroundColors, [0xD5E0F0],
				ListItemRenderer.style.overBackgroundColors, [0xD5E0F0],
				ListItemRenderer.style.indent, 16,
				ListItemRenderer.style.icon, true,
				ListItemRenderer.style.clickSelection, true,

				ListItemContent.style.selectedLabelStyles, [
					Label.style.color, 0x444444
				],

				ListItemIcon.style.iconSkinFunction, iconFunction,
				ListItemIcon.style.size, 12
				
			]);

			_listBuilder.dataSource = _listView.dataSource;
			setListBuilderProperties();
			_listBuilder.selectItemAt(0);
			
			addChild(DisplayObject(_listBuilder));
		}

		private function inputSubmitHandler(event : Event) : void {
			var content : String = _inputWindowDocument.content;


			var success : Boolean = processInputContent(content);

			if (success) _inputWindow.minimise();
		}
		
		private function inputStartMinimiseHandler(event : WindowEvent) : void {
			_inputWindowDocument.removeContent();
		}

		private function inputMinimisedHandler(event : WindowEvent) : void {
			PopUpManager.getInstance().removePopUp(_inputWindow);
		}

		private function inputRestoredHandler(event : WindowEvent) : void {
			stage.focus = _inputWindowDocument.tf;
		}
		
		private function resetButtonClickHandler(event : ButtonEvent) : void {
			reset();
		}

		private function clearButtonClickHandler(event : ButtonEvent) : void {
			clear();
		}

		private function addAfterButtonClickHandler(event : ButtonEvent) : void {
			addAtEnd();
		}

		private function aZButtonClickHandler(event : ButtonEvent) : void {
			IItem(_listBuilder.dataSource).i_sort(new ItemComparator());
		}

		private function zAButtonClickHandler(event : ButtonEvent) : void {
			IItem(_listBuilder.dataSource).i_sort(new ItemComparator(StringComparator.ORDER_DESC));
		}

		private function reverseButtonClickHandler(event : ButtonEvent) : void {
			IItem(_listBuilder.dataSource).i_reverse();
		}

		private function addBeforeButtonClickHandler(event : ButtonEvent) : void {
			addAtStart();
		}
	}
}

import com.sibirjak.asdpc.common.dataprovider.IItem;

import org.as3commons.collections.utils.StringComparator;

internal class ItemComparator extends StringComparator {

	public function ItemComparator(order : String = ORDER_ASC) {
		super(order);
	}
	
	override public function compare(item1 : *, item2 : *) : int {
		return super.compare(IItem(item1).name, IItem(item2).name);
	}
}

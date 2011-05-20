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
package com.sibirjak.asdpc.listview.interfacedemo.windows.navigation {
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
	import com.sibirjak.asdpc.listview.ListViewEvent;
	import com.sibirjak.asdpc.listview.renderer.ListItemIcon;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpc.treeview.renderer.TreeNodeRenderer;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author jes 05.01.2010
	 */
	public class NavigationWindowContent extends ControlPanelBase {

		protected var _listNavigation : IListView;

		private var _buttonSize : uint = 13;
		private var _buttonPadding : uint = 4;

		private var _buttons : Sprite;
		private var _selectAllButton : Button;
		private var _deselectAllButton : Button;
		private var _scrollToTopButton : Button;
		private var _scrollToBottomButton : Button;

		protected var _buttonStyles : Array = [
			Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
			Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME,
			Button.style.selectedUpIconSkinName, Button.UP_ICON_SKIN_NAME,
			Button.style.selectedOverIconSkinName, Button.UP_ICON_SKIN_NAME,
			Button.style.selectedDownIconSkinName, Button.UP_ICON_SKIN_NAME
		];

		public function NavigationWindowContent(view : IView) {
			super.view = view;
			
			_listView.addEventListener(ListViewEvent.DATA_RESET, dataResetHandler);
		}
		
		override protected function viewStyleChanged(property : String, value : *) : void {
			
			if (
				property == ListItemIcon.style.iconSkin
			) {
				_listNavigation.setStyle(property, value);
			}

		}

		override protected function draw() : void {
			
			// list navigation
			
			createNavigation();

			_listNavigation.addEventListener(NavigationEvent.SELECT, selectHandler);
			_listNavigation.addEventListener(NavigationEvent.DESELECT, deselectHandler);
			_listNavigation.addEventListener(NavigationEvent.SCROLL, scrollHandler);
			
			addChild(DisplayObject(_listNavigation));

			// separator
			
			var separator : View = dottedSeparator();
			separator.moveTo(0, _listNavigation.y + _listNavigation.height + 4);
			addChild(separator);
			
			// buttons
			
			createButtons();
		}
		
		protected function getNavigationClass() : Class {
			return ListView;
		}

		protected function getContentRenderer() : Class {
			return ListNavigationContentRenderer;
		}

		protected function setNavigationProperties() : void {
		}

		protected function get _listView() : IListView {
			return _view as IListView;
		}

		protected function afterDataReset() : void {
		}

		private function createNavigation() : void {
			_listNavigation = new (getNavigationClass())();
			_listNavigation.setSize(_width, 320);
			_listNavigation.select = false;
			_listNavigation.name = "listnavigation";
			
			var iconFunction : Function = function (data : ListItemData) : Class {
				return IconFactory.getInstance().getIconSkin(IItem(data.item).category);
			};

			_listNavigation.setStyles([
				ButtonSkin.style_borderAlias, false,
				Label.style.size, 9,

				ListView.style.itemSize, 20,
				ListView.style.scrollBarSize, 10,

				TreeNodeRenderer.style.expandCollapseOnDoubleClick, false,

				ListItemRenderer.style.contentRenderer, getContentRenderer(),
				ListItemRenderer.style.backgroundType, ListItemRenderer.BACKGROUND_LIST_ITEM,
				ListItemRenderer.style.overBackgroundColors, [0xD1EBD2],
				ListItemRenderer.style.indent, 16,
				ListItemRenderer.style.icon, true,

				ListItemIcon.style.iconSkinFunction, iconFunction,
				ListItemIcon.style.size, 12
				
			]);

			_listNavigation.dataSource = _listView.dataSource;
			
			setNavigationProperties();
		}
		
		private function createButtons() : void {
			_buttons = new Sprite();
			_buttons.y = _height - _buttonSize - 2;
			addChild(_buttons);

			// select

			_selectAllButton = new Button();
			_selectAllButton.setSize(_buttonSize, _buttonSize);
			_selectAllButton.setStyles(_buttonStyles);
			_selectAllButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("select"));

			_selectAllButton.toolTip = "Select all items";

			_selectAllButton.moveTo(_width - (_buttonSize + _buttonPadding) * 4 - 6, 0);
			_selectAllButton.addEventListener(ButtonEvent.CLICK, selectAllButtonClickHandler);
			_buttons.addChild(_selectAllButton);

			// deselect

			_deselectAllButton = new Button();
			_deselectAllButton.setSize(_buttonSize, _buttonSize);
			_deselectAllButton.setStyles(_buttonStyles);
			_deselectAllButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("deselect"));

			_deselectAllButton.toolTip = "Deselect all items";

			_deselectAllButton.moveTo(_width - (_buttonSize + _buttonPadding) * 3 - 6, 0);
			_deselectAllButton.addEventListener(ButtonEvent.CLICK, deselectAllButtonClickHandler);
			_buttons.addChild(_deselectAllButton);

			// scroll to top

			_scrollToTopButton = new Button();
			_scrollToTopButton.setSize(_buttonSize, _buttonSize);
			_scrollToTopButton.setStyles(_buttonStyles);
			_scrollToTopButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("scroll"));

			_scrollToTopButton.toolTip = "Scroll to top";

			_scrollToTopButton.moveTo(_width - (_buttonSize + _buttonPadding) * 2, 0);
			_scrollToTopButton.addEventListener(ButtonEvent.CLICK, scrollToTopButtonClickHandler);
			_buttons.addChild(_scrollToTopButton);

			// scroll to bottom

			_scrollToBottomButton = new Button();
			_scrollToBottomButton.setSize(_buttonSize, _buttonSize);
			_scrollToBottomButton.setStyles(_buttonStyles);
			_scrollToBottomButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("scroll_bottom"));

			_scrollToBottomButton.toolTip = "Scroll to bottom";

			_scrollToBottomButton.moveTo(_width - (_buttonSize + _buttonPadding) * 1, 0);
			_scrollToBottomButton.addEventListener(ButtonEvent.CLICK, scrollToBottomButtonClickHandler);
			_buttons.addChild(_scrollToBottomButton);
		}
		
		// list events

		private function dataResetHandler(event : ListViewEvent) : void {
			_listNavigation.dataSource = _listView.dataSource;
			
			afterDataReset();
		}
		
		// navigation events
		private function selectAllButtonClickHandler(event : ButtonEvent) : void {
			for (var i : uint = 0; i < _listView.numItems; i++) {
				_listView.selectItemAt(i);
			}
		}

		private function deselectAllButtonClickHandler(event : ButtonEvent) : void {
			for (var i : uint = 0; i < _listView.numItems; i++) {
				_listView.deselectItemAt(i);
			}
		}

		private function scrollToTopButtonClickHandler(event : ButtonEvent) : void {
			_listView.scrollToItemAt(0);
		}

		private function scrollToBottomButtonClickHandler(event : ButtonEvent) : void {
			_listView.scrollToItemAt(_listView.numItems - 1);
		}
		
		// item events

		private function scrollHandler(event : NavigationEvent) : void {
			_listView.scrollToItemAt(event.listIndex);
		}

		private function deselectHandler(event : NavigationEvent) : void {
			_listView.deselectItemAt(event.listIndex);
		}

		private function selectHandler(event : NavigationEvent) : void {
			_listView.selectItemAt(event.listIndex);
		}

	}
}

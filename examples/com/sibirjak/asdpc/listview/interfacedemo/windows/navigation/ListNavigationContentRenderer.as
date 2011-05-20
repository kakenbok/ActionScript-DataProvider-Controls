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
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.listview.core.IListItemRenderer;
	import com.sibirjak.asdpc.listview.core.ListItemRendererEvent;
	import com.sibirjak.asdpc.listview.renderer.ListItemContent;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author jes 23.11.2009
	 */
	public class ListNavigationContentRenderer extends ListItemContent {

		/* internals */
		protected var _buttonSize : uint = 13;
		protected var _buttonPadding : uint = 2;

		/* children */
		protected var _buttons : Sprite;
		protected var _selectButton : Button;
		protected var _deselectButton : Button;
		protected var _scrollButton : Button;
		protected var _removeButton : Button;
		
		protected var _buttonStyles : Array = [
			Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
			Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME,
			Button.style.selectedUpIconSkinName, Button.UP_ICON_SKIN_NAME,
			Button.style.selectedOverIconSkinName, Button.UP_ICON_SKIN_NAME,
			Button.style.selectedDownIconSkinName, Button.UP_ICON_SKIN_NAME
		];

		public function ListNavigationContentRenderer() {
		}

		override public function set listItemRenderer(listItemRenderer : IListItemRenderer) : void {
			super.listItemRenderer = listItemRenderer;

			_listItemRenderer.addEventListener(ListItemRendererEvent.ROLL_OVER, rollOverHandler);
			_listItemRenderer.addEventListener(ListItemRendererEvent.ROLL_OUT, rollOutHandler);
		}

		protected function getButtonBarWidth() : uint {
			return 3 * (_buttonSize + _buttonPadding) + 6;
		}

		protected function setButtonPosition() : void {
			_selectButton.x = 0;
			_deselectButton.x = (_buttonSize + _buttonPadding);

			_scrollButton.x = (_buttonSize + _buttonPadding) * 2 + 6;
		}
		
		/*
		 * View life cycle
		 */

		override protected function draw() : void {
			super.draw();
			
			// buttons

			_buttons = new Sprite();
			_buttons.visible = false;
			_buttons.x = _width - getButtonBarWidth();
			
			with (_buttons.graphics) {
				beginFill(0, 0);
				drawRect(- 4, 0, _width - _buttons.x + 4, _height);
			}
			
			_buttons.addEventListener(MouseEvent.CLICK, buttonAreaClickHandler);
			addChild(_buttons);

			// select

			_selectButton = new Button();
			_selectButton.setSize(_buttonSize, _buttonSize);
			_selectButton.setStyles(_buttonStyles);
			_selectButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("select"));

			_selectButton.toolTip = "Select item";

			_selectButton.moveTo((_buttonSize + _buttonPadding) * _buttons.numChildren, Math.round((_height - _buttonSize) / 2));
			_selectButton.addEventListener(ButtonEvent.CLICK, selectButtonClickHandler);
			_buttons.addChild(_selectButton);

			// deselect

			_deselectButton = new Button();
			_deselectButton.setSize(_buttonSize, _buttonSize);
			_deselectButton.setStyles(_buttonStyles);
			_deselectButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("deselect"));

			_deselectButton.toolTip = "Deselect item";

			_deselectButton.moveTo((_buttonSize + _buttonPadding) * _buttons.numChildren, Math.round((_height - _buttonSize) / 2));
			_deselectButton.addEventListener(ButtonEvent.CLICK, deselectButtonClickHandler);
			_buttons.addChild(_deselectButton);

			// scroll

			_scrollButton = new Button();
			_scrollButton.setSize(_buttonSize, _buttonSize);
			_scrollButton.setStyles(_buttonStyles);
			_scrollButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("scroll"));

			_scrollButton.toolTip = "Scroll to item";

			_scrollButton.moveTo((_buttonSize + _buttonPadding) * _buttons.numChildren, Math.round((_height - _buttonSize) / 2));
			_scrollButton.addEventListener(ButtonEvent.CLICK, scrollButtonClickHandler);
			_buttons.addChild(_scrollButton);
		}

		override protected function initialised() : void {
			setButtonPosition();
		}

		override protected function update() : void {
			super.update();
			
			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				_buttons.x = _width - getButtonBarWidth();
			}

		}

		override protected function cleanUpCalled() : void {
			super.cleanUpCalled();

			_listItemRenderer.removeEventListener(ListItemRendererEvent.ROLL_OVER, rollOverHandler);
			_listItemRenderer.removeEventListener(ListItemRendererEvent.ROLL_OUT, rollOutHandler);
		}

		/*
		 * ListItemRenderer events
		 */

		private function rollOverHandler(event : ListItemRendererEvent) : void {
			_label.setSize(_buttons.x - 4, _height);
			_label.validateNow();
			_buttons.visible = true;
		}

		private function rollOutHandler(event : ListItemRendererEvent) : void {
			_label.setSize(_width, _height);
			_label.validateNow();
			_buttons.visible = false;
		}

		/*
		 * Button events
		 */

		private function buttonAreaClickHandler(event : MouseEvent) : void {
			// do not select current item with a click into the button area
			event.stopPropagation();
		}

		private function selectButtonClickHandler(event : ButtonEvent) : void {
			dispatchEvent(new NavigationEvent(NavigationEvent.SELECT, data.listIndex));
		}
		
		private function deselectButtonClickHandler(event : ButtonEvent) : void {
			dispatchEvent(new NavigationEvent(NavigationEvent.DESELECT, data.listIndex));
		}
		
		private function scrollButtonClickHandler(event : ButtonEvent) : void {
			dispatchEvent(new NavigationEvent(NavigationEvent.SCROLL, data.listIndex));
		}

	}
	
}

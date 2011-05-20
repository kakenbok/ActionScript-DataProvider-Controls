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
package com.sibirjak.asdpc.treeview.interfacedemo.windows.navigation {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.navigation.ListNavigationContentRenderer;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.navigation.NavigationEvent;

	/**
	 * @author jes 23.11.2009
	 */
	public class TreeNavigationContentRenderer extends ListNavigationContentRenderer {

		/* children */
		protected var _expandButton : Button;
		protected var _expandAllButton : Button;
		protected var _collapseButton : Button;
		protected var _collapseAllButton : Button;
		
		public function TreeNavigationContentRenderer() {
		}
		
		override protected function getButtonBarWidth() : uint {
			return 7 * (_buttonSize + _buttonPadding) + 18;
		}

		/*
		 * View life cycle
		 */

		override protected function draw() : void {
			super.draw();
			
			// expand

			_expandButton = new Button();
			_expandButton.setSize(_buttonSize, _buttonSize);
			_expandButton.setStyles(_buttonStyles);
			_expandButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("expand"));

			_expandButton.toolTip = "Expand item";

			_expandButton.moveTo((_buttonSize + _buttonPadding) * _buttons.numChildren, Math.round((_height - _buttonSize) / 2));
			_expandButton.addEventListener(ButtonEvent.CLICK, expandButtonClickHandler);
			_buttons.addChild(_expandButton);

			// expand all

			_expandAllButton = new Button();
			_expandAllButton.setSize(_buttonSize, _buttonSize);
			_expandAllButton.setStyles(_buttonStyles);
			_expandAllButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("expand_all"));

			_expandAllButton.toolTip = "Expand item recursively";

			_expandAllButton.moveTo((_buttonSize + _buttonPadding) * _buttons.numChildren, Math.round((_height - _buttonSize) / 2));
			_expandAllButton.addEventListener(ButtonEvent.CLICK, expandAllButtonClickHandler);
			_buttons.addChild(_expandAllButton);

			// collapse

			_collapseButton = new Button();
			_collapseButton.setSize(_buttonSize, _buttonSize);
			_collapseButton.setStyles(_buttonStyles);
			_collapseButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("collapse"));

			_collapseButton.toolTip = "Collapse item";

			_collapseButton.moveTo((_buttonSize + _buttonPadding) * _buttons.numChildren, Math.round((_height - _buttonSize) / 2));
			_collapseButton.addEventListener(ButtonEvent.CLICK, collapseButtonClickHandler);
			_buttons.addChild(_collapseButton);

			// collapse all

			_collapseAllButton = new Button();
			_collapseAllButton.setSize(_buttonSize, _buttonSize);
			_collapseAllButton.setStyles(_buttonStyles);
			_collapseAllButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("collapse_all"));

			_collapseAllButton.toolTip = "Collapse item recursively";

			_collapseAllButton.moveTo((_buttonSize + _buttonPadding) * _buttons.numChildren, Math.round((_height - _buttonSize) / 2));
			_collapseAllButton.addEventListener(ButtonEvent.CLICK, collapseAllButtonClickHandler);
			_buttons.addChild(_collapseAllButton);
		}
		
		override protected function setButtonPosition() : void {
			_expandButton.x = 0;
			_collapseButton.x = (_buttonSize + _buttonPadding);

			_expandAllButton.x = (_buttonSize + _buttonPadding) * 2 + 6;
			_collapseAllButton.x = (_buttonSize + _buttonPadding) * 3 + 6;

			_selectButton.x = (_buttonSize + _buttonPadding) * 4 + 12;
			_deselectButton.x = (_buttonSize + _buttonPadding) * 5 + 12;

			_scrollButton.x = (_buttonSize + _buttonPadding) * 6 + 18;
		}

		/*
		 * Button events
		 */

		private function expandButtonClickHandler(event : ButtonEvent) : void {
			dispatchEvent(new NavigationEvent(NavigationEvent.EXPAND, data.listIndex));
		}
		
		private function expandAllButtonClickHandler(event : ButtonEvent) : void {
			dispatchEvent(new NavigationEvent(NavigationEvent.EXPAND_ALL, data.listIndex));
		}
		
		private function collapseButtonClickHandler(event : ButtonEvent) : void {
			dispatchEvent(new NavigationEvent(NavigationEvent.COLLAPSE, data.listIndex));
		}
		
		private function collapseAllButtonClickHandler(event : ButtonEvent) : void {
			dispatchEvent(new NavigationEvent(NavigationEvent.COLLAPSE_ALL, data.listIndex));
		}

	}
	
}

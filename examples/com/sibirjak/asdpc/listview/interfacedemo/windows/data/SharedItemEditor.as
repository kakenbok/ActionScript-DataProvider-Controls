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
	import com.sibirjak.asdpc.common.dataprovider.IItem;
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.common.iconselector.IconSelector;
	import com.sibirjak.asdpc.common.interfacedemo.ControlPanelBase;
	import com.sibirjak.asdpc.textfield.TextInput;
	import com.sibirjak.asdpc.textfield.TextInputEvent;
	import com.sibirjak.asdpcbeta.window.WindowEvent;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jes 14.12.2009
	 */
	public class SharedItemEditor extends ControlPanelBase {
		
		protected var _contentRenderer : ListBuilderContentRenderer;
		protected var _item : IItem;
		
		private var _iconSelector : IconSelector;
		private var _nameInput : TextInput;

		private var _categories : Array;

		public function SharedItemEditor() {
			_categories = IconFactory.getInstance().list;
			_categories.unshift("no_icon");
			
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		public function drawContent() : void {
		}
		
		public function set contentRenderer(contentRenderer : ListBuilderContentRenderer) : void {
			_contentRenderer = contentRenderer;
			setItem(_contentRenderer.listItemRenderer.data.item);
		}

		public function get item() : IItem {
			return _item;
		}

		private function setItem(item : IItem) : void {
			_item = item;

			if (!_initialised) return;
			
			_nameInput.text = _item.name;
			_nameInput.validateNow(); // sets the text asap necessary for selection range calculation
			_nameInput.setFocus();
			_nameInput.setSelection(0, _nameInput.text.length); // select all
			_nameInput.scrollTo(0); // scroll to the first char - after selection

			var category : String = _item.category ? _item.category : "no_icon";
			_iconSelector.selectedIconSkin = IconFactory.getInstance().getIconSkin(category);

			layoutChildren();
		}
		
		private function clickHandler(event : MouseEvent) : void {
			event.stopPropagation();
		}

		override protected function draw() : void {
			
			_iconSelector = new IconSelector();
			_iconSelector.setSize(16, 16);

			var category : String = _item.category ? _item.category : "no_icon";

			_iconSelector.dataSource = _categories;
			_iconSelector.selectedIconSkin = IconFactory.getInstance().getIconSkin(category);
			_iconSelector.bindProperty(IconSelector.BINDABLE_PROPERTY_SELECTED_ICON, setIcon);
			_iconSelector.bindProperty(Button.BINDABLE_PROPERTY_SELECTED, setIconSelectorSelected);
			
			addChild(_iconSelector);
			
			_nameInput = new TextInput();
			_nameInput.setSize(_width - getInputX() - 2, 16);
			with (_nameInput) {
				setStyles([
					TextInput.style.background, true,
					TextInput.style.border, true,
					TextInput.style.borderDarkColor, 0xCCCCCC
				]);
				text = _item.name;
				addEventListener(TextInputEvent.CHANGED , textInputChangeHandler);
			}
			
			updateAutomatically(_nameInput);
			
			addChild(_nameInput);
			
			layoutChildren();

			// background
			
			drawBackground();
		}

		override protected function update() : void {
			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				drawBackground();
				layoutChildren();
			}

		}
		
		protected function layoutChildren() : void {
			_iconSelector.x = 2;
			_nameInput.setSize(_width - getInputX() - 2, 16);
			_nameInput.x = getInputX();
		}
		
		protected function getInputX() : uint {
			return 22;
		}

		private function textInputChangeHandler(event : TextInputEvent) : void {
			_item.name = _nameInput.text;
		}
		
		private function drawBackground() : void {
			with (graphics) {
				clear();
				beginFill(0xD5E0F0);
				drawRect(0, 0, _width, _height);
				endFill();
			}
		}
		
		private function setIcon(iconSkin : Class) : void {
			var iconName : String = _iconSelector.selectedIconName;
			if (iconName == "no_icon") iconName = "";
			_item.category = iconName;
		}
		
		private function setIconSelectorSelected(selected : Boolean) : void {
			if (selected) {
				_contentRenderer.lockRollOver();
				_contentRenderer.keepLock(2, true);
				_iconSelector.addEventListener(WindowEvent.AUTO_MINIMISE_START, autoMinimiseStartHandler);

			} else {
				// closed, remove locks
				_contentRenderer.keepLock(2, false);

			}
		}
		
		private function autoMinimiseStartHandler(event : Event) : void {
			_iconSelector.removeEventListener(WindowEvent.AUTO_MINIMISE_START, autoMinimiseStartHandler);

			_contentRenderer.unlockRollOver();
		}
		
	}
}

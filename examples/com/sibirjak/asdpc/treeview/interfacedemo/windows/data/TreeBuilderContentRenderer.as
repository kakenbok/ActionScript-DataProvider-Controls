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
package com.sibirjak.asdpc.treeview.interfacedemo.windows.data {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.common.dataprovider.IItem;
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.listview.core.IListItemRenderer;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.data.ListBuilderContentRenderer;
	import com.sibirjak.asdpc.treeview.constants.TreeNodeState;
	import com.sibirjak.asdpc.treeview.core.TreeNodeRendererData;
	import com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent;

	import org.as3commons.collections.framework.ICollection;

	/**
	 * @author jes 23.11.2009
	 */
	public class TreeBuilderContentRenderer extends ListBuilderContentRenderer {

		/* children */
		private var _replaceButton : Button;
		private var _addBelowButton : Button;
		private var _clearButton : Button;

		public function TreeBuilderContentRenderer() {
		}

		override public function set listItemRenderer(listItemRenderer : IListItemRenderer) : void {
			if (_listItemRenderer) {
				_listItemRenderer.removeEventListener(TreeNodeRendererEvent.TREE_NODE_STATE_CHANGED, treeNodeStateChangedHandler);
			}
			
			super.listItemRenderer = listItemRenderer;
			
			_listItemRenderer.addEventListener(TreeNodeRendererEvent.TREE_NODE_STATE_CHANGED, treeNodeStateChangedHandler);

			setButtonVisibility();
		}
		
		private function treeNodeStateChangedHandler(event : TreeNodeRendererEvent) : void {
			setButtonVisibility();
		}

		override protected function getButtonBarWidth() : uint {
			return 6 * (_buttonSize + _buttonPadding) + 6;
		}

		private function setButtonVisibility() : void {
			if (!_initialised) return;
			
			_replaceButton.enabled = treeNodeData.level < 5;
			_addBeforeButton.enabled = !treeNodeData.isRoot;
			_addAfterButton.enabled = !treeNodeData.isRoot;
			_removeButton.enabled = !treeNodeData.isRoot;
			_addBelowButton.enabled = treeNodeData.level < 5;
			_clearButton.enabled = treeNodeData.treeNodeState != TreeNodeState.LEAF;
		}

		override protected function setButtonPosition() : void {
			_replaceButton.x = 0;
			_addBeforeButton.x = (_buttonSize + _buttonPadding);
			_addAfterButton.x = (_buttonSize + _buttonPadding) * 2;
			_addBelowButton.x = (_buttonSize + _buttonPadding) * 3;
			_clearButton.x = (_buttonSize + _buttonPadding) * 4 + 6;
			_removeButton.x = (_buttonSize + _buttonPadding) * 5 + 6;
		}

		override protected function getSharedItemEditorClass() : Class {
			return TreeViewSharedItemEditor;
		}

		override protected function draw() : void {
			super.draw();
			
			// replace

			_replaceButton = new Button();
			_replaceButton.setSize(_buttonSize, _buttonSize);
			_replaceButton.setStyles(_buttonStyles);
			_replaceButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("reset"));

			_replaceButton.toolTip = "Replace children";

			_replaceButton.moveTo((_buttonSize + _buttonPadding) * _buttons.numChildren, Math.round((_height - _buttonSize) / 2));
			_replaceButton.addEventListener(ButtonEvent.MOUSE_DOWN, replaceButtonClickHandler);
			_buttons.addChild(_replaceButton);

			// add below

			_addBelowButton = new Button();
			_addBelowButton.setSize(_buttonSize, _buttonSize);
			_addBelowButton.autoRepeat = true;
			_addBelowButton.setStyles(_buttonStyles);
			_addBelowButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("add_below"));

			_addBelowButton.toolTip = "Add item as last child";

			_addBelowButton.moveTo((_buttonSize + _buttonPadding) * _buttons.numChildren, Math.round((_height - _buttonSize) / 2));
			_addBelowButton.addEventListener(ButtonEvent.MOUSE_DOWN, addBelowButtonClickHandler);
			_buttons.addChild(_addBelowButton);

			// clear

 			_clearButton = new Button();
			_clearButton.setSize(_buttonSize, _buttonSize);
			_clearButton.setStyles(_buttonStyles);
			_clearButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("clear"));

			_clearButton.toolTip = "Remove children";

			_clearButton.moveTo((_buttonSize + _buttonPadding) * _buttons.numChildren, Math.round((_height - _buttonSize) / 2));
			_clearButton.addEventListener(ButtonEvent.CLICK, clearButtonClickHandler);
			_buttons.addChild(_clearButton);
			
		}
		
		override protected function initialised() : void {
			super.initialised();
			
			setButtonVisibility();
		}

		override protected function update() : void {
			super.update();
			
			if (isInvalid(UPDATE_PROPERTY_DATA)) {
				setButtonVisibility();
			}
			
		}

		/*
		 * Private
		 */

		private function get treeNodeData() : TreeNodeRendererData {
			return data as TreeNodeRendererData;
		}
			
		/*
		 * Mouse event
		 */

		/*
		 * Button events
		 */

		private function replaceButtonClickHandler(event : ButtonEvent) : void {
			var list : IItem = data.item;
			
			var array : Array = [
				list.i_createItem(),
				list.i_createItem(),
				list.i_createItem()
			];
			
			list.i_setItems(array);
				
			treeNodeData.expand();
		}

		private function addBelowButtonClickHandler(event : ButtonEvent) : void {
			var list : IItem = data.item;
			list.i_addItemAtEnd(list.i_createItem());

			treeNodeData.expand();
		}

		private function clearButtonClickHandler(event : ButtonEvent) : void {
			if (data.item is ICollection) {
				ICollection(data.item).clear();
			}
		}

	}
	
}

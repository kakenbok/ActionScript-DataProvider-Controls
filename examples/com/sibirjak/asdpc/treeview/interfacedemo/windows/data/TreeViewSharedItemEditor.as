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
	import com.sibirjak.asdpc.button.IButton;
	import com.sibirjak.asdpc.common.dataprovider.IItem;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.data.ListBuilderContentRenderer;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.data.SharedItemEditor;
	import com.sibirjak.asdpc.treeview.constants.TreeNodeState;
	import com.sibirjak.asdpc.treeview.core.TreeNodeRendererData;
	import com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent;

	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.iterators.RecursiveIterator;

	import flash.display.DisplayObject;

	/**
	 * @author jes 21.01.2010
	 */
	public class TreeViewSharedItemEditor extends SharedItemEditor {

		[Embed(source="assets/apply_recursive.png")]
		private var _recursiveSkin : Class;

		private var _recursiveButton : IButton;

		public function TreeViewSharedItemEditor() {
			super();
		}

		override public function set contentRenderer(contentRenderer : ListBuilderContentRenderer) : void {
			if (_contentRenderer) {
				_contentRenderer.listItemRenderer.removeEventListener(TreeNodeRendererEvent.TREE_NODE_STATE_CHANGED, treeNodeStateChangedHandler);
			}
			
			super.contentRenderer = contentRenderer;
			
			_contentRenderer.listItemRenderer.addEventListener(TreeNodeRendererEvent.TREE_NODE_STATE_CHANGED, treeNodeStateChangedHandler);
			
			setRecursiveButtonVisibility();
		}

		override protected function draw() : void {
			_recursiveButton = new Button();
			_recursiveButton.setSize(12, 12);
			_recursiveButton.setStyles([
				Button.style.upIconSkin, _recursiveSkin,
				Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME
			]);
			
			_recursiveButton.toolTip = "Set icon to children";

			_recursiveButton.visible = TreeNodeRendererData(_contentRenderer.listItemRenderer.data).treeNodeState != TreeNodeState.LEAF;

			_recursiveButton.addEventListener(ButtonEvent.CLICK, recursiveButtonClickHandler);
			addChild(DisplayObject(_recursiveButton));

			super.draw();
		}

		override protected function getInputX() : uint {
			return _recursiveButton.visible ? 36 : 22;
		}

		override protected function layoutChildren() : void {
			super.layoutChildren();

			_recursiveButton.x = 20;
			_recursiveButton.y = 2;
		}

		private function treeNodeStateChangedHandler(event : TreeNodeRendererEvent) : void {
			setRecursiveButtonVisibility();
		}
		
		private function setRecursiveButtonVisibility() : void {
			if (!_initialised) return;
			
			_recursiveButton.visible = TreeNodeRendererData(_contentRenderer.listItemRenderer.data).treeNodeState != TreeNodeState.LEAF;
			layoutChildren();
		}

		private function recursiveButtonClickHandler(event : ButtonEvent) : void {
			var iterator : IIterator = new RecursiveIterator(_item);
			while (iterator.hasNext()) {
				IItem(iterator.next()).category = _item.category;
			}
		}

	}

}

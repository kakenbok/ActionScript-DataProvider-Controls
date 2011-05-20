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
	import com.sibirjak.asdpc.common.dataprovider.IItem;
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.listview.core.IListItemRenderer;
	import com.sibirjak.asdpc.listview.core.ListItemRendererEvent;
	import com.sibirjak.asdpc.listview.renderer.ListItemContent;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author jes 23.11.2009
	 */
	public class ListBuilderContentRenderer extends ListItemContent {

		/* static */
		public static var sharedItemEditor : SharedItemEditor;

		/* internals */
		protected var _buttonSize : uint = 13;
		protected var _buttonPadding : uint = 2;

		/* children */
		protected var _buttons : Sprite;
		protected var _addBeforeButton : Button;
		protected var _addAfterButton : Button;
		protected var _removeButton : Button;

		protected var _itemEditor : SharedItemEditor;
		
		protected var _buttonStyles : Array = [
			Button.style.disabledSkin, null,

			Button.style.upIconSkin, null,
			Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
			Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME,
			Button.style.disabledIconSkinName, Button.UP_ICON_SKIN_NAME
		];

		public function ListBuilderContentRenderer() {
		}
		
		public function get listItemRenderer() : IListItemRenderer {
			return _listItemRenderer;
		}
		
		override public function set listItemRenderer(listItemRenderer : IListItemRenderer) : void {
			super.listItemRenderer = listItemRenderer;

			_listItemRenderer.addEventListener(ListItemRendererEvent.ROLL_OVER, rendererRollOverHandler);
			_listItemRenderer.addEventListener(ListItemRendererEvent.ROLL_OUT, rendererRollOutHandler);
			_listItemRenderer.addEventListener(ListItemRendererEvent.DATA_CHANGED, dataChangedHandler);
			_listItemRenderer.addEventListener(ListItemRendererEvent.SELECTION_CHANGED, selectionChangedHandler);
			_listItemRenderer.addEventListener(ListItemRendererEvent.VISIBILITY_CHANGED, visibilityChangedHandler);

			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}
		
		protected function getButtonBarWidth() : uint {
			return 3 * (_buttonSize + _buttonPadding) + 6;
		}

		protected function setButtonPosition() : void {
			_addBeforeButton.x = 0;
			_addAfterButton.x = (_buttonSize + _buttonPadding);
			_removeButton.x = (_buttonSize + _buttonPadding) * 2 + 6;
		}

		protected function getSharedItemEditorClass() : Class {
			return SharedItemEditor;
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

			// add before

			_addBeforeButton = new Button();
			_addBeforeButton.setSize(_buttonSize, _buttonSize);
			_addBeforeButton.setStyles(_buttonStyles);
			_addBeforeButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("add_before"));

			_addBeforeButton.toolTip = "Add item before";

			_addBeforeButton.moveTo((_buttonSize + _buttonPadding) * _buttons.numChildren, Math.round((_height - _buttonSize) / 2));
			_addBeforeButton.addEventListener(ButtonEvent.CLICK, addBeforeButtonClickHandler);
			_buttons.addChild(_addBeforeButton);

			// add after

			_addAfterButton = new Button();
			_addAfterButton.setSize(_buttonSize, _buttonSize);
			_addAfterButton.setStyles(_buttonStyles);
			_addAfterButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("add_after"));

			_addAfterButton.toolTip = "Add item after";

			_addAfterButton.moveTo((_buttonSize + _buttonPadding) * _buttons.numChildren, Math.round((_height - _buttonSize) / 2));
			_addAfterButton.addEventListener(ButtonEvent.CLICK, addAfterButtonClickHandler);
			_buttons.addChild(_addAfterButton);

			// remove

 			_removeButton = new Button();
			_removeButton.setSize(_buttonSize, _buttonSize);
			_removeButton.setStyles(_buttonStyles);
			_removeButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("remove"));

			_removeButton.toolTip = "Remove item";

			_removeButton.moveTo((_buttonSize + _buttonPadding) * _buttons.numChildren, Math.round((_height - _buttonSize) / 2));
			_removeButton.addEventListener(ButtonEvent.CLICK, removeButtonClickHandler);
			_buttons.addChild(_removeButton);
		}

		override protected function initialised() : void {
			setButtonPosition();
		}

		override protected function update() : void {
			super.update();
			
			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				_buttons.x = _width - getButtonBarWidth();
				
				if (_itemEditor) _itemEditor.setSize(_width, _height);
			}
		}

		override protected function cleanUpCalled() : void {
			super.cleanUpCalled();

			_listItemRenderer.removeEventListener(ListItemRendererEvent.ROLL_OVER, rendererRollOverHandler);
			_listItemRenderer.removeEventListener(ListItemRendererEvent.ROLL_OUT, rendererRollOutHandler);
			_listItemRenderer.removeEventListener(ListItemRendererEvent.SELECTION_CHANGED, selectionChangedHandler);
			_listItemRenderer.removeEventListener(ListItemRendererEvent.DATA_CHANGED, dataChangedHandler);
			_listItemRenderer.removeEventListener(ListItemRendererEvent.VISIBILITY_CHANGED, visibilityChangedHandler);

			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);

			stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, stageMouseDownHandler);
		}

		/*
		 * ListItemRenderer events
		 */

		private function rendererRollOverHandler(event : ListItemRendererEvent) : void {
			_label.setSize(_buttons.x - 4, _height);
			
			showEditor();
		}

		private function rendererRollOutHandler(event : ListItemRendererEvent) : void {
			_label.setSize(_width, _height);

			hideEditor();
		}

		private function dataChangedHandler(event : ListItemRendererEvent) : void {
			showItemEditor();
			
		}
		
		private function selectionChangedHandler(event : ListItemRendererEvent) : void {
			showItemEditor();
		}
		
		private function showItemEditor() : void {
			
			if (!sharedItemEditor) {
				sharedItemEditor = new (getSharedItemEditorClass())();
			}
			
			if (_listItemRenderer.data.selected) {
				sharedItemEditor.setSize(_width, _height);
				sharedItemEditor.contentRenderer = this;
				sharedItemEditor.y = _height;
				addChild(sharedItemEditor);
				
				sharedItemEditor.validateNow(); // asap resize
				
				_itemEditor = sharedItemEditor;
			} else {
				if (contains(sharedItemEditor)) removeChild(sharedItemEditor);

				_itemEditor = null;
			}
		}
		
		/*
		 * Lock editor
		 */

		// the renderer for that the lock is assigned.
		private static var _rollOverLockedContentRenderer : ListBuilderContentRenderer;

		// a client may set and remove a lock on its own. if a lock is set the
		// locked item never will change.
		private static var _keepedLocks : uint;

		// tracks the mouse event if rollover events are stopped.
		private static var _actuallyOverContentRenderer : ListBuilderContentRenderer;
		
		/*
		 * A locked renderer may become hidden if it at the end of the list and
		 * an item is added before. The listView will dispatch a rollout event then.
		 * The new item added will use the same renderer and should be made visible
		 * again. _wasLocked is to decide if a locked renderer stayed at the same place
		 * but changed its data.
		 */
		private var _wasLocked : Boolean;

		public function keepLock(keepLockID : uint, keep : Boolean) : void {
			if (keep) _keepedLocks ^= keepLockID; 
			else _keepedLocks -= (_keepedLocks & keepLockID);
		}

		public function lockRollOver() : void {
			_rollOverLockedContentRenderer = this;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, stageMouseDownHandler);
		}
		
		public function unlockRollOver() : void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, stageMouseDownHandler);

			_rollOverLockedContentRenderer = null;
			_keepedLocks = 0;

			if (_actuallyOverContentRenderer) { // mouse over a renderer
				// roll over the actual over item
				if (!_actuallyOverContentRenderer._over) { // renderer is not officially marked over
					_actuallyOverContentRenderer.data.notifyRollOver();
				}
				
				// roll out the locked item if mouse not over
				if (_actuallyOverContentRenderer != this) { // renderer is not the locked renderer
					_listItemRenderer.data.notifyRollOut();
				}

			// roll out the locked item if mouse not over
			} else {
				if (_over) _listItemRenderer.data.notifyRollOut();
			}

		}

		private function visibilityChangedHandler(event : ListItemRendererEvent) : void {
			if (_listItemRenderer.visible && _wasLocked) {
				if (_actuallyOverContentRenderer == this) {
					data.notifyRollOver();
				}

			} else {
				if (_rollOverLockedContentRenderer == this) {
					unlockRollOver();
					
					_wasLocked = true;
					return;
				}

			}
			
			_wasLocked = false;
		}
		
		private function stageMouseDownHandler(event : MouseEvent) : void {
			if (!_keepedLocks) unlockRollOver();
		}

		private function rollOverHandler(event : MouseEvent) : void {
			_actuallyOverContentRenderer = this;

			if (!shouldDispatchRollOverRollOut()) {
				event.stopImmediatePropagation();
			}
		}

		private function rollOutHandler(event : MouseEvent) : void {
			_actuallyOverContentRenderer = null;

			if (!shouldDispatchRollOverRollOut()) {
				if (_rollOverLockedContentRenderer == this && !_keepedLocks) {
					unlockRollOver();

				} else {
					event.stopImmediatePropagation();
				}
			}
			
			keepLock(1, false);
		}

		private function shouldDispatchRollOverRollOut() : Boolean {
			if (_rollOverLockedContentRenderer == this) return false;
			if (!_rollOverLockedContentRenderer) return true;
			return false;
		}

		/*
		 * Button events
		 */

		private function buttonAreaClickHandler(event : MouseEvent) : void {
			// do not select current item with a click into the button area
			event.stopPropagation();
		}


		private function addBeforeButtonClickHandler(event : ButtonEvent) : void {
			lockRollOver();
			keepLock(1, true);
			
			var list : IItem = data.parentItem;
			list.i_addItemBefore(data.listItemData, list.i_createItem());
		}

		private function addAfterButtonClickHandler(event : ButtonEvent) : void {
			var list : IItem = data.parentItem;
			list.i_addItemAfter(data.listItemData, list.i_createItem());
		}

		private function removeButtonClickHandler(event : ButtonEvent) : void {
			var list : IItem = data.parentItem;
			list.i_removeItem(data.listItemData);
		}

		/*
		 * Private
		 */

		private function showEditor() : void {
			_buttons.visible = true;
		}
		
		private function hideEditor() : void {
			_buttons.visible = false;
		}

	}
	
}

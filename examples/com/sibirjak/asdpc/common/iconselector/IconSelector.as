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
package com.sibirjak.asdpc.common.iconselector {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.common.iconselector.core.IconList;
	import com.sibirjak.asdpc.common.iconselector.core.IconSelectorWindow;
	import com.sibirjak.asdpc.core.DisplayObjectAdapter;
	import com.sibirjak.asdpc.core.managers.IPopUpControl;
	import com.sibirjak.asdpc.core.managers.IPopUpControlPopUp;
	import com.sibirjak.asdpcbeta.core.managers.PopUpManager;
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.WindowEvent;
	import com.sibirjak.asdpcbeta.window.core.WindowPosition;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * @author jes 14.01.2010
	 */
	public class IconSelector extends Button implements IPopUpControl {
		
		public static const BINDABLE_PROPERTY_SELECTED_ICON : String = "selectedIconSkin";

		/* properties */
		private var _liveChoosing : Boolean = true;
		private var _selectedIconSkin : Class;
		private var _dataSource : Array;

		/* children */
		private var _popUp : IconSelectorWindow;
		private var _iconList : IconList;

		/* styles */
		private var _numIconsPerRow : uint = 8;
		private var _iconSize : uint = 16;
		private var _iconPadding : uint = 2;
		private var _listPadding : uint = 4;

		[Embed(source="assets/button_open_icon.png")]
		private var openIconSkin : Class;

		public function IconSelector() {

			// default size
			setDefaultSize(18, 18);
			
			setBindableProperties([BINDABLE_PROPERTY_SELECTED_ICON]);
			
			setStyles([
				Button.style.upIconSkin, null,
				Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.selectedUpIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.selectedOverIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.selectedDownIconSkinName, Button.UP_ICON_SKIN_NAME
			]);
			
			toggle = true;
		}
		
		/*
		 * IPopUpControl
		 */
		
		public function get popUp() : IPopUpControlPopUp {
			return _popUp;
		}

		/*
		 * IconSelector
		 */

		public function set selectedIconSkin(selectedIconSkin : Class) : void {
			_selectedIconSkin = selectedIconSkin;
			
			setIconSkin();
			
			if (_initialised) {
				_iconList.selectIconSkin(selectedIconSkin);
			}
		}

		public function get selectedIconSkin() : Class {
			return _selectedIconSkin;
		}
		
		public function get selectedIconName() : String {
			return _iconList.getIconName(_selectedIconSkin);
		}
		
		public function set liveChoosing(liveChoosing : Boolean) : void {
			_liveChoosing = liveChoosing;
		}

		public function get liveChoosing() : Boolean {
			return _liveChoosing;
		}

		public function get dataSource() : Array {
			return _dataSource;
		}
		
		public function set dataSource(dataSource : Array) : void {
			_dataSource = dataSource;
		}

		public function notifyIconSelected(iconSkin : Class) : void {
			_selectedIconSkin = iconSkin;

			setIconSkin();
			
			_iconList.selectIconSkin(_selectedIconSkin);

			showPopUp(false);

			updateBindingsForProperty(BINDABLE_PROPERTY_SELECTED_ICON);
		}

		public function notifyIconRollOver(iconSkin : Class) : void {
			if (_liveChoosing) {
				_selectedIconSkin = iconSkin;
	
				setIconSkin();

				updateBindingsForProperty(BINDABLE_PROPERTY_SELECTED_ICON);
			}
		}
		
		override protected function init() : void {
			super.init();
			
			if (!_dataSource) _dataSource = [];
		}

		override protected function draw() : void {
			super.draw();
			
			var openIcon : DisplayObject = new openIconSkin();
			DisplayObjectAdapter.moveTo(
				openIcon,
				Math.round((_width - openIcon.width) / 2),
				_height - openIcon.height - 1
			);
			DisplayObjectAdapter.addChild(openIcon, this);
			
			setIconSkin();

			/* Icon list */
			
			_iconList = new IconList();
			_iconList.setStyles([
				IconList.style_iconSize, _iconSize,
				IconList.style_iconPadding, _iconPadding,
				IconList.style_numIconsPerRow, _numIconsPerRow
			]);

			_iconList.iconSelector = this;
			_iconList.selectIconSkin(selectedIconSkin);
			_iconList.dataSource = _dataSource;
			
			/* PopUp */
			
			_popUp = new IconSelectorWindow();
			
			var numRows : uint =
				_dataSource.length % _numIconsPerRow
				? Math.floor(_dataSource.length / _numIconsPerRow) + 1
				: _dataSource.length / _numIconsPerRow;

			_popUp.setSize(
				2 * _listPadding + 2 + _numIconsPerRow * (_iconSize + 2 * _iconPadding), // 2 * border
				2 * _listPadding + 2 + numRows * (_iconSize + 2 * _iconPadding) // 2 * border
			);
			
			_popUp.setStyles([
				Window.style.padding, _listPadding
			]);
			
			_popUp.document = _iconList;

			_popUp.iconSelector = this;
			_popUp.minimised = true;
			_popUp.addEventListener(WindowEvent.MINIMISED, minimisedHandler);
			_popUp.moveTo(0, _height + 1);
			addChild(DisplayObject(_popUp));
			
		}
		
		override protected function onSelectionChanged() : void {
			showPopUp(selected);
		}
		
		override protected function showIcon() : void {
			super.showIcon();
			
			if (_icon) {
				var iconHeight : uint = _height - 8;
				
				_icon.width = iconHeight;
				_icon.height = iconHeight;
				_icon.x = 4;
				_icon.y = 2;
			}
		}

		/*
		 * Events
		 */
		
		private function minimisedHandler(event : WindowEvent) : void {
			selected = false;
			PopUpManager.getInstance().removePopUp(_popUp);
		}

		/*
		 * Private
		 */
		
		private function showPopUp(show : Boolean) : void {
			if (show) {

				/*
				 * Position
				 */

				var point : Point = localToGlobal(new Point(0, 0));
				
				var posX : uint;
				var posY : uint;
				
				if (point.x > stage.stageWidth / 2) {
					posX = point.x + _width - _popUp.width;
				} else {
					posX = point.x;
				}
	
				posX = Math.min(posX, stage.stageWidth - _width - 4);
				
				if (point.y > stage.stageHeight / 2) {
					posY = point.y - _popUp.height - 4;
				} else {
					posY = point.y + _height + 4;
				}
				
				posY = Math.min(posY, stage.stageHeight - _height - 4);

				_popUp.restorePosition = new WindowPosition(posX, posY);
				_popUp.minimisePosition = new WindowPosition(point.x + Math.round(_width / 2), point.y + Math.round(_height / 2));

				/*
				 * Show popup
				 */

				PopUpManager.getInstance().createPopUp(_popUp);
				_popUp.restore();

				_popUp.addEventListener(WindowEvent.AUTO_MINIMISE_START, autoMinimiseStartHandler);

			} else {
				_popUp.minimise();
			}
		}
		
		private function autoMinimiseStartHandler(event : WindowEvent) : void {
			_popUp.removeEventListener(WindowEvent.AUTO_MINIMISE_START, autoMinimiseStartHandler);
			
			dispatchEvent(event.clone());
		}

		private function setIconSkin() : void {
			setStyle(Button.style.upIconSkin, _selectedIconSkin);
		}

	}
}

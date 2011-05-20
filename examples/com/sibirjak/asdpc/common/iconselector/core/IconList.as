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
package com.sibirjak.asdpc.common.iconselector.core {
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.common.iconselector.IconSelector;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpcbeta.layout.GridLayout;

	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * @author jes 14.01.2010
	 */
	public class IconList extends View {
		
		/* style declarations */
		public static const style_iconSize : String = "iconList_iconSize";
		public static const style_iconPadding : String = "iconList_iconPadding";
		public static const style_numIconsPerRow : String = "iconList_numIconsPerRow";

		private var _iconSelector : IconSelector;
		private var _grid : GridLayout;
		private var _dataSource : Array;
		private var _iconBorder : IconBorder;
		private var _selectedIconBorder : IconBorder;
		private var _skinIconMap : Dictionary;

		private var _selectedIconSkin : Class;
		private var _iconSkinToSelect : Class;
		
		public function IconList() {
			
			setDefaultStyles([
				style_iconSize, 16,
				style_iconPadding, 2,
				style_numIconsPerRow, 8
			]);
			
			_skinIconMap = new Dictionary();
			
			addEventListener(MouseEvent.MOUSE_OVER, iconRollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}

		public function set dataSource(dataSource : Array) : void {
			_dataSource = dataSource;
		}

		public function set iconSelector(iconSelector : IconSelector) : void {
			_iconSelector = iconSelector;
		}
		
		public function getIconName(selectedIconSkin : Class) : String {
			var wrapper : IconWrapper = _skinIconMap[selectedIconSkin];
			if (wrapper) return wrapper.iconName;
			return "";
		}

		public function selectIconSkin(iconSkin : Class) : void {
			if (!_initialised) {
				_iconSkinToSelect = iconSkin;
				return;
			}
			
			_selectedIconSkin = iconSkin;
			
			setSelectedIconBorder();
		}
		
		override protected function draw() : void {
			var iconSize : uint = getStyle(style_iconSize);
			var iconPadding : uint = getStyle(style_iconPadding);
			var iconWrapperSize : uint = iconSize + 2 * iconPadding;

			_grid = new GridLayout;
			_grid.setStyles([
				GridLayout.style.itemWidth, iconSize + 2 * iconPadding,
				GridLayout.style.itemHeight, iconSize + 2 * iconPadding,
				GridLayout.style.itemPadding, 0,
				GridLayout.style.numItemsPerRow, getStyle(style_numIconsPerRow)
			]);
			
			for (var i : uint = 0; i < _dataSource.length; i++) {
				var iconSkin : Class = IconFactory.getInstance().getIconSkin(_dataSource[i]);
				var iconWrapper : IconWrapper = new IconWrapper(iconSkin, _dataSource[i], iconWrapperSize, iconWrapperSize);
				_grid.addChild(iconWrapper);
				
				_skinIconMap[iconSkin] = iconWrapper;
			}
			
			addChild(_grid);

			// selected swatch border
			
			_selectedIconBorder = new IconBorder(iconWrapperSize, iconWrapperSize, 0xFFFF00);
			addChild(_selectedIconBorder);
			_selectedIconBorder.visible = false;

			_iconBorder = new IconBorder(iconWrapperSize, iconWrapperSize);
			addChild(_iconBorder);
			_iconBorder.visible = false;
		}

		override protected function initialised() : void {
			_selectedIconSkin = _iconSkinToSelect;

			setSelectedIconBorder();
		}

		private function setSelectedIconBorder() : void {
			var iconWrapper : IconWrapper = _skinIconMap[_selectedIconSkin];
			
			if (iconWrapper) {
				_selectedIconBorder.x = iconWrapper.x;
				_selectedIconBorder.y = iconWrapper.y;
				_selectedIconBorder.iconSkin = iconWrapper.iconSkin;
				_selectedIconBorder.visible = true;
			} else {
				_selectedIconBorder.visible = false;
			}
		}

		private function clickHandler(event : MouseEvent) : void {
			if (_iconBorder.visible) _iconSelector.notifyIconSelected(_iconBorder.iconSkin);
		}

		private function rollOutHandler(event : MouseEvent) : void {
			_iconBorder.visible = false;

			_iconSelector.notifyIconRollOver(_selectedIconSkin);
		}

		private function iconRollOverHandler(event : MouseEvent) : void {
			event.updateAfterEvent();

			if (event.target is IconWrapper) {
				var iconWrapper : IconWrapper = event.target as IconWrapper;
				_iconBorder.x = iconWrapper.x;
				_iconBorder.y = iconWrapper.y;
				_iconBorder.iconSkin = iconWrapper.iconSkin;
				_iconBorder.visible = true;
				
				_iconSelector.notifyIconRollOver(iconWrapper.iconSkin);
				
				return;
			} else if (event.target == _iconBorder) {
				return;
			}
			_iconBorder.visible = false;
		}
		
	}
}

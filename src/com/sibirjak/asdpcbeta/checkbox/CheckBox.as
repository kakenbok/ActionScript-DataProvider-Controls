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
package com.sibirjak.asdpcbeta.checkbox {
	import com.sibirjak.asdpc.core.DisplayObjectAdapter;
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.core.constants.Position;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpcbeta.checkbox.skins.CheckBoxIconSkin;
	import com.sibirjak.asdpcbeta.checkbox.skins.CheckBoxSkin;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author jes 02.12.2009
	 */
	public class CheckBox extends Button {
		
		public static const style_labelPosition : String = "checkBox_labelPosition";
		public static const style_labelPadding : String = "checkBox_labelPadding";
		public static const style_buttonWidth : String = "checkBox_buttonWidth";
		public static const style_buttonHeight : String = "checkBox_buttonHeight";
		
		private var _iconLabelContainer : Sprite;
		private var _iconLabel : DisplayObject;
		private var _value : *;

		public function CheckBox() {
			
			// default size
			setDefaultSize(16, 16);
			
			setDefaultStyles([
				Button.style.upSkin, CheckBoxSkin,

				Button.style.overSkinName, Button.UP_SKIN_NAME,
				Button.style.downSkinName, Button.UP_SKIN_NAME,
				Button.style.disabledSkin, CheckBoxSkin,

				Button.style.selectedUpSkinName, Button.UP_SKIN_NAME,
				Button.style.selectedOverSkinName, Button.UP_SKIN_NAME,
				Button.style.selectedDownSkinName, Button.UP_SKIN_NAME,
				Button.style.selectedDisabledSkinName, Button.DISABLED_SKIN_NAME,

				Button.style.upIconSkin, null,
				Button.style.overIconSkin, null,
				Button.style.downIconSkin, CheckBoxIconSkin,
				Button.style.disabledIconSkin, null,

				Button.style.selectedUpIconSkin, CheckBoxIconSkin,
				Button.style.selectedOverIconSkinName, Button.SELECTED_UP_ICON_SKIN_NAME,
				Button.style.selectedDownIconSkin, CheckBoxIconSkin,
				Button.style.selectedDisabledIconSkin, CheckBoxIconSkin,
				
				style_labelPosition, Position.RIGHT,
				style_labelPadding, 2,
				style_buttonWidth, 0,
				style_buttonHeight, 0

			]);
			
			toggle = true;
		}

		public function set icon(icon : DisplayObject) : void {
			_iconLabel = icon;
			
			if (_initialised) {
				var labelPadding : uint = getStyle(style_labelPadding);

				while (_iconLabelContainer.numChildren) _iconLabelContainer.removeChildAt(0);

				DisplayObjectAdapter.setSize(_iconLabel, _width - buttonWidth - 2, _height, true);
				_iconLabel.x = buttonWidth + labelPadding;
				DisplayObjectAdapter.addChild(_iconLabel, _iconLabelContainer);
			}
		}

		public function set value(value : *) : void {
			_value = value;
		}

		public function get value() : * {
			return _value;
		}

		override protected function init() : void {
			super.init();
			
			// default size if a label is present
			if (_labelText || _iconLabel) {
				var labelPadding : uint = getStyle(style_labelPadding);

				// label text min size 30;
				if (_labelText) {
					if (_width <= buttonWidth) {
						_width = buttonWidth + labelPadding + 100;
					}
				}
				if (_iconLabel) {
					if (_width <= buttonWidth) {
						_width = buttonWidth + labelPadding + _iconLabel.width;
					}
				}
				
			}
			
		}

		override protected function draw() : void {
			super.draw();

			if (_iconLabel) {
				var labelPadding : uint = getStyle(style_labelPadding);

				_iconLabelContainer = new Sprite();
				addChild(_iconLabelContainer);

				DisplayObjectAdapter.setSize(_iconLabel, _width - buttonWidth - labelPadding, _height, true);
				_iconLabel.x = buttonWidth + labelPadding;
				DisplayObjectAdapter.addChild(_iconLabel, _iconLabelContainer);
			}
		}

		override protected function setLabelBaseStyles() : void {
			super.setLabelBaseStyles();
			
			_label.setStyles([
				Label.style.horizontalAlign, Position.LEFT,
				Label.style.fittingMode, Label.FITTING_MODE_CHOP_LAST
			]);
		}

		override protected function setLabelSize() : void {
			var labelPadding : uint = getStyle(style_labelPadding);
			
			_label.setSize(_width - buttonWidth - labelPadding, _height);

			var position : String = getStyle(style_labelPosition);
			if (position == Position.RIGHT) {
				_label.x = buttonWidth + labelPadding;
			}

		}

		override protected function get buttonWidth() : uint {
			var buttonWidth : uint = getStyle(style_buttonWidth);
			return buttonWidth ? buttonWidth : _height;
		}

		override protected function get buttonHeight() : uint {
			var buttonHeight : uint = getStyle(style_buttonHeight);
			return buttonHeight ? buttonHeight : _height;
		}

		override protected function getToolTipOffsetX() : int {
			var offsetX : int = super.getToolTipOffsetX();
			
			var position : String = getStyle(style_labelPosition);
			if (position == Position.RIGHT) {
				offsetX -= (_width - buttonWidth);
			}
			
			return offsetX;
		}

		override protected function showIcon() : void {
			super.showIcon();
			
			if (_icon) {
				_icon.y = Math.round((_height - _icon.height) / 2);

				var position : String = getStyle(style_labelPosition);
				if (position == Position.LEFT) {
					_icon.x = _width - buttonWidth + Math.round((buttonWidth - _icon.width) / 2);
				}
			}
		}

		override protected function showSkin() : void {
			super.showSkin();
			
			if (_skin) {
				_skin.y = Math.round((_height - buttonHeight) / 2);

				var position : String = getStyle(style_labelPosition);
				if (position == Position.LEFT) {
					_skin.x = _width - buttonWidth;
				}

			}
		}

	}
}

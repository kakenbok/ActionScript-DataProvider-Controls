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
package com.sibirjak.asdpcbeta.colorpicker.core {
	import com.sibirjak.asdpcbeta.colorpicker.ColorPicker;
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.skins.WindowSkin;

	/**
	 * @author jes 08.01.2010
	 */
	public class ColorPickerWindow extends Window {

		/* static */
		private static var _instance : ColorPickerWindow;
		public static function getInstance() : ColorPickerWindow {
			if (!_instance) {
				_instance = new ColorPickerWindow();
				_instance.minimised = true;
			}
			return _instance;
		}
		
		/* properties */
		private var _colorPicker : ColorPicker;

		public function ColorPickerWindow() {
			
			_width = 265;
			_height = 201;
			
			setStyles([
				Window.style.titleBar, false,

				Window.style.restoreDuration, 0.1,
				Window.style.minimiseDuration, 0.2,
				Window.style.minimiseTweenProperties, Window.TWEEN_ALPHA,

				Window.style.padding, 6,

				WindowSkin.style_backgroundLightColor, 0x333333,
				WindowSkin.style_backgroundDarkColor, 0xAAAAAA,

				WindowSkin.style_borderLightColor, 0xAAAAAA,
				WindowSkin.style_borderDarkColor, 0x333333

			]);
			
			minimiseOnClickOutside = true;
			
			document = createWindowContent();
		}
		
		public function set colorPicker(colorPicker : ColorPicker) : void {
			
			if (_colorPicker && _colorPicker != colorPicker) {
				_colorPicker.notifyPopUpOwnerChanged(colorPicker);
			}
			
			_colorPicker = colorPicker;
			minimiseTriggerButton = _colorPicker;

			ColorPickerWindowContent(document).selectColor(_colorPicker.selectedColor);
		}

		public function get colorPicker() : ColorPicker {
			return _colorPicker;
		}

		override protected function onMinimise() : void {
			_colorPicker = null;
		}
		
		protected function createWindowContent() : ColorPickerWindowContent {
			return new ColorPickerWindowContent(this);
		}
		
	}
}

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
	import com.sibirjak.asdpc.common.iconselector.IconSelector;
	import com.sibirjak.asdpc.core.managers.IPopUpControl;
	import com.sibirjak.asdpc.core.managers.IPopUpControlPopUp;
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.skins.WindowSkin;

	/**
	 * @author jes 14.01.2010
	 */
	public class IconSelectorWindow extends Window implements IPopUpControlPopUp {
		private var _iconSelector : IconSelector;
		
		public function IconSelectorWindow() {
			setStyles([
				Window.style.titleBar, false,

				Window.style.restoreDuration, 0.1,
				Window.style.minimiseDuration, 0.1,
				Window.style.minimiseTweenProperties, Window.TWEEN_ALPHA,

				WindowSkin.style_backgroundLightColor, 0x333333,
				WindowSkin.style_backgroundDarkColor, 0xAAAAAA,

				WindowSkin.style_borderLightColor, 0xAAAAAA,
				WindowSkin.style_borderDarkColor, 0x333333
			]);
			
			minimiseOnClickOutside = true;
		}
		
		public function get iconSelector() : IconSelector {
			return _iconSelector;
		}
		
		public function set iconSelector(iconSelector : IconSelector) : void {
			_iconSelector = iconSelector;
			minimiseTriggerButton = _iconSelector;
		}
		
		/*
		 * IPopUpControlPopUp
		 */
		
		public function get popUpControl() : IPopUpControl {
			return _iconSelector;
		}

	}
}

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
package com.sibirjak.asdpc.treeview.renderer.skins {
	import com.sibirjak.asdpc.core.Skin;
	import com.sibirjak.asdpc.treeview.renderer.DisclosureButton;

	/*
	 * Styles
	 */
	
	/**
	 * @copy DisclosureButtonBoxIconSkin#style_iconColor
	 */
	[Style(name="disclosureButtonBoxIconSkin_iconColor", type="uint", format="Color")]

	/**
	 * @copy DisclosureButtonBoxIconSkin#style_fillColor
	 */
	[Style(name="disclosureButtonBoxIconSkin_fillColor", type="uint", format="Color")]

	/**
	 * Box shaped disclosure button icon skin.
	 * 
	 * @author jes 12.08.2009
	 */
	public class DisclosureButtonBoxIconSkin extends Skin {

		/**
		 * Style property defining the icon color.
		 */
		public static const style_iconColor : String = "disclosureButtonBoxIconSkin_iconColor";

		/**
		 * Style property defining the fill color.
		 */
		public static const style_fillColor : String = "disclosureButtonBoxIconSkin_fillColor";
		
		/**
		 * DisclosureButtonBoxIconSkin constructor.
		 */
		public function DisclosureButtonBoxIconSkin() {
			setDefaultStyles([
				style_iconColor, 0x999999,
				style_fillColor, 0xFFFFFF
			]);
		}

		/*
		 * View life cycle
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			
			var iconColor : uint = getStyle(style_iconColor);
			
			// rect
			
			with (graphics) {
				beginFill(getStyle(style_fillColor));
				lineStyle(1, iconColor);
				drawRect(0, 0, _width - 1, _height - 1);
				endFill();
			}
			
			// minus
			
			with (graphics) {
				lineStyle(0, iconColor);
				moveTo(2, _height / 2);
				lineTo(_width - 2, _height / 2);
			}
			
			// plus
			
			if (name == DisclosureButton.COLLAPSED_ICON_SKIN_NAME) {
				with (graphics) {
					lineStyle(0, iconColor);
					moveTo(_width / 2, 2);
					lineTo(_width / 2, _height - 2);
				}
			}
			
		}

	}
}

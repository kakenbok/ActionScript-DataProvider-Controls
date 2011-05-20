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
package com.sibirjak.asdpc.scrollbar.skins {
	import com.sibirjak.asdpc.core.Skin;
	import com.sibirjak.asdpc.core.constants.Direction;
	import com.sibirjak.asdpc.scrollbar.ScrollBar;

	import flash.display.Shape;

	/*
	 * Styles
	 */
	
	/**
	 * @copy ScrollThumbIconSkin#style_iconLightColor
	 */
	[Style(name="scrollThumbIcon_iconLightColor", type="uint", format="Color")]

	/**
	 * @copy ScrollThumbIconSkin#style_iconDarkColor
	 */
	[Style(name="scrollThumbIcon_iconDarkColor", type="uint", format="Color")]

	/**
	 * Scrollbar thumb icon skin.
	 * 
	 * @author jes 16.07.2009
	 */
	public class ScrollThumbIconSkin extends Skin {

		/* Styles */
		
		/**
		 * Style property defining the icon light color.
		 */
		public static const style_iconLightColor : String = "scrollThumbIcon_iconLightColor";

		/**
		 * Style property defining the icon dark color.
		 */
		public static const style_iconDarkColor : String = "scrollThumbIcon_iconDarkColor";

		/**
		 * ScrollThumbIconSkin constructor.
		 */
		public function ScrollThumbIconSkin() {
			setDefaultStyles([
				style_iconLightColor, 0xFCFCFC,
				style_iconDarkColor, 0x999999
			]);
		}
		
		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			
			var direction : String = getViewProperty(ScrollBar.VIEW_PROPERTY_SCROLLBAR_DIRECTION);
			
			var lightColor : uint = getStyle(style_iconLightColor);
			var color : uint = getStyle(style_iconDarkColor);
			
			var icon : Shape = new Shape();
			
			var width : uint;
			if (direction == Direction.VERTICAL) {
				width = _width - Math.round(_width / 4) * 2;
			} else {
				width = _height - Math.round(_height / 4) * 2;
			}

			with (icon.graphics) {

				lineStyle(0, lightColor);
				moveTo(- width / 2, -3);
				lineTo(width / 2, -3);
	
				lineStyle(0, color);
				moveTo(- width / 2, -2);
				lineTo(width / 2, -2);
	
				lineStyle(0, lightColor);
				moveTo(- width / 2, -1);
				lineTo(width / 2, -1);

				lineStyle(0, color);
				moveTo(- width / 2, 0);
				lineTo(width / 2, 0);
			}
			
			if (direction == Direction.HORIZONTAL) {
				icon.rotation = -90;
			}

			icon.x = Math.round(_width  / 2);
			icon.y = Math.round(_height / 2);

			addChild(icon);
			
			
		}

	}
}

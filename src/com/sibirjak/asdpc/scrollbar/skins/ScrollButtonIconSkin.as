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
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.core.Skin;
	import com.sibirjak.asdpc.core.constants.Direction;
	import com.sibirjak.asdpc.scrollbar.ScrollBar;

	import flash.display.Shape;

	/*
	 * Styles
	 */
	
	/**
	 * @copy ScrollButtonIconSkin#style_iconSize
	 */
	[Style(name="scrollButtonIcon_iconSize", type="uint", format="Size")]

	/**
	 * @copy ScrollButtonIconSkin#style_iconColor
	 */
	[Style(name="scrollButtonIcon_iconColor", type="uint", format="Color")]

	/**
	 * @copy ScrollButtonIconSkin#style_disabledIconColor
	 */
	[Style(name="scrollButtonIcon_disabledIconColor", type="uint", format="Color")]

	/**
	 * Scrollbar scroll button icon skin.
	 * 
	 * @author jes 14.07.2009
	 */
	public class ScrollButtonIconSkin extends Skin {

		/* Styles */
		
		/**
		 * Style property defining the icon size.
		 */
		public static const style_iconSize : String = "scrollButtonIcon_iconSize";

		/**
		 * Style property defining the icon color.
		 */
		public static const style_iconColor : String = "scrollButtonIcon_iconColor";

		/**
		 * Style property defining the disabled icon color.
		 */
		public static const style_disabledIconColor : String = "scrollButtonIcon_disabledIconColor";

		/**
		 * ScrollButtonIconSkin constructor.
		 */
		public function ScrollButtonIconSkin() {
			setDefaultStyles([
				style_iconSize, 6,
				style_iconColor, 0x000000,
				style_disabledIconColor, 0x999999
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
			var buttonName : String = getViewProperty(ScrollBar.VIEW_PROPERTY_SCROLLBAR_BUTTON);
			
			var size : uint = getStyle(style_iconSize);
			var color : uint = getStyle(style_iconColor);
			
			if (name == Button.DISABLED_ICON_SKIN_NAME) {
				color = getStyle(style_disabledIconColor);
			}
			
			var icon : Shape = new Shape();
			icon.name = "iconContainer";

			with (icon.graphics) {
				
				lineStyle();
				beginFill(color);
				
				moveTo(0, - (size - 2) / 2);
				lineTo(size / 2, (size - 2) / 2);
				lineTo(- size / 2, (size - 2) / 2);
				lineTo(0, - (size - 2) / 2);

			}
			
			
			// if (direction == Direction.VERTICAL && buttonName == ScrollBar.UP_BUTTON_NAME) {
				// default
			// }

			if (direction == Direction.VERTICAL && buttonName == ScrollBar.DOWN_BUTTON_NAME) {
				icon.rotation = 180;
			}

			else if (direction == Direction.HORIZONTAL && buttonName == ScrollBar.UP_BUTTON_NAME) {
				icon.rotation = -90;
			}

			else if (direction == Direction.HORIZONTAL && buttonName == ScrollBar.DOWN_BUTTON_NAME) {
				icon.rotation = 90;
			}

			icon.x = Math.round(_width / 2);
			icon.y = Math.round(_height/ 2);

			addChild(icon);
			
		}
		
	}
}

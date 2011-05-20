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
package com.sibirjak.asdpc.button.skins {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.core.skins.BackgroundSkin;

	/*
	 * Styles
	 */
	
	/**
	 * @copy ButtonSkin#style_cornerRadius
	 */
	[Style(name="buttonSkin_cornerRadius", type="uint", format="Size")]

	/**
	 * @copy ButtonSkin#style_backgroundAlpha
	 */
	[Style(name="buttonSkin_backgroundAlpha", type="Number", format="Alpha")]

	/**
	 * @copy ButtonSkin#style_backgroundColors
	 */
	[Style(name="buttonSkin_backgroundColors", type="Array", arrayType="uint", format="Color")]

	/**
	 * @copy ButtonSkin#style_overBackgroundColors
	 */
	[Style(name="buttonSkin_overBackgroundColors", type="Array", arrayType="uint", format="Color")]

	/**
	 * @copy ButtonSkin#style_disabledBackgroundColors
	 */
	[Style(name="buttonSkin_disabledBackgroundColors", type="Array", arrayType="uint", format="Color")]

	/**
	 * @copy ButtonSkin#style_border
	 */
	[Style(name="buttonSkin_border", type="Boolean")]

	/**
	 * @copy ButtonSkin#style_borderAlias
	 */
	[Style(name="buttonSkin_borderAlias", type="Boolean")]

	/**
	 * @copy ButtonSkin#style_borderAliasAlpha
	 */
	[Style(name="buttonSkin_borderAliasAlpha", type="Number", format="Alpha")]

	/**
	 * @copy ButtonSkin#style_borderColors
	 */
	[Style(name="buttonSkin_borderColors", type="Array", arrayType="uint", format="Color")]

	/**
	 * The default button skin.
	 * 
	 * <p>This skin is a statful skin used for all 8 button states.</p>
	 * 
	 * @author jes 21.12.2009
	 */
	public class ButtonSkin extends BackgroundSkin {

		/* Styles */
		
		/**
		 * Style property defining the radius of all 4 button corners.
		 */
		public static const style_cornerRadius : String = "buttonSkin_cornerRadius";

		// background

		/**
		 * Style property defining the opacity of the background.
		 */
		public static const style_backgroundAlpha : String = "buttonSkin_backgroundAlpha";

		/**
		 * Style property defining the background colors for the default state.
		 */
		public static const style_backgroundColors : String = "buttonSkin_backgroundColors";

		/**
		 * Style property defining the background colors for the over state.
		 */
		public static const style_overBackgroundColors : String = "buttonSkin_overBackgroundColors";

		/**
		 * Style property defining the background colors for the disabled state.
		 */
		public static const style_disabledBackgroundColors : String = "buttonSkin_disabledBackgroundColors";

		// border
		
		/**
		 * Style property defining the visibility of borders.
		 */
		public static const style_border : String = "buttonSkin_border";

		/**
		 * Style property defining the border alias.
		 */
		public static const style_borderAlias : String = "buttonSkin_borderAlias";

		/**
		 * Style property defining the border alias opacity.
		 */
		public static const style_borderAliasAlpha : String = "buttonSkin_borderAliasAlpha";

		/**
		 * Style property defining the border colors.
		 */
		public static const style_borderColors : String = "buttonSkin_borderColors";

		/*
		 * ButtonSkin
		 */
		
		/**
		 * ButtonSkin constructor.
		 */
		public function ButtonSkin() {
			setDefaultStyles([
				style_cornerRadius, 1,

				style_backgroundAlpha, 1,
				
				style_backgroundColors, [0xF8F8F8, 0xE0E0E0],
				style_overBackgroundColors, [0xFFFFFF, 0xEEEEEE],
				style_disabledBackgroundColors, [0xFFFFFF, 0xFFFFFF],

				style_border, true,
				style_borderAlias, true,
				style_borderAliasAlpha, .1,

				style_borderColors, [0xCCCCCC, 0x666666]
				
			]);
		}

		/*
		 * General
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function cornerRadius() : uint {
			return getStyle(style_cornerRadius);
		}

		/*
		 * Background
		 */

		/**
		 * @inheritDoc
		 */
		override protected function backgroundAlpha() : Number {
			return getStyle(style_backgroundAlpha);
		}

		/**
		 * @inheritDoc
		 */
		override protected function backgroundColors() : Array {
			var colors : Array = new Array();
			
			switch (name) {
				case Button.UP_SKIN_NAME:
					colors = getStyle(style_backgroundColors);
					break;

				case Button.OVER_SKIN_NAME:
					colors = getStyle(style_overBackgroundColors);
					break;

				case Button.DISABLED_SKIN_NAME:
					colors = getStyle(style_disabledBackgroundColors);
					break;

				case Button.DOWN_SKIN_NAME:
				case Button.SELECTED_UP_SKIN_NAME:
				case Button.SELECTED_DOWN_SKIN_NAME:
					var backgroundColors : Array = getStyle(style_backgroundColors);
					if (backgroundColors) {
						if (backgroundColors.length == 2) colors = [backgroundColors[1], backgroundColors[0]];
						else colors = [backgroundColors[0]];
					}
					break;

				case Button.SELECTED_OVER_SKIN_NAME:
					var overColors : Array = getStyle(style_overBackgroundColors);
					if (overColors) {
						if (overColors.length == 2) colors = [overColors[1], overColors[0]];
						else colors = [overColors[0]];
					}
					break;

				case Button.SELECTED_DISABLED_SKIN_NAME:
					var disabledColors : Array = getStyle(style_disabledBackgroundColors);
					if (disabledColors) {
						if (disabledColors.length == 2) colors = [disabledColors[1], disabledColors[0]];
						else colors = [disabledColors[0]];
					}
					break;
			}

			return colors;

			
		}

		/*
		 * Border
		 */

		/**
		 * @inheritDoc
		 */
		override protected function border() : Boolean {
			return getStyle(style_border);
		}

		/**
		 * @inheritDoc
		 */
		override protected function borderAlias() : Boolean {
			return getStyle(style_borderAlias);
		}

		/**
		 * @inheritDoc
		 */
		override protected function borderAliasAlpha() : Number {
			return getStyle(style_borderAliasAlpha);
		}

		/**
		 * @inheritDoc
		 */
		override protected function borderColors() : Array {
			var colors : Array = getStyle(style_borderColors);
			
			switch (name) {
				case Button.DOWN_SKIN_NAME:
				case Button.SELECTED_DOWN_SKIN_NAME:
				case Button.SELECTED_UP_SKIN_NAME:
				case Button.SELECTED_OVER_SKIN_NAME:
				case Button.SELECTED_DISABLED_SKIN_NAME:
					if (colors.length == 2) colors = [colors[1], colors[0]];
					else colors = [colors[0]];
					break;
			}
			
			return colors;
		}

	}
}

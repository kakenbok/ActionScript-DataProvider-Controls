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
package com.sibirjak.asdpc.button {

	/**
	 * Button style properties.
	 * 
	 * @author jes 17.07.2009
	 */
	public class ButtonStyles {

		/* 
		 * Background skin
		 */

		/**
		 * Style property defining the up skin.
		 */
		public const upSkin : String = "button_upSkin";

		/**
		 * Style property defining the over skin.
		 */
		public const overSkin : String = "button_overSkin";

		/**
		 * Style property defining the down skin.
		 */
		public const downSkin : String = "button_downSkin";

		/**
		 * Style property defining the disabled skin.
		 */
		public const disabledSkin : String = "button_disabledSkin";

		/**
		 * Style property defining the selected up skin.
		 */
		public const selectedUpSkin : String = "button_selectedUpSkin";

		/**
		 * Style property defining the selected over skin.
		 */
		public const selectedOverSkin : String = "button_selectedOverSkin";

		/**
		 * Style property defining the selected down skin.
		 */
		public const selectedDownSkin : String = "button_selectedDownSkin";

		/**
		 * Style property defining the selected disabled skin.
		 */
		public const selectedDisabledSkin : String = "button_selectedDisabledSkin";

		/* 
		 * State to skin name mapping
		 */

		/**
		 * Style property defining the skin name used for the up state.
		 */
		public const upSkinName : String = "button_upSkinName";

		/**
		 * Style property defining the skin name used for the over state.
		 */
		public const overSkinName : String = "button_overSkinName";

		/**
		 * Style property defining the skin name used for the down state.
		 */
		public const downSkinName : String = "button_downSkinName";

		/**
		 * Style property defining the skin name used for the disabled state.
		 */
		public const disabledSkinName : String = "button_disabledSkinName";

		/**
		 * Style property defining the skin name used for the selected up state.
		 */
		public const selectedUpSkinName : String = "button_selectedUpSkinName";

		/**
		 * Style property defining the skin name used for the selected over state.
		 */
		public const selectedOverSkinName : String = "button_selectedOverSkinName";

		/**
		 * Style property defining the skin name used for the selected down state.
		 */
		public const selectedDownSkinName : String = "button_selectedDownSkinName";

		/**
		 * Style property defining the skin name used for the selected disabled state.
		 */
		public const selectedDisabledSkinName : String = "button_selectedDisabledSkinName";

		/* 
		 * Icon skin
		 */

		/**
		 * Style property defining the up icon skin.
		 */
		public const upIconSkin : String = "button_upIconSkin";

		/**
		 * Style property defining the over icon skin.
		 */
		public const overIconSkin : String = "button_overIconSkin";

		/**
		 * Style property defining the down icon skin.
		 */
		public const downIconSkin : String = "button_downIconSkin";

		/**
		 * Style property defining the disabled icon skin.
		 */
		public const disabledIconSkin : String = "button_disabledIconSkin";

		/**
		 * Style property defining the selected up icon skin.
		 */
		public const selectedUpIconSkin : String = "button_selectedUpIconSkin";

		/**
		 * Style property defining the selected over icon skin.
		 */
		public const selectedOverIconSkin : String = "button_selectedOverIconSkin";

		/**
		 * Style property defining the selected down icon skin.
		 */
		public const selectedDownIconSkin : String = "button_selectedDownIconSkin";

		/**
		 * Style property defining the selected disabled icon skin.
		 */
		public const selectedDisabledIconSkin : String = "button_selectedDisabledIconSkin";
		
		/* 
		 * State to icon name mapping
		 */

		/**
		 * Style property defining the icon skin name used for the up state.
		 */
		public const upIconSkinName : String = "button_upIconSkinName";

		/**
		 * Style property defining the icon skin name used for the over state.
		 */
		public const overIconSkinName : String = "button_overIconSkinName";

		/**
		 * Style property defining the icon skin name used for the down state.
		 */
		public const downIconSkinName : String = "button_downIconSkinName";

		/**
		 * Style property defining the icon skin name used for the disabled state.
		 */
		public const disabledIconSkinName : String = "button_disabledIconSkinName";

		/**
		 * Style property defining the icon skin name used for the selected up state.
		 */
		public const selectedUpIconSkinName : String = "button_selectedUpIconSkinName";

		/**
		 * Style property defining the icon skin name used for the selected over state.
		 */
		public const selectedOverIconSkinName : String = "button_selectedOverIconSkinName";

		/**
		 * Style property defining the icon skin name used for the selected down state.
		 */
		public const selectedDownIconSkinName : String = "button_selectedDownIconSkinName";

		/**
		 * Style property defining the icon skin name used for the selected disabled state.
		 */
		public const selectedDisabledIconSkinName : String = "button_selectedDisabledIconSkinName";

		/* 
		 * Icon properties
		 */

		/**
		 * Style property defining the coloration of the icon.
		 */
		public const coloriseIcon : String = "button_coloriseIcon";

		/**
		 * Style property defining the color of icon coloration.
		 */
		public const iconColor : String = "button_iconColor";

		/**
		 * Style property defining the opacity of the icon for the disabled state.
		 */
		public const disabledIconAlpha : String = "button_disabledIconAlpha";

		/* 
		 * Label
		 */

		/**
		 * Style property defining the label default styles.
		 * 
		 * <listing>
				button.setStyle(Button.style.labelStyles, [
					Label.style.color, 0xFF0000,
					Label.style.bold, false,
					Label.style.size, 10
				]);
		 * </listing>
		 */
		public const labelStyles : String = "button_labelStyles";

		/**
		 * Style property defining the label styles for the over state.
		 * 
		 * <listing>
				button.setStyle(Button.style.overLabelStyles, [
					Label.style.color, 0x0000FF,
					Label.style.bold, true,
					Label.style.size, 10
				]);
		 * </listing>
		 */
		public const overLabelStyles : String = "button_overLabelStyles";

		/**
		 * Style property defining the label styles for the selected state.
		 * 
		 * <listing>
				button.setStyle(Button.style.selectedLabelStyles, [
					Label.style.color, 0xFF0000,
					Label.style.bold, true,
					Label.style.size, 12
				]);
		 * </listing>
		 */
		public const selectedLabelStyles : String = "button_selectedLabelStyles";

		/**
		 * Style property defining the label styles for the disabled state.
		 * 
		 * <listing>
				button.setStyle(Button.style.disabledLabelStyles, [
					Label.style.color, 0xCCCCCC,
					Label.style.bold, false,
					Label.style.size, 10
				]);
		 * </listing>
		 */
		public const disabledLabelStyles : String = "button_disabledLabelStyles";

		/* 
		 * Auto repeat
		 */

		/**
		 * Style property defining the auto repeat delay for auto repeat buttons.
		 */
		public const autoRepeatDelay : String = "button_autoRepeatDelay";

		/**
		 * Style property defining the auto repeat rate for auto repeat buttons.
		 */
		public const autoRepeatRate : String = "button_autoRepeatRate";
		
		/* 
		 * Tooltip
		 */

		/**
		 * Style property defining the x position of the tool tip.
		 */
		public const toolTipOffsetX : String = "button_toolTipOffsetX";

		/**
		 * Style property defining the y position of the tool tip.
		 */
		public const toolTipOffsetY : String = "button_toolTipOffsetY";

	}
}

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
package com.sibirjak.asdpcbeta.slider.skins {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.core.Skin;
	import com.sibirjak.asdpc.core.constants.Direction;
	import com.sibirjak.asdpcbeta.slider.Slider;

	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;

	/**
	 * @author jes 02.12.2009
	 */
	public class SliderThumbSkin extends Skin {

		/* Styles */
		
		public static const style_backgroundLightColor : String = "sliderThumbSkin_backgroundLightColor";
		public static const style_overBackgroundLightColor : String = "sliderThumbSkin_overBackgroundLightColor";
		public static const style_disabledBackgroundLightColor : String = "sliderThumbSkin_disabledBackgroundLightColor";

		public static const style_backgroundDarkColor : String = "sliderThumbSkin_backgroundDarkColor";
		public static const style_overBackgroundDarkColor : String = "sliderThumbSkin_overBackgroundDarkColor";
		public static const style_disabledBackgroundDarkColor : String = "sliderThumbSkin_disabledBackgroundDarkColor";

		public static const style_backgroundAlpha : String = "sliderThumbSkin_backgroundAlpha";

		public static const style_borderLightColor : String = "sliderThumbSkin_borderLightColor";
		public static const style_borderDarkColor : String = "sliderThumbSkin_borderDarkColor";

		public static const style_borderCornerGap : String = "sliderThumbSkin_borderCornerGap";

		public function SliderThumbSkin() {
			setDefaultStyles([
				style_backgroundLightColor, 0xF8F8F8,
				style_overBackgroundLightColor, 0xFFFFFF,
				style_disabledBackgroundLightColor, 0xFFFFFF,

				style_backgroundDarkColor, 0xE0E0E0,
				style_overBackgroundDarkColor, 0xEEEEEE,
				style_disabledBackgroundDarkColor, 0xFFFFFF,
				
				style_backgroundAlpha, 1,

				style_borderLightColor, 0xCCCCCC,
				style_borderDarkColor, 0x666666,
				
				style_borderCornerGap, true
				
			]);
		}

		override protected function draw() : void {
			
			var backgroundColor1 : uint;
			var backgroundColor2 : uint;
			var borderColor1 : uint;
			var borderColor2 : uint;
			
			switch (name) {
				case Button.UP_SKIN_NAME:
					backgroundColor1 = getStyle(style_backgroundLightColor);
					backgroundColor2 = getStyle(style_backgroundDarkColor);
	
					borderColor1 = getStyle(style_borderLightColor);
					borderColor2 = getStyle(style_borderDarkColor);
					break;

				case Button.OVER_SKIN_NAME:
					backgroundColor1 = getStyle(style_overBackgroundLightColor);
					backgroundColor2 = getStyle(style_overBackgroundDarkColor);
	
					borderColor1 = getStyle(style_borderLightColor);
					borderColor2 = getStyle(style_borderDarkColor);
					break;

				case Button.DOWN_SKIN_NAME:
					backgroundColor1 = getStyle(style_overBackgroundDarkColor);
					backgroundColor2 = getStyle(style_overBackgroundLightColor);
	
					borderColor1 = getStyle(style_borderDarkColor);
					borderColor2 = getStyle(style_borderLightColor);
					break;

				case Button.DISABLED_SKIN_NAME:
					backgroundColor1 = getStyle(style_disabledBackgroundLightColor);
					backgroundColor2 = getStyle(style_disabledBackgroundDarkColor);
	
					borderColor1 = getStyle(style_borderLightColor);
					borderColor2 = getStyle(style_borderDarkColor);
					break;
			}
			
			var direction : String = getViewProperty(Slider.VIEW_PROPERTY_SLIDER_DIRECTION);
			
			var thumb : Shape = new Shape();
			addChild(thumb);
			
			var w : uint = _width;
			var h : uint = _height;
			
			if (direction == Direction.VERTICAL) {
				thumb.rotation = 90;
				thumb.scaleY = -1;

				w = _height;
				h = _width;
			}

			var alpha : Number = getStyle(style_backgroundAlpha); 
			var angle : Number = Math.PI / 180 * 45;
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(w, h, angle, 0, 0);
			var colors : Array = [backgroundColor1, backgroundColor2];
			var diff : uint = getStyle(style_borderCornerGap) ? 1 : 0;
			
			with (thumb.graphics) {
				
				/*
				 * background
				 */

				beginGradientFill(GradientType.LINEAR, colors, [alpha, alpha], [0, 255], matrix);

				lineStyle(0, 0xFF0000, 0);

				moveTo(w / 2, h - 1);
				lineTo(1, h - (w / 2) - 1);
				lineTo(1, 1);
				lineTo(w - 1, 1);
				lineTo(w - 1, diff + 1);
				lineTo(w - 1, h - (w / 2));
				lineTo(w / 2, h - 1);
				
				endFill();
				
				/*
				 * borders
				 */

				// left top border

				lineStyle(1, borderColor1);

				moveTo(w / 2, h - 1);
				lineTo(0, h - (w / 2) - 1);
				moveTo(0, h - (w / 2));
				lineTo(0, diff);
				moveTo(diff, 0);
				lineTo(w - 1, 0);

				// right bottom border

				lineStyle(1, borderColor2);

				moveTo(w - 1, diff);
				lineTo(w - 1, h - (w / 2));
				lineTo(w / 2, h - 1);

				// inner left top border

				lineStyle(1, borderColor1, .1);

				moveTo(w / 2, h - 2);
				lineTo(1, h - (w / 2) - 1);
				lineTo(1, 1);
				lineTo(w - 1, 1);

				// inner right bottom border

				lineStyle(1, borderColor2, .1);

				lineTo(w - 2, diff + 1);
				lineTo(w - 2, h - (w / 2));
				lineTo(w / 2, h - 2);

			}
			
		}
	}
}

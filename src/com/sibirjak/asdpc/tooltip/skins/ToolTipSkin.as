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
package com.sibirjak.asdpc.tooltip.skins {
	import com.sibirjak.asdpc.core.Skin;

	import flash.display.Shape;
	import flash.geom.Rectangle;

	/*
	 * Styles
	 */
	
	/**
	 * @copy ToolTipSkin#style_backgroundColor
	 */
	[Style(name="toolTipSkin_backgroundColor", type="uint", format="Color")]

	/**
	 * @copy ToolTipSkin#style_borderColor
	 */
	[Style(name="toolTipSkin_borderColor", type="uint", format="Color")]

	/**
	 * @copy ToolTipSkin#style_cornerRadius
	 */
	[Style(name="toolTipSkin_cornerRadius", type="uint", format="Size")]

	/**
	 * @copy ToolTipSkin#style_noseSize
	 */
	[Style(name="toolTipSkin_noseSize", type="uint", format="Size")]

	/**
	 * ToolTip skin.
	 * 
	 * @author jes 10.12.2009
	 */
	public class ToolTipSkin extends Skin {
		
		/**
		 * Style property defining the background color.
		 */
		public static var style_backgroundColor : String = "toolTipSkin_backgroundColor";

		/**
		 * Style property defining the corner radius.
		 */
		public static var style_cornerRadius : String = "toolTipSkin_cornerRadius";

		/**
		 * Style property defining the nose size.
		 */
		public static var style_noseSize : String = "toolTipSkin_noseSize";
		
		/**
		 * Background.
		 */
		private var _background : Shape;

		/**
		 * ToolTipSkin constructor.
		 */
		public function ToolTipSkin() {
			setDefaultStyles([
				style_backgroundColor, 0xFFFFBB,
				style_cornerRadius, 3,
				style_noseSize, 8
			]);
		}
		
		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			
			_background = new Shape();
			
			var radius : uint = getStyle(style_cornerRadius);
			
			var noseSize : uint = getStyle(style_noseSize);

			var w : Number = _width;
			var h : Number = _height - noseSize;
			
			if (w < 20) w = 20;
			if (h < 20) h = 20;
			
			with (_background.graphics) {
		
				/*
				 * Background
				 */

				beginFill(getStyle(style_backgroundColor));

				moveTo(radius, 0);

				// top
				lineTo(w - radius, 0);
				lineTo(w, radius);

				// right
				lineTo(w, h - radius);
				lineTo(w - radius, h);

				// bottom
				lineTo((2 * noseSize), h);
				lineTo(noseSize, h + (noseSize));
				lineTo(noseSize, h);
				lineTo(radius, h);
				lineTo(0, h - radius);

				// left
				lineTo(0, radius);
				lineTo(radius, 0);
			}
			

			_background.scale9Grid = new Rectangle(
				2 * noseSize + 2,
				2 * radius,
				w - (2 * noseSize + 2) - 2 * radius,
				h - 4 * radius
			);
			
			addChild(_background);

		}
		
		/*
		 * Skin protected
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function updateSize() : void {
			_background.scaleX = _width / 100;
			_background.scaleY = _height / 100;
		}

	}
}

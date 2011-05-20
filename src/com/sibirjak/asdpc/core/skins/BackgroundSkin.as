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
package com.sibirjak.asdpc.core.skins {
	import com.sibirjak.asdpc.core.Skin;

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * BackgroundSkin base implementation.
	 * 
	 * <p>The BackgroundSkin draws a rectangular area filled with a gradient of the
	 * specified background colors and stuffed with borders. There are several
	 * properties available to customise the BackgroundSkin. In order to do so,
	 * the BackgroundSkin must be specialised.</p>
	 * 
	 * <p>The BackgroundSkin uses the scale9 scaling algorithm for any resize
	 * operation.</p>
	 * 
	 * @author jes 21.12.2009
	 */
	public class BackgroundSkin extends Skin {

		/**
		 * Name constant for the top border.
		 */
		public static const TOP_BORDER : uint = 1 << 0;

		/**
		 * Name constant for the right border.
		 */
		public static const RIGHT_BORDER : uint = 1 << 1;

		/**
		 * Name constant for the bottom border.
		 */
		public static const BOTTOM_BORDER : uint = 1 << 2;

		/**
		 * Name constant for the left border.
		 */
		public static const LEFT_BORDER : uint = 1 << 3;

		/**
		 * Name constant for all borders.
		 */
		public static const ALL_BORDER : uint = TOP_BORDER + RIGHT_BORDER + BOTTOM_BORDER + LEFT_BORDER;

		/**
		 * Name constant defining the default size.
		 */
		private var DEFAULT_SIZE : uint = 100;

		/**
		 * scale9 resizable background.
		 */
		private var _background : Sprite;

		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			
			// radius

			var cornerRadius : uint = cornerRadius();

			// background

			var background : Boolean = background();

			var backgroundAlpha : uint = backgroundAlpha();
			var backgroundRotation : int = backgroundRotation();

			// border
			
			var border : Boolean = border();

			var borderAlias : Boolean = borderAlias();
			var borderAliasAlpha : Number = borderAliasAlpha();
			
			_background = new Sprite();
			_background.name = "scale9Container";
			
			var gradientColors : Array = backgroundColors();
			var matrix : Matrix = new Matrix();
			var rotation : Number = Math.PI / 180 * backgroundRotation;
			var i : uint;
			var borderAliasShape : Shape;

			with (_background.graphics) {
				
				// empty rect to force 100x100 px shape necessary for the scale9 grid.
				beginFill(0, 0);
				drawRect(0, 0, DEFAULT_SIZE, DEFAULT_SIZE);
				
				/*
				 * Background
				 */

				if (background) {
					
					if (gradientColors) {
						
						if (gradientColors.length == 2) {
							matrix.createGradientBox(DEFAULT_SIZE, DEFAULT_SIZE, rotation, 0, 0);
							
							beginGradientFill(
								GradientType.LINEAR,
								[gradientColors[0], gradientColors[1]],
								[backgroundAlpha, backgroundAlpha],
								[0, 255],
								matrix
							);
							
						} else {
							beginFill(gradientColors[0]);
						}
						
						for (i = 0; i < cornerRadius; i++) {
							// top
							drawRect(cornerRadius - i, i, DEFAULT_SIZE - 2 * (cornerRadius - i), 1);
							// bottom
							drawRect(cornerRadius - i, DEFAULT_SIZE - 1 - i, DEFAULT_SIZE - 2 * (cornerRadius - i), 1);
						}
						
						// fill
						drawRect(0, i, DEFAULT_SIZE, DEFAULT_SIZE - 2 * cornerRadius);
					}

				}

				/*
				 * Border
				 */
			
				if (border) {
					
					drawBorder(_background.graphics, cornerRadius);
					
					if (borderAlias) {
						borderAliasShape = new Shape();
						borderAliasShape.name = "borderAlias";
						// empty rect to force 100x100 px shape.
						with (borderAliasShape.graphics) {
							beginFill(0, 0);
							drawRect(0, 0, 100, 100);
						}
						drawBorder(borderAliasShape.graphics, cornerRadius ? cornerRadius - 1 : 0);
						borderAliasShape.x = borderAliasShape.y = 1;
						borderAliasShape.width = borderAliasShape.height = DEFAULT_SIZE - 2;
						borderAliasShape.alpha = borderAliasAlpha;
						_background.addChild(borderAliasShape);
					}

				}
				
			}
			
			/*
			 * add background
			 */
			
			_background.scale9Grid = new Rectangle(
				cornerRadius + 1,
				cornerRadius + 1,
				DEFAULT_SIZE - 2 * cornerRadius - 2,
				DEFAULT_SIZE - 2 * cornerRadius - 2
			);
			addChild(_background);

			/*
			 * add background mask
			 */

			updateSize();

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

		/*
		 * Properties
		 */
		
		/*
		 * General
		 */

		/**
		 * Returns the corner radius.
		 * 
		 * <p>The default value is 1.</p>
		 * 
		 * @return The corner radius.
		 */
		protected function cornerRadius() : uint {
			return 1;
		}

		/*
		 * Background
		 */

		/**
		 * Returns the background visibility.
		 * 
		 * <p>The default value is true.</p>
		 * 
		 * @return The background visibility.
		 */
		protected function background() : Boolean {
			return true;
		}

		/**
		 * Returns the background alpha value.
		 * 
		 * <p>The default value is 1.</p>
		 * 
		 * @return The background alpha value.
		 */
		protected function backgroundAlpha() : Number {
			return 1;
		}

		/**
		 * Returns the background gradient fill rotation.
		 * 
		 * <p>The default value is 45.</p>
		 * 
		 * @return The background gradient fill rotation.
		 */
		protected function backgroundRotation() : Number {
			return 45;
		}

		/**
		 * Returns the background colors.
		 * 
		 * <p>The default values are [0xF8F8F8, 0xE0E0E0].</p>
		 * 
		 * @return The background colors.
		 */
		protected function backgroundColors() : Array {
			return [0xF8F8F8, 0xE0E0E0];
		}

		/*
		 * Border
		 */

		/**
		 * Returns the border visibility.
		 * 
		 * <p>The default value is true.</p>
		 * 
		 * @return The border visibility.
		 */
		protected function border() : Boolean {
			return true;
		}

		/**
		 * Returns the visible border sides.
		 * 
		 * <p>The default value is ALL_BORDER.</p>
		 * 
		 * @return The visible border sides.
		 */
		protected function borderSides() : uint {
			return ALL_BORDER;
		}

		/**
		 * Returns the border alias.
		 * 
		 * <p>The default value is true.</p>
		 * 
		 * @return The border alias.
		 */
		protected function borderAlias() : Boolean {
			return true;
		}

		/**
		 * Returns the border alias alpha value.
		 * 
		 * <p>The default value is .1.</p>
		 * 
		 * @return The border alias alpha value.
		 */
		protected function borderAliasAlpha() : Number {
			return .1;
		}
		
		/**
		 * Returns the border colors.
		 * 
		 * <p>The default values are [0xCCCCCC, 0x666666].</p>
		 * 
		 * @return The border colors.
		 */
		protected function borderColors() : Array {
			return [0xCCCCCC, 0x666666];
		}

		/*
		 * Private
		 */
		 
		/**
		 * Draws the border
		 */
		private function drawBorder(graphics : Graphics, cornerRadius : uint) : void {
			
			var borderSides : uint = borderSides();
			var top : Boolean = (borderSides & TOP_BORDER) == TOP_BORDER;
			var right : Boolean = (borderSides & RIGHT_BORDER) == RIGHT_BORDER;
			var bottom : Boolean = (borderSides & BOTTOM_BORDER) == BOTTOM_BORDER;
			var left : Boolean = (borderSides & LEFT_BORDER) == LEFT_BORDER;

			var bottomRightBorderColor : uint;

			var borderColors : Array = borderColors();
			
			var topLeftBorderColor : uint = borderColors[0];

			if (borderColors.length == 2) {
				bottomRightBorderColor = borderColors[1];
			} else {
				bottomRightBorderColor = borderColors[0];
			}
			
			var i : uint;

			with (graphics) {
				
				beginFill(topLeftBorderColor);
				
				// left - 0,0 -> 0,99

				if (left) {
					if (cornerRadius) {
						drawRect(0, DEFAULT_SIZE - cornerRadius, 1, - (DEFAULT_SIZE - 2 * cornerRadius));
					} else {
						drawRect(
							0,
							DEFAULT_SIZE - (bottom ? 1 : 0),
							1,
							- (DEFAULT_SIZE - (top ? 1 : 0) - (bottom ? 1 : 0))
						);
					}
				}

				// top - 1,0 -> 99,0
				
				if (top) {
					if (cornerRadius) {
						drawRect(cornerRadius, 0, DEFAULT_SIZE - 2 * cornerRadius, 1);
					} else {
						drawRect(
							0,
							0,
							DEFAULT_SIZE - (right ? 1 : 0),
							1
						);
					}
				}

				beginFill(bottomRightBorderColor);

				// right - 100,0 -> 100,99
				
				if (right) {
					if (cornerRadius) {
						drawRect(DEFAULT_SIZE - 1, cornerRadius, 1, DEFAULT_SIZE - 2 * cornerRadius);
					} else {
						drawRect(
							DEFAULT_SIZE - 1,
							0,
							1,
							DEFAULT_SIZE - (bottom ? 1 : 0)
						);
					}
				}

				// bottom - 100,100 -> 0,100

				if (bottom) {
					if (cornerRadius) {
						drawRect(DEFAULT_SIZE - cornerRadius, DEFAULT_SIZE - 1, - (DEFAULT_SIZE - 2 * cornerRadius), 1);
					} else {
						drawRect(DEFAULT_SIZE, DEFAULT_SIZE - 1, - DEFAULT_SIZE, 1);
					}
				}

				for (i = 1; i < cornerRadius; i++) {
					
					beginFill(topLeftBorderColor);

					// top left
					if (top) drawRect(i, cornerRadius - i, 1, 1);
					
					// bottom left
					if (left) drawRect(cornerRadius - i, DEFAULT_SIZE - 1 - i, 1, 1);
					
					beginFill(bottomRightBorderColor);

					// top right
					if (right) {
						drawRect(DEFAULT_SIZE - 1 - (cornerRadius - i), i, 1, 1);
					}
					
					// bottom right
					if (bottom) drawRect(DEFAULT_SIZE - 1 - i, DEFAULT_SIZE - 1 - (cornerRadius - i), 1, 1);
					
				}
				
			}
			
		}

	}
}

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
package com.sibirjak.asdpc.core {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.ColorTransform;

	/**
	 * Generic adapter to several display object types.
	 * 
	 * <p>A display object generally can be one of the following types:</p>
	 * 
	 * <ul>
	 * <li>IView instance: Use the IView interface to set size and to validate.</li>
	 * <li>ISkin instance: Use the ISkin interface to set size and to validate.
	 * Invokes drawSkin after the ISkin has been added to its owner the first time.</li>
	 * <li>Native Flash display object (Sprite, Bitmap): Set size via the native methods
	 * (.width, .height). If the display object is a bitmap, bitmap smoothing get
	 * enabled after the object has been added to its owner the first time.</li>
	 * </ul>
	 * 
	 * @author jes 30.10.2009
	 */
	public class DisplayObjectAdapter {

		/**
		 * Resizes a display object.
		 * 
		 * <p>If the flag fitBitmapToSize is set, a bitmap object that would exceed the
		 * given dimensions will be fitted by keeping its aspect ratio. This is useful
		 * e.g. with icon skins for buttons.</p>
		 * 
		 * @param displayObject The display object.
		 * @param width The object width.
		 * @param height The object height.
		 * @param fitBitmapToSize A flag to fit bitmap object to the dimensions by keeping the aspect ratio.
		 */
		public static function setSize(displayObject : DisplayObject, width : uint, height : uint, fitBitmapToSize : Boolean = false) : void {
			if (displayObject is IView) {
				IView(displayObject).setSize(width, height);
				
			} else if (displayObject is ISkin) {
				ISkin(displayObject).setSize(width, height);
				
			} else {
				// probably a bitmap
				if (fitBitmapToSize) {
					// fit bitmap
					displayObject.scaleX = displayObject.scaleY = Math.min(1, width / displayObject.width, height / displayObject.height);
					// and center object
					displayObject.x = Math.round((width - displayObject.width) / 2);
					displayObject.y = Math.round((height - displayObject.height) / 2);
				} else {
					displayObject.width = width;
					displayObject.height = height;
				}
			}
		}
		
		/**
		 * Validates the given display object.
		 * 
		 * <p>An IView instance calls its validateNow() method, an ISkin instance will
		 * be redrawn. For an arbitrary DisplayObject will nothing be done.</p>
		 * 
		 * @param displayObject The display object.
		 */
		public static function validateNow(displayObject : DisplayObject) : void {
			if (displayObject is IView) {
				IView(displayObject).validateNow();
				
			} else if (displayObject is ISkin) {
				ISkin(displayObject).drawSkin();
			}
		}

		/**
		 * Cleans up the given display object.
		 * 
		 * <p>An IView instance gets its cleanUp() method called, other types are
		 * not affected.</p>
		 * 
		 * @param displayObject The display object to clean up.
		 */
		public static function cleanUp(displayObject : DisplayObject) : void {
			if (displayObject is IView) {
				IView(displayObject).cleanUp();
			}
		}

		/**
		 * Moves a display object.
		 * 
		 * <p>This is a convenience method. You may use object.x and object.y instead.</p>
		 * 
		 * @param displayObject The display object.
		 * @param x The x position.
		 * @param y The y position.
		 */
		public static function moveTo(displayObject : DisplayObject, x : int, y : int) : void {
			displayObject.x = x;
			displayObject.y = y;
		}
		
		/**
		 * Adds a displayObject as the topmost child to the display list.
		 * 
		 * <p>Utilises the addChildAt() method of this class.</p>
		 * 
		 * @param displayObject The display object.
		 * @param container The owner.
		 */
		public static function addChild(displayObject : DisplayObject, container : DisplayObjectContainer) : void {
			addChildAt(displayObject, container, container.numChildren);
		}

		/**
		 * Adds a display object at the given position to the display list.
		 * 
		 * <p>ISkin instances get their drawSkin() method called. Bitmaps get their
		 * bitmap.smoothing property set to true.</p>
		 * 
		 * @param displayObject The display object.
		 * @param container The owner.
		 * @param index The child z-index position.
		 */
		public static function addChildAt(displayObject : DisplayObject, container : DisplayObjectContainer, index : uint) : void {
			container.addChildAt(displayObject, index);

			if (displayObject is IView) {
				// View with its own life cycle
				
			} else if (displayObject is ISkin) {
				// ISkin needs a draw command
				ISkin(displayObject).drawSkin();
				
			} else if (displayObject is Bitmap) {
				Bitmap(displayObject).smoothing = true;
			}

		}

		/**
		 * Colorises a display object using color transform.
		 * 
		 * @param displayObject The display object.
		 * @param color The color.
		 */
		public static function colorise(displayObject : DisplayObject, color : uint) : void {
			var transform : ColorTransform = new ColorTransform();
			transform.color = color;
			displayObject.transform.colorTransform = transform;
		}
		
	}
}

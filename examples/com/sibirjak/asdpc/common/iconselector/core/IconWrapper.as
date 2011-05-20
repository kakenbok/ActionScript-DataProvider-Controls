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
	import com.sibirjak.asdpc.tooltip.ToolTip;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author jes 08.12.2009
	 */
	public class IconWrapper extends Sprite {
		
		public var iconSkin : Class;
		public var iconName : String;
		
		public function IconWrapper(iconSkin : Class, iconName : String, width : uint, height : uint) {
			this.iconSkin = iconSkin;
			this.iconName = iconName;
			
			var icon : DisplayObject = new iconSkin();

			with (graphics) {
				beginFill(0, 0);
				drawRect(0, 0, width, height);
			}
			
			icon.x = Math.round((width - icon.width) / 2);
			icon.y = Math.round((height - icon.height) / 2);

			addChild(icon);
			
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}
		
		private function rollOutHandler(event : MouseEvent) : void {
			ToolTip.getInstance().hide(this);
		}

		private function rollOverHandler(event : MouseEvent) : void {
			ToolTip.getInstance().show(this, iconName);
		}
	
	}
}

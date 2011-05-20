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
package com.sibirjak.asdpc.listview.interfacedemo.windows.styles {
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.common.interfacedemo.ControlPanelBase;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.listview.renderer.ListItemIcon;

	/**
	 * @author jes 14.01.2010
	 */
	public class IconTab extends ControlPanelBase {

		public function IconTab(view : IView) {
			super.view = view;
		}

		override protected function draw() : void {

			addChild(
				document(

					/*
					 * Icon
					 */

					headline("Icon"),
					
					hLayout(
						label("Icon"),
						
						iconSelector({
							iconSkin: IconFactory.getInstance().getIconSkin("document"),
							tip: "Default icon",
							change: setIcon
						})
					),

					hLayout(
						label("Size"),
		
						sliderWithLabel({
							value: 12,
							minValue: 6,
							maxValue: 20,
							snapInterval: 1,
							change: setIconSize
						})
					)

				) // document
			); // addChild
			
		}

		/*
		 * Binding events
		 */

		private function setIcon(iconSkin : Class) : void {
			_view.setStyle(ListItemIcon.style.iconSkin, iconSkin);

			dispatchChange(ListItemIcon.style.iconSkin, iconSkin);
		}

		private function setIconSize(iconSize : uint) : void {
			_view.setStyle(ListItemIcon.style.size, iconSize);
		}

	}
}

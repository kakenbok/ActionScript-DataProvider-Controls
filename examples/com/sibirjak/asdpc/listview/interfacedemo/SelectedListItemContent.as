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
package com.sibirjak.asdpc.listview.interfacedemo {
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.skins.GlassFrame;
	import com.sibirjak.asdpc.listview.core.IListItemRenderer;
	import com.sibirjak.asdpc.listview.renderer.IListItemContent;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;

	/**
	 * @author jes 18.01.2010
	 */
	public class SelectedListItemContent extends View implements IListItemContent {
		
		private var _background : GlassFrame;
		
		public function SelectedListItemContent() {
			
			setDefaultStyles([
				ListItemRenderer.style.background, true,
				ListItemRenderer.style.selectedBackgroundColors, [0xF8F8F8]
			]);
		}
		
		public function drawContent() : void {
		}
		
		public function set listItemRenderer(listItemRenderer : IListItemRenderer) : void {
		}

		override protected function draw() : void {
			if (!getStyle(ListItemRenderer.style.background)) return;
			if (!getStyle(ListItemRenderer.style.selectedBackgroundColors)) return;
			
			var color : uint = getStyle(ListItemRenderer.style.selectedBackgroundColors)[0]; 
			_background = new GlassFrame(color, 1);
			_background.name = "background";
			_background.setSize(_width, _height);
			_background.alpha = .3;
			addChild(_background);
		}

		override protected function update() : void {
			if (_background) removeChild(_background);
			_background = null;
			draw();
		}
	}
}

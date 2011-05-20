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
package com.sibirjak.asdpc.listview.interfacedemo.windows.configuration {
	import com.sibirjak.asdpc.common.interfacedemo.ControlPanelBase;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.listview.ListView;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;
	import com.sibirjak.asdpc.textfield.Label;

	/**
	 * @author jes 16.12.2009
	 */
	public class SizeTab extends ControlPanelBase {

		/* internal */
		private const SELECTED_HEIGHT_LABEL : String = "selectedHeight";

		public function SizeTab(view : IView) {
			super.view = view;
		}
		
		protected function getListName() : String {
			return "List";
		}
		
		override protected function draw() : void {

			addChild(
				document(
				
					headline(getListName()),
					
					hLayout(
						label("Width"),
	
						sliderWithLabel({
							value: 400,
							minValue: 200,
							maxValue: 780,
							snapInterval: 10,
							change: setListWidth
						})

					),
					
					hLayout(
						label("Height"),
		
						sliderWithLabel({
							value: 400,
							minValue: 80,
							maxValue: 580,
							snapInterval: 10,
							change: setListHeight
						})
					),

					vSpacer(),

					dottedSeparator(),

					headline("Item"),
					
					hLayout(
						label("Height"),
		
						sliderWithLabel({
							value: 20,
							minValue: 8,
							maxValue: 40,
							snapInterval: 1,
							change: setItemSize
						})
					),
					
					hLayout(
						label("Selected height"),
		
						sliderWithLabel({
							value: 1,
							minValue: 1,
							maxValue: 12,
							snapInterval: 1,
							change: setSelectedItemSize
						}),
						
						label("x 25", 0, SELECTED_HEIGHT_LABEL)
					),
					
					hLayout(
						label("Indent"),
		
						sliderWithLabel({
							value: 18,
							minValue: 8,
							maxValue: 40,
							snapInterval: 1,
							change: setIndent
						})
					),

					vSpacer(),

					dottedSeparator(),

					headline("Scrollbar"),
					
					hLayout(
						label("Width"),
		
						sliderWithLabel({
							value: 14,
							minValue: 8,
							maxValue: 24,
							snapInterval: 1,
							change: setScrollBarSize
						})
					)

				)
			);

		}

		/*
		 * Binding events
		 */
		
		private function setListWidth(width : uint) : void {
			_view.setSize(width, _view.height);
		}

		private function setListHeight(height : uint) : void {
			_view.setSize(_view.width, height);
		}

		private function setItemSize(height : uint) : void {
			_view.setStyle(ListView.style.itemSize, height);
			
			Label(getView(SELECTED_HEIGHT_LABEL)).text = "x " + height;
		}

		private function setSelectedItemSize(size : uint) : void {
			_view.setStyle(ListView.style.selectedItemSize, size);
		}

		private function setIndent(indent : uint) : void {
			_view.setStyle(ListItemRenderer.style.indent, indent);
		}

		private function setScrollBarSize(size : uint) : void {
			_view.setStyle(ListView.style.scrollBarSize, size);
		}

	}
}

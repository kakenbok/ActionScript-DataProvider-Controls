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
package com.sibirjak.asdpc.treeview.interfacedemo.windows.configuration {
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.configuration.BehaviourTab;
	import com.sibirjak.asdpc.treeview.renderer.DisclosureButton;
	import com.sibirjak.asdpc.treeview.renderer.TreeNodeRenderer;

	/**
	 * @author jes 20.01.2010
	 */
	public class TreeViewBehaviourTab extends BehaviourTab {

		private const EXPAND_GROUP : String = "expandGroup";
		private const EXPAND_ON_DOUBLE_CLICK_BOX : String = "expandOnDoubleClickBox";

		public function TreeViewBehaviourTab(view : IView) {
			super(view);
		}

		override protected function draw() : void {
			super.draw();
			
			getView(DOCUMENT).addChild(
			
				vLayout(
			
					vSpacer(),
					
					dottedSeparator(),
					
					headline("Expand / Collapse"),
					
					vLayout(
						EXPAND_GROUP,

						checkBox({
							selected: true,
							label: "Expand all",
							change: setExpandAll,
							tip: "Enable recursive expanding or collapsing by keeping the mouse pressed over a disclosure button"
						}),
	
						checkBox({
							id: EXPAND_ON_DOUBLE_CLICK_BOX,
							selected: true,
							label: "Expand on double click",
							change: setExpandOnDoubleClick,
							diff: 150,
							tip: "Expand or collapse item on double click"
						})
					)
					
				)
			
			
			);
			
			// necessary
			getView(DOCUMENT).validateNow();
		}

		override protected function viewVisibilityChanged() : void {
			super.viewVisibilityChanged();
			
			getView(EXPAND_GROUP).x = 2;
		}

		/*
		 * Binding events
		 */
				
		private function setExpandAll(expandAll : Boolean) : void {
			_view.setStyle(DisclosureButton.style_expandAll, expandAll);
		}

		private function setExpandOnDoubleClick(expandOnDoubleClick : Boolean) : void {
			_view.setStyle(TreeNodeRenderer.style.expandCollapseOnDoubleClick, expandOnDoubleClick);
		}

	}
}

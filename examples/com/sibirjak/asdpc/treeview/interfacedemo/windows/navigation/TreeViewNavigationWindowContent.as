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
package com.sibirjak.asdpc.treeview.interfacedemo.windows.navigation {
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.navigation.NavigationEvent;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.navigation.NavigationWindowContent;
	import com.sibirjak.asdpc.treeview.TreeNodeEvent;
	import com.sibirjak.asdpc.treeview.TreeView;
	import com.sibirjak.asdpc.treeview.renderer.DirectoryIcon;
	import com.sibirjak.asdpc.treeview.renderer.TreeNodeRenderer;

	/**
	 * @author jes 13.01.2010
	 */
	public class TreeViewNavigationWindowContent extends NavigationWindowContent {
		public function TreeViewNavigationWindowContent(view : IView) {
			super(view);
		}

		override protected function getNavigationClass() : Class {
			return TreeView;
		}

		override protected function getContentRenderer() : Class {
			return TreeNavigationContentRenderer;
		}

		override protected function setNavigationProperties() : void {
			
			_listNavigation.setStyle(TreeNodeRenderer.style.disclosureButton, false);
			
			TreeView(_listNavigation).expandNodeAt(0);
			
			_listNavigation.addEventListener(NavigationEvent.EXPAND, navigationExpandedHandler);
			_listNavigation.addEventListener(NavigationEvent.EXPAND_ALL, navigationExpandedAllHandler);
			_listNavigation.addEventListener(NavigationEvent.COLLAPSE, navigationCollapsedHandler);
			_listNavigation.addEventListener(NavigationEvent.COLLAPSE_ALL, navigationCollapsedAllHandler);

			_listView.addEventListener(TreeNodeEvent.EXPANDED, nodeExpandedHandler);
			_listView.addEventListener(TreeNodeEvent.COLLAPSED, nodeCollapsedHandler);
		}
		
		override protected function viewStyleChanged(property : String, value : *) : void {

			if (
				property == DirectoryIcon.style.branchOpenIconSkin
				|| property == DirectoryIcon.style.branchClosedIconSkin
				|| property == DirectoryIcon.style.leafIconSkin
				|| property == TreeView.style.showRoot
			) {
				_listNavigation.setStyle(property, value);
			}

		}

		override protected function afterDataReset() : void {
			if (_listView.getStyle(TreeView.style.showRoot)) TreeView(_listNavigation).expandNodeAt(0);
		}

		private function navigationExpandedHandler(event : NavigationEvent) : void {
			TreeView(_listView).expandNodeAt(event.listIndex);
			TreeView(_listNavigation).expandNodeAt(event.listIndex);
		}

		private function navigationExpandedAllHandler(event : NavigationEvent) : void {
			TreeView(_listView).expandNodeAt(event.listIndex, true);
			TreeView(_listNavigation).expandNodeAt(event.listIndex, true);
		}

		private function navigationCollapsedHandler(event : NavigationEvent) : void {
			TreeView(_listView).collapseNodeAt(event.listIndex);
			TreeView(_listNavigation).collapseNodeAt(event.listIndex);
		}

		private function navigationCollapsedAllHandler(event : NavigationEvent) : void {
			TreeView(_listView).collapseNodeAt(event.listIndex, true);
			TreeView(_listNavigation).collapseNodeAt(event.listIndex, true);
		}

		private function nodeCollapsedHandler(event : TreeNodeEvent) : void {
			TreeView(_listNavigation).collapseNodeAt(event.listIndex, event.collapseAll);
		}

		private function nodeExpandedHandler(event : TreeNodeEvent) : void {
			TreeView(_listNavigation).expandNodeAt(event.listIndex, event.expandAll);
		}

	}
}

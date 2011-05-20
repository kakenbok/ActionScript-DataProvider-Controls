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
package com.sibirjak.asdpc.treeview {
	import com.sibirjak.asdpc.common.dataprovider.DataSourceCreator;
	import com.sibirjak.asdpc.common.dataprovider.IItem;
	import com.sibirjak.asdpc.common.dataprovider.LinkedSetItem;
	import com.sibirjak.asdpc.common.interfacedemo.windows.events.EventItem;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.listview.ListItemData;
	import com.sibirjak.asdpc.listview.ListViewInterfaceDemo;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.configuration.BehaviourTab;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.configuration.ConfigurationTab;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.configuration.SizeTab;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.data.DataWindowContent;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.events.EventWindowContent;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.navigation.NavigationWindowContent;
	import com.sibirjak.asdpc.treeview.interfacedemo.windows.configuration.TreeViewBehaviourTab;
	import com.sibirjak.asdpc.treeview.interfacedemo.windows.configuration.TreeViewConfigurationTab;
	import com.sibirjak.asdpc.treeview.interfacedemo.windows.configuration.TreeViewSizeTab;
	import com.sibirjak.asdpc.treeview.interfacedemo.windows.data.TreeViewDataWindowContent;
	import com.sibirjak.asdpc.treeview.interfacedemo.windows.events.TreeViewEventWindowContent;
	import com.sibirjak.asdpc.treeview.interfacedemo.windows.navigation.TreeViewNavigationWindowContent;
	import com.sibirjak.asdpc.treeview.interfacedemo.windows.styles.TreeViewIconTab;

	/**
	 * @author jes 12.01.2010
	 */
	public class TreeViewInterfaceDemo extends ListViewInterfaceDemo {
		
		/*
		 * Static
		 */

		public static function createDataSource(depth : uint = 5, maxNumChildren : uint = 5) : IItem {
//			return DataSourceCreator.createTree(LinkedMapItem, depth, maxNumChildren);
			return DataSourceCreator.createTree(LinkedSetItem, depth, maxNumChildren);
//			return DataSourceCreator.createTree(SortedMapItem, depth, maxNumChildren);
//			return DataSourceCreator.createMixedTree(depth, maxNumChildren);
//			return DataSourceCreator.createTree(ArrayListItem, depth, maxNumChildren);
		}
			
		public function TreeViewInterfaceDemo() {
			
			_listView.addEventListener(TreeViewEvent.EXPANDED, expandHandler);
			_listView.addEventListener(TreeViewEvent.COLLAPSED, collapseHandler);

			_listView.addEventListener(TreeNodeEvent.EXPANDED, itemExpandHandler);
			_listView.addEventListener(TreeNodeEvent.COLLAPSED, itemCollapseHandler);
		}
		
		/*
		 * Protected
		 */

		override protected function getListViewClass() : Class {
			return TreeView;
		}
		
		override protected function setListViewProperties() : void {
			_listView.name = "treeViewDemo";
 			TreeView(_listView).expandNodeAt(0);
		}

		override protected function getDataSource() : IItem {
 			return createDataSource();
		}

		override protected function getSizeTab() : SizeTab {
			return new TreeViewSizeTab(_listView);
		}

		override protected function getConfigurationTab() : ConfigurationTab {
			return new TreeViewConfigurationTab(_listView);
		}

		override protected function getBehaviourTab() : BehaviourTab {
			return new TreeViewBehaviourTab(_listView);
		}

		override protected function getDataContent() : DataWindowContent {
			return new TreeViewDataWindowContent(_listView);
		}

		override protected function getNavigationContent() : NavigationWindowContent {
			return new TreeViewNavigationWindowContent(_listView);
		}

		override protected function getEventWindowContent() : EventWindowContent {
			return new TreeViewEventWindowContent();
		}

		override protected function getIconTab() : View {
			return new TreeViewIconTab(_listView);
		}
		
		override protected function getIconTabName() : String {
			return "Elements";
		}

		/*
		 * Tree events
		 */

		private function expandHandler(event : TreeViewEvent) : void {
			var listItemData : ListItemData = _listView.getListItemDataAt(event.listIndex);

			addEvent(EventItem.TYPE_LIST_VIEW, "EXPANDED "
				+ (event.expandAll ? "(all) " : "")
				+ "at " + event.listIndex + ": " + IItem(listItemData.item).name
			);
		}

		private function collapseHandler(event : TreeViewEvent) : void {
			var listItemData : ListItemData = _listView.getListItemDataAt(event.listIndex);

			addEvent(EventItem.TYPE_LIST_VIEW, "COLLAPSED "
				+ (event.collapseAll ? "(all) " : "")
				+ "at " + event.listIndex + ": " + IItem(listItemData.item).name
			);
		}

		private function itemExpandHandler(event : TreeNodeEvent) : void {
			addEvent(EventItem.TYPE_LIST_ITEM, "EXPANDED "
				+ (event.expandAll ? "(all) " : "")
				+ "at " + event.listIndex + ": " + IItem(event.item).name
			);
		}

		private function itemCollapseHandler(event : TreeNodeEvent) : void {
			addEvent(EventItem.TYPE_LIST_ITEM, "COLLAPSED "
				+ (event.collapseAll ? "(all) " : "")
				+ "at " + event.listIndex + ": " + IItem(event.item).name
			);
		}

	}
}

package com.sibirjak.asdpc.treeview {
	import com.sibirjak.asdpc.common.Example;

	public class TreeViewExample extends Example {
		public function TreeViewExample() {
			var treeView : TreeView = new TreeView();

			treeView.dataSource = new XML(
				<item name="Root">
					<item name="Node_1">
						<item name="Node_1_1" />
						<item name="Node_1_2" />
					</item>
					<item name="Node_2" />
				</item>
			);

			addChild(treeView);
		}
	}
}
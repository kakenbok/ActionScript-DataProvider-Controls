package com.sibirjak.asdpc.treeview {
	import com.sibirjak.asdpc.common.Example;

	public class PublicInterfaceExample extends Example {
		public function PublicInterfaceExample() {

			// Fully expanded
			
			var treeView : TreeView = new TreeView();
			treeView.setSize(200, 200);
			treeView.dataSource = getDataSource();
			treeView.expandNodeAt(0, true);
			addChild(treeView);

			// Expanded and selected
			
			treeView = new TreeView();
			treeView.setSize(200, 80);
			treeView.dataSource = getDataSource();
			treeView.expandNodeAt(0);
			treeView.selectItemAt(1);
			treeView.moveTo(210, 0);
			addChild(treeView);

			// Fully expanded and scrolled
			
			treeView = new TreeView();
			treeView.setSize(200, 100);
			treeView.dataSource = getDataSource();
			treeView.expandNodeAt(0, true);
			treeView.scrollToItemAt(2);
			treeView.moveTo(210, 100);
			addChild(treeView);
		}
		
		private function getDataSource() : * {
			return new XML(
				<item name="Root">
					<item name="Node_1">
						<item name="Node_1_1" />
						<item name="Node_1_2">
							<item name="Node_1_2_1" />
							<item name="Node_1_2_2" />
						</item>
						<item name="Node_1_3" />
					</item>
					<item name="Node_2">
						<item name="Node_2_1" />
						<item name="Node_2_2" />
					</item>
				</item>
			);
		}
	}
}
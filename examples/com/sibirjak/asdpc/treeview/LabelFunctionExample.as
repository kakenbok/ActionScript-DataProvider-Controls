package com.sibirjak.asdpc.treeview {
	import com.sibirjak.asdpc.common.Example;
	import com.sibirjak.asdpc.listview.renderer.ListItemContent;

	public class LabelFunctionExample extends Example {
		public function LabelFunctionExample() {

			var dataSource : Node = new Node("Root");

			var node_1 : Node = new Node("Node_1");
			node_1.addNode(new Node("Node_1_1"));
			node_1.addNode(new Node("Node_1_2"));
			dataSource.addNode(node_1);

			dataSource.addNode(new Node("Node_2"));
			
			var treeView : TreeView = new TreeView();
			treeView.dataSource = dataSource;
			treeView.setStyle(
				ListItemContent.style.labelFunction, labelFunction
			);
			addChild(treeView);
		}
		
		private function labelFunction(data : TreeNodeData) : String {
			return Node(data.item).key;
		}
	}
}

import org.as3commons.collections.framework.IDataProvider;

internal class Node implements IDataProvider{
	public var key : String;
	public var childNodes : Array = new Array();

	public function Node(theKey : String) {
		key = theKey;
	}
	
	public function addNode(node : Node) : void {
		childNodes.push(node);
	}

	public function itemAt(index : uint) : *{
		return childNodes[index];
	}

	public function get size() : uint{
		return childNodes.length;
	}
}
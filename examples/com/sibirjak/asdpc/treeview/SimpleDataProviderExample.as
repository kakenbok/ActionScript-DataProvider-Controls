package com.sibirjak.asdpc.treeview {
	import com.sibirjak.asdpc.common.Example;

	public class SimpleDataProviderExample extends Example {
		public function SimpleDataProviderExample() {
			var dataSource : Node = new Node("Root");

			var node_1 : Node = new Node("Node_1");
			node_1.addNode(new Node("Node_1_1"));
			node_1.addNode(new Node("Node_1_2"));
			dataSource.addNode(node_1);

			dataSource.addNode(new Node("Node_2"));
			
			var treeView : TreeView = new TreeView();
			treeView.dataSource = dataSource;
			addChild(treeView);
		}
	}
}

import org.as3commons.collections.framework.IDataProvider;

internal class Node implements IDataProvider {
	private var _name : String;
	private var _childNodes : Array = new Array();

	public function Node(name : String) {
		_name = name;
	}
	
	public function addNode(node : Node) : void {
		_childNodes.push(node);
	}
	
	public function itemAt(index : uint) : * {
		return _childNodes[index];
	}
	
	public function get size() : uint {
		return _childNodes.length;
	}
	
	public function get name() : String {
		return _name;
	}
}
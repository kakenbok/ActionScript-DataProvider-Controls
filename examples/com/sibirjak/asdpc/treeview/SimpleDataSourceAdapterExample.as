package com.sibirjak.asdpc.treeview {
	import com.sibirjak.asdpc.common.Example;

	import org.as3commons.collections.framework.IDataProvider;

	public class SimpleDataSourceAdapterExample extends Example {
		public function SimpleDataSourceAdapterExample() {
			var dataSource : Node = new Node("Root");

			var node_1 : Node = new Node("Node_1");
			node_1.addNode(new Node("Node_1_1"));
			node_1.addNode(new Node("Node_1_2"));
			dataSource.addNode(node_1);

			dataSource.addNode(new Node("Node_2"));
			
			var treeView : TreeView = new TreeView();
			treeView.dataSource = dataSource;
			treeView.dataSourceAdapterFunction = getAdapter;
			addChild(treeView);
		}
		
		private function getAdapter(item : *) : IDataProvider {
			if (item is Node) return new NodeAdapter(item);
			return null;
		}
	}
}

import com.sibirjak.asdpc.core.dataprovider.IDataSourceAdapter;

internal class NodeAdapter implements IDataSourceAdapter {
	private var _node : Node;

	public function NodeAdapter(node : Node) {
		_node = node;
	}

	public function get dataSource() : * {
		return _node;
	}

	public function itemAt(index : uint) : * {
		return _node.childNodes[index];
	}

	public function get size() : uint {
		return _node.childNodes.length;
	}

	public function cleanUp() : void {
		// empty
	}
}

internal class Node {
	private var _name : String;
	private var _childNodes : Array = new Array();

	public function Node(name : String) {
		_name = name;
	}
	
	public function addNode(node : Node) : void {
		_childNodes.push(node);
	}
	
	public function get name() : String {
		return _name;
	}
	
	public function get childNodes() : Array {
		return _childNodes;
	}
}
package com.sibirjak.asdpc.treeview {
	import com.sibirjak.asdpc.common.Example;

	import org.as3commons.collections.framework.IDataProvider;

	import flash.display.DisplayObjectContainer;

	public class DisplayListExample extends Example {
		public function DisplayListExample() {
			var treeView : TreeView = new TreeView();
			treeView.setSize(440, 360);
			treeView.dataSource = stage;
			treeView.dataSourceAdapterFunction = getAdapter;
			treeView.expandNodeAt(0);
			addChild(treeView);
		}
		
		private function getAdapter(item : *) : IDataProvider {
			 if (item is DisplayObjectContainer) {
			 	return new DOCAdapter(item);
			 }
			 return null;
		}
	}
}

import com.sibirjak.asdpc.core.dataprovider.IDataSourceAdapter;

import flash.display.DisplayObjectContainer;

internal class DOCAdapter implements IDataSourceAdapter {
	private var _view : DisplayObjectContainer;

	public function DOCAdapter(view : DisplayObjectContainer) {
		_view = view;
	}

	public function get dataSource() : * {
		return _view;
	}

	public function itemAt(index : uint) : * {
		return _view.getChildAt(index);
	}

	public function get size() : uint {
		return _view.numChildren;
	}

	public function cleanUp() : void {
		// empty
	}
}
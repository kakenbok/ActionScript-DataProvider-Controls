package com.sibirjak.asdpc.treeview {
	import com.sibirjak.asdpc.common.Example;
	import com.sibirjak.asdpc.treeview.renderer.TreeNodeRenderer;

	public class CustomContentRendererExample extends Example {
		public function CustomContentRendererExample() {
			var treeView : TreeView = new TreeView();
			treeView.setSize(160, 360);
			
			treeView.setStyle(TreeNodeRenderer.style.contentRenderer, MyContent);
			treeView.setStyle(TreeView.style.itemSize, 36);
			
			treeView.dataSource = new XML(
				<item name="Root with very long text">
					<item name="Node_1 with very long text">
						<item name="Node_1_1 with very long text" />
						<item name="Node_1_2 with very long text" />
					</item>
					<item name="Node_2 with very long text" />
				</item>
			);
			treeView.expandNodeAt(0);
			addChild(treeView);
		}
	}
}

import com.sibirjak.asdpc.core.View;
import com.sibirjak.asdpc.core.dataprovider.genericToStringFunction;
import com.sibirjak.asdpc.listview.core.IListItemRenderer;
import com.sibirjak.asdpc.listview.core.ListItemRendererEvent;
import com.sibirjak.asdpc.listview.renderer.IListItemContent;
import flash.text.TextField;

internal class MyContent extends View implements IListItemContent {
	private var _tf : TextField;
	private var _listItemRenderer : IListItemRenderer;

	public function drawContent() : void {
		// leave this method empty since View life cycle is used
	}

	override protected function draw() : void {
		_tf = new TextField();
		_tf.width = _width;
		_tf.height = _height;
		_tf.wordWrap = true;
		_tf.text = genericToStringFunction(_listItemRenderer.data.item);
		addChild(_tf);
	}

	override protected function update() : void {
		if (isInvalid(UPDATE_PROPERTY_SIZE)) {
			_tf.width = _width;
			_tf.height = _height;
		}
	}

	public function set listItemRenderer(renderer : IListItemRenderer) : void {
		_listItemRenderer = renderer;
		// notify if the content should display new data
		_listItemRenderer.addEventListener(
			ListItemRendererEvent.DATA_CHANGED, dataChanged
		);
	}
	
	private function dataChanged(event : ListItemRendererEvent) : void {
		_tf.text = genericToStringFunction(_listItemRenderer.data.item);
	}
}
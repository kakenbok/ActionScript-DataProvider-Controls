package com.sibirjak.asdpc.treeview {
	import com.sibirjak.asdpc.common.Example;
	import com.sibirjak.asdpc.core.constants.Visibility;
	import com.sibirjak.asdpc.scrollbar.ScrollBar;
	import com.sibirjak.asdpc.treeview.renderer.ConnectorContainer;
	import com.sibirjak.asdpc.treeview.renderer.DisclosureButton;
	import com.sibirjak.asdpc.treeview.renderer.TreeNodeRenderer;
	import com.sibirjak.asdpc.treeview.renderer.skins.DisclosureButtonBoxIconSkin;

	/**
	 * @author jes 04.02.2010
	 */
	public class StylingExample extends Example {
		public function StylingExample() {
			var treeView : TreeView = new TreeView();
			treeView.setSize(260, 125);
			treeView.expandNodeAt(0);

			treeView.dataSource = new XML(
				<item name="Root">
					<item name="Node_1">
						<item name="Node_1_1" />
						<item name="Node_1_2" />
						<item name="Node_1_3" />
					</item>
					<item name="Node_2" />
				</item>
			);
			
			treeView.setStyles([
				// item size
				TreeView.style.itemSize, 25,

				// scrollbar and button visibility
				TreeView.style.scrollBarVisibility, Visibility.VISIBLE,
				ScrollBar.style.scrollButtonVisibility, Visibility.VISIBLE,

				// box shaped disclosure button
				DisclosureButton.style_expandedIconSkin, DisclosureButtonBoxIconSkin,
				DisclosureButton.style_collapsedIconSkin, DisclosureButtonBoxIconSkin,
				DisclosureButton.style_size, 9,
				DisclosureButtonBoxIconSkin.style_fillColor, 0x000000,
				DisclosureButtonBoxIconSkin.style_iconColor, 0xFFFFFF,

				// connectors below button and icon
				ConnectorContainer.style_connectorAtButton, true,
				ConnectorContainer.style_connectorAtIcon, true,

				// list item indent
				TreeNodeRenderer.style.indent, 26,

				// list item colors
				TreeNodeRenderer.style.separator, true,
				TreeNodeRenderer.style.separatorColor, 0xDDDDDD,
				TreeNodeRenderer.style.evenIndexBackgroundColors, [0xFFFFFF, 0xEEEEEE],
				TreeNodeRenderer.style.oddIndexBackgroundColors, [0xFFFFFF, 0xEEEEEE],
				TreeNodeRenderer.style.overBackgroundColors, [0xDDDDDD, 0xBBBBBB],
				TreeNodeRenderer.style.selectedBackgroundColors, [0x666666, 0x999999],
			]); 

			addChild(treeView);
		}
	}
}
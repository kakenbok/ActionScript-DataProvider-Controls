package com.sibirjak.asdpc.common.interfacedemo.windows.info {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.button.IButton;
	import com.sibirjak.asdpc.button.skins.ButtonSkin;
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.common.interfacedemo.ControlPanelBase;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.listview.ListItemData;
	import com.sibirjak.asdpc.listview.ListView;
	import com.sibirjak.asdpc.listview.renderer.ListItemContent;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpc.treeview.ITreeView;
	import com.sibirjak.asdpc.treeview.TreeView;
	import com.sibirjak.asdpc.treeview.renderer.ConnectorContainer;
	import com.sibirjak.asdpc.treeview.renderer.DirectoryIcon;
	import com.sibirjak.asdpc.treeview.renderer.DisclosureButton;
	import com.sibirjak.asdpc.treeview.renderer.skins.DisclosureButtonBoxIconSkin;

	import org.as3commons.collections.framework.IDataProvider;

	import flash.display.DisplayObject;

	/**
	 * @author jes 29.01.2010
	 */
	public class InfoTabBase extends ControlPanelBase {

		private var _tree : ITreeView;
		private var _refreshButton : IButton;
		private var _buttonSize : uint = 13;

		public function InfoTabBase(view : IView) {
			super.view = view;
		}

		override protected function draw() : void {

			// separator

			var separator : View = dottedSeparator();
			separator.moveTo(0, 2);
			addChild(separator);

			// list
			
			_tree = new TreeView();
			_tree.setSize(_width, _height - _buttonSize - 18);

			_tree.setStyles([
				ButtonSkin.style_borderAlias, false,
				Label.style.size, 9,

				ListView.style.itemSize, 20,
				ListView.style.scrollBarSize, 10,

				ListItemRenderer.style.overBackgroundColors, null,
				ListItemRenderer.style.indent, 18,

				ListItemContent.style.overLabelStyles, null,
				ListItemContent.style.labelFunction, labelFunction,

				ConnectorContainer.style_connectorAtButton, true,
				ConnectorContainer.style_connectorAtIcon, true,
				 
				DisclosureButton.style_expandedIconSkin, DisclosureButtonBoxIconSkin, 
				DisclosureButton.style_collapsedIconSkin, DisclosureButtonBoxIconSkin,
				DisclosureButton.style_size, 9,

				DirectoryIcon.style.size, 12,

				DirectoryIcon.style.iconSkinFunction, iconSkinFunction
			]);
			
			_tree.dataSource = _view;
			_tree.dataSourceAdapterFunction = dataSourceAdapterFunction;

			_tree.moveTo(0, 8);
			_tree.expandNodeAt(0);
			addChild(DisplayObject(_tree));
			
			// separator

			separator = dottedSeparator();
			separator.moveTo(0, _tree.y + _tree.height + 4);
			addChild(separator);

			// refresh button

 			_refreshButton = new Button();
			_refreshButton.setSize(_buttonSize, _buttonSize);
			_refreshButton.setStyles([
				Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("reset"),
				Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME
			]);
			
			_refreshButton.toolTip = "Refresh info";

			_refreshButton.moveTo(_width - (_buttonSize + 4), _height - _buttonSize - 2);
			_refreshButton.addEventListener(ButtonEvent.CLICK, refreshButtonClickHandler);
			addChild(DisplayObject(_refreshButton));
		}
		
		protected function labelFunction(data : ListItemData) : String {
			return null;
		}

		protected function iconSkinFunction(data : ListItemData) : Class {
			return null;
		}
		
		protected function dataSourceAdapterFunction(dataSource : *) : IDataProvider {
			return null;
		}

		private function refreshButtonClickHandler(event : ButtonEvent) : void {
			_tree.dataSource = _view;
			_tree.expandNodeAt(0);
		}
		
	}
}

package com.sibirjak.asdpc.common.interfacedemo.windows.info {
	import com.sibirjak.asdpc.core.Container;
	import com.sibirjak.asdpc.core.IControl;
	import com.sibirjak.asdpc.core.ISkin;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.core.managers.IStyleManagerClient;
	import com.sibirjak.asdpc.listview.ListItemData;

	import org.as3commons.collections.framework.IDataProvider;

	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author jes 29.01.2010
	 */
	public class StyleInfoTab extends InfoTabBase {
		
		[Embed(source="assets/style.png")]
		private var _style : Class;
		[Embed(source="assets/skin.png")]
		private var _skin : Class;
		[Embed(source="assets/package.png")]
		private var _component : Class;
		[Embed(source="assets/view.png")]
		private var _viewIcon : Class;

		public function StyleInfoTab(view : IView) {
			super(view);
		}

		override protected function labelFunction(data : ListItemData) : String {
			if (data.item is StyleContainer) return StyleContainer(data.item).name;
			if (data.item is Style) {
				return Style(data.item).name.replace(/^.*?_/, "");
			}
			if (data.item is String) return data.item;
			
			var prefix : String = (DisplayObject(data.item).name.indexOf("instance") != 0) ? " " + DisplayObject(data.item).name : "";
			return "[" + getQualifiedClassName(data.item).replace(/^.*.::/, "") + "] " + prefix;
		}

		override protected function iconSkinFunction(data : ListItemData) : Class {
			if (data.item is ISkin) return _skin;
			if (data.item is IControl) return _component;
			if (data.item is Container) return _viewIcon;
			if (data.item is Style) return _style;
			if (data.item is StyleContainer) return _style;
			return null;
		}

		override protected function dataSourceAdapterFunction(dataSource : *) : IDataProvider {
			if (dataSource is IStyleManagerClient) {
				return new StyleClientAdapter(dataSource);
			}
			return null;
		}

	}
}

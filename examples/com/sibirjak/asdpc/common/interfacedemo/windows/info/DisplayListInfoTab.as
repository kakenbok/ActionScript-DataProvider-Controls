package com.sibirjak.asdpc.common.interfacedemo.windows.info {
	import com.sibirjak.asdpc.core.Container;
	import com.sibirjak.asdpc.core.IControl;
	import com.sibirjak.asdpc.core.ISkin;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.listview.ListItemData;

	import org.as3commons.collections.framework.IDataProvider;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author jes 29.01.2010
	 */
	public class DisplayListInfoTab extends InfoTabBase {
		
		[Embed(source="assets/icon_flash.png")]
		private var _flash : Class;
		[Embed(source="assets/skin.png")]
		private var _skin : Class;
		[Embed(source="assets/package.png")]
		private var _component : Class;
		[Embed(source="assets/view.png")]
		private var _viewIcon : Class;

		public function DisplayListInfoTab(view : IView) {
			super(view);
		}

		override protected function labelFunction(data : ListItemData) : String {
			if (data.item is Bitmap) return "[Bitmap] " + DisplayObject(data.item).name;
			var prefix : String = (DisplayObject(data.item).name.indexOf("instance") != 0) ? " " + DisplayObject(data.item).name : "";
			return "[" + getQualifiedClassName(data.item).replace(/^.*.::/, "") + "]" + prefix;
		}

		override protected function iconSkinFunction(data : ListItemData) : Class {
			if (data.item is ISkin) return _skin;
			if (data.item is IControl) return _component;
			if (data.item is Container) return _viewIcon;
			return _flash;
		}

		override protected function dataSourceAdapterFunction(dataSource : *) : IDataProvider {
			if (dataSource is DisplayObjectContainer) {
				return new DisplayObjectContainerAdapter(dataSource);
			}
			return null;
		}

	}
}

/**
 * ActionScript Data Provider Controls
 * 
 * Copyright (c) 2010 Jens Struwe, http://www.sibirjak.com/
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.sibirjak.asdpc.listview.renderer {
	import com.sibirjak.asdpc.core.DisplayObjectAdapter;
	import com.sibirjak.asdpc.core.IDataRendererSkin;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.listview.core.IListItemRenderer;
	import com.sibirjak.asdpc.listview.core.ListItemRendererData;
	import com.sibirjak.asdpc.listview.core.ListItemRendererEvent;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	/*
	 * Styles
	 */
	
	/**
	 * @copy ListItemIconStyles#size
	 */
	[Style(name="listItemIcon_size", type="uint", format="Size")]

	/**
	 * @copy ListItemIconStyles#iconSkin
	 */
	[Style(name="listItemIcon_iconSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ListItemIconStyles#iconSkinFunction
	 */
	[Style(name="listItemIcon_iconSkinFunction", type="Function", format="Class")]

	/**
	 * List item icon.
	 * 
	 * @author jes 12.01.2010
	 */
	public class ListItemIcon extends View {

		/* style declarations */

		/**
		 * Central accessor to all ListItemIcon style property definitions.
		 */
		public static var style : ListItemIconStyles = new ListItemIconStyles();

		/* data invalidation properties */

		/**
		 * Name constant for the data invalidation property.
		 */
		protected const UPDATE_PROPERTY_DATA : String = "data";

		/**
		 * Name constant for the icon invalidation property.
		 */
		protected const UPDATE_PROPERTY_ICON : String = "icon";

		/**
		 * Name constant for the icon size invalidation property.
		 */
		protected const UPDATE_PROPERTY_ICON_SIZE : String = "icon_size";

		/* properties */

		/**
		 * The IListItemRenderer instance, that owns the content renderer.
		 */
		protected var _listItemRenderer : IListItemRenderer;

		/* internals */
		
		/**
		 * Icon skin class to icon map.
		 */
		protected var _icons : Dictionary;

		/* styles */

		/**
		 * Icon skin function.
		 */
		protected var _iconSkinFunction : Function;		

		/**
		 * Icon skin.
		 */
		protected var _iconSkin : Class;		

		/**
		 * Icon size.
		 */
		protected var _iconSize : uint;		

		/* children */

		/**
		 * Currently visible icon.
		 */
		protected var _icon : DisplayObject;

		/* assets */

		/**
		 * Default icon skin.
		 */
		[Embed(source="assets/document.png")]
		private var _bullet : Class;

		/**
		 * ListItemIcon constructor.
		 */
		public function ListItemIcon() {
			
			setDefaultStyles([
				style.size, 14,
				style.iconSkin, _bullet,
				style.iconSkinFunction, null
			]);

			_icons = new Dictionary();
		}

		/**
		 * @inheritDoc
		 */
		public function set listItemRenderer(listItemRenderer : IListItemRenderer) : void {
			_listItemRenderer = listItemRenderer;

			_listItemRenderer.addEventListener(ListItemRendererEvent.DATA_CHANGED, dataChangedHandler);
			_listItemRenderer.addEventListener(ListItemRendererEvent.DATA_PROPERTY_CHANGED, dataPropertyChangedHandler);
		}
		
		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		override protected function init() : void {
			_iconSkin = getStyle(style.iconSkin);
			_iconSkinFunction = getStyle(style.iconSkinFunction);
			_iconSize = getStyle(style.size);
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			showIconSkin();
		}

		/**
		 * @inheritDoc
		 */
		override protected function update() : void {

			var positionIcon : Boolean = false;
			var resizeIcons : Boolean = false;
			var setIcon : Boolean = false;

			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				positionIcon = true;
			}

			if (isInvalid(UPDATE_PROPERTY_ICON_SIZE)) {
				positionIcon = true;
				resizeIcons = true;
			}

			if (isInvalid(UPDATE_PROPERTY_ICON)) {
				for each (var icon : DisplayObject in _icons) removeChild(icon);
				_icons = new Dictionary();

				setIcon = true;
			}

			if (resizeIcons) {
				resizeAllIcons();
			}

			if (positionIcon) {
				positionAllIcons();
			}
			
			if (setIcon) {
				showIconSkin();
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function styleChanged(property : String, value : *) : void {
			if (property == style.iconSkinFunction) {
				_iconSkinFunction = value;
				invalidateProperty(UPDATE_PROPERTY_ICON);

			} else if (property == style.iconSkin) {
				_iconSkin = value;
				invalidateProperty(UPDATE_PROPERTY_ICON);

			} else if (property == style.size) {
				_iconSize = value;
				invalidateProperty(UPDATE_PROPERTY_ICON_SIZE);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function cleanUpCalled() : void {
			_listItemRenderer.removeEventListener(ListItemRendererEvent.DATA_CHANGED, dataChangedHandler);
			_listItemRenderer.removeEventListener(ListItemRendererEvent.DATA_PROPERTY_CHANGED, dataPropertyChangedHandler);
		}
		
		/*
		 * Protected
		 */

		/**
		 * Shortcut to the list item renderers data property.
		 * 
		 * @return The list item renderers data.
		 */
		protected function get data() : ListItemRendererData {
			return _listItemRenderer.data;
		}
		
		/**
		 * Returns the icon skin that is to apply.
		 * 
		 * @return The icon skin to apply.
		 */
		protected function getIconSkin() : Class {
			var iconSkin : Class;

			if (_iconSkinFunction != null) {
				iconSkin = _iconSkinFunction(data.listItemData);
			}
			
			if (iconSkin == null) {
				iconSkin = _iconSkin;
			}
			
			return iconSkin;
		}

		/**
		 * Adds and shows the icon of the current icon skin.
		 */
		protected function showIconSkin() : void {
			var iconAdded : Boolean = false;
			var iconClass : Class = getIconSkin();
			var icon : DisplayObject = _icons[iconClass];

			if (!icon && iconClass != null) {
				icon = addNewIcon(iconClass, this);
				_icons[iconClass] = icon;
				iconAdded = true;
			}
			
			if (_icon) _icon.visible = false;

			if (icon) {

				// set data to an existing icon
				// data for a new icon has been set in addNewIcon()
				if (!iconAdded && icon is IDataRendererSkin) {
					IDataRendererSkin(icon).data = data;
				}

				_icon = icon;
				_icon.visible = true;
			}
			
			/* nested function */
			
			function addNewIcon(iconClass : Class, container : DisplayObjectContainer) : DisplayObject {
				var icon : DisplayObject = new iconClass();
				
				if (icon is IDataRendererSkin) {
					IDataRendererSkin(icon).data = data;
				}
				
				DisplayObjectAdapter.setSize(icon, _iconSize, _iconSize);
				setIconPosition(icon);
				DisplayObjectAdapter.addChild(icon, container);
				
				return icon;
			}
		}
		
		/*
		 * Private
		 */

		/**
		 * Resizes all created icons both visible and hidden.
		 */
		private function resizeAllIcons() : void {
			for each (var icon : DisplayObject in _icons) {
				DisplayObjectAdapter.setSize(icon, _iconSize, _iconSize);
				DisplayObjectAdapter.validateNow(icon); // be consistent with a possible reposition
			}
		}
		
		/**
		 * Positions all created icons both visible and hidden.
		 */
		private function positionAllIcons() : void {
			for each (var icon : DisplayObject in _icons) {
				setIconPosition(icon);
			}
		}

		/**
		 * Positions the given icon.
		 */
		private function setIconPosition(icon : DisplayObject) : void {
			DisplayObjectAdapter.moveTo(
				icon,
				Math.round((_width - _iconSize) / 2),
				Math.round((_height - _iconSize) / 2)
			);
		}

		/*
		 * Events
		 */
		
		/**
		 * Data changed handler
		 */
		private function dataChangedHandler(event : ListItemRendererEvent) : void {
			showIconSkin();
		}

		/**
		 * Data property changed handler
		 */
		private function dataPropertyChangedHandler(event : ListItemRendererEvent) : void {
			showIconSkin();
		}

	}
}

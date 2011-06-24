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
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.listview.core.IListItemRenderer;
	import com.sibirjak.asdpc.listview.core.ListItemRendererData;
	import com.sibirjak.asdpc.listview.core.ListItemRendererEvent;
	import com.sibirjak.asdpc.listview.renderer.skins.ListItemBackgroundSkin;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	/*
	 * Styles
	 */
	
	/**
	 * @copy ListItemRendererStyles#contentRenderer
	 */
	[Style(name="listItemRenderer_contentRenderer", type="Class", format="com.sibirjak.asdpc.listview.core.IListItemRenderer")]

	/**
	 * @copy ListItemRendererStyles#selectedItemContentRenderer
	 */
	[Style(name="listItemRenderer_selectedItemContentRenderer", type="Class", format="com.sibirjak.asdpc.listview.core.IListItemRenderer")]

	/**
	 * @copy ListItemRendererStyles#indent
	 */
	[Style(name="listItemRenderer_indent", type="uint", format="Size")]

	/**
	 * @copy ListItemRendererStyles#icon
	 */
	[Style(name="listItemRenderer_icon", type="Boolean")]

	/**
	 * @copy ListItemRendererStyles#iconPadding
	 */
	[Style(name="listItemRenderer_iconPadding", type="uint", format="Size")]

	/**
	 * @copy ListItemRendererStyles#background
	 */
	[Style(name="listItemRenderer_background", type="Boolean")]

	/**
	 * @copy ListItemRendererStyles#backgroundType
	 */
	[Style(name="listItemRenderer_backgroundType", type="String", enumeration="list_item, content")]

	/**
	 * @copy ListItemRendererStyles#evenIndexBackgroundColors
	 */
	[Style(name="listItemRenderer_evenIndexBackgroundColors", type="Array", arrayType="uint", format="Color")]

	/**
	 * @copy ListItemRendererStyles#oddIndexBackgroundColors
	 */
	[Style(name="listItemRenderer_oddIndexBackgroundColors", type="Array", arrayType="uint", format="Color")]

	/**
	 * @copy ListItemRendererStyles#overBackgroundColors
	 */
	[Style(name="listItemRenderer_overBackgroundColors", type="Array", arrayType="uint", format="Color")]

	/**
	 * @copy ListItemRendererStyles#selectedBackgroundColors
	 */
	[Style(name="listItemRenderer_selectedBackgroundColors", type="Array", arrayType="uint", format="Color")]

	/**
	 * @copy ListItemRendererStyles#separator
	 */
	[Style(name="listItemRenderer_separator", type="Boolean")]

	/**
	 * @copy ListItemRendererStyles#separatorColor
	 */
	[Style(name="listItemRenderer_separatorColor", type="uint", format="Color")]

	/**
	 * @copy ListItemRendererStyles#clickSelection
	 */
	[Style(name="listItemRenderer_clickSelection", type="Boolean")]

	/**
	 * @copy ListItemRendererStyles#ctrlKeyDeselection
	 */
	[Style(name="listItemRenderer_ctrlKeyDeselection", type="Boolean")]

	/*
	 * ListItemRendererEvent
	 */

	/**
	 * @eventType com.sibirjak.asdpc.listview.core.ListItemRendererEvent.ROLL_OVER
	 */
	[Event(name="listItemRenderer_rollOver", type="com.sibirjak.asdpc.listview.core.ListItemRendererEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.core.ListItemRendererEvent.ROLL_OUT
	 */
	[Event(name="listItemRenderer_rollOut", type="com.sibirjak.asdpc.listview.core.ListItemRendererEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.core.ListItemRendererEvent.SELECTION_CHANGED
	 */
	[Event(name="listItemRenderer_selectionChanged", type="com.sibirjak.asdpc.listview.core.ListItemRendererEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.core.ListItemRendererEvent.DATA_CHANGED
	 */
	[Event(name="listItemRenderer_dataChanged", type="com.sibirjak.asdpc.listview.core.ListItemRendererEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.core.ListItemRendererEvent.DATA_PROPERTY_CHANGED
	 */
	[Event(name="listItemRenderer_dataPropertyChanged", type="com.sibirjak.asdpc.listview.core.ListItemRendererEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.core.ListItemRendererEvent.LIST_INDEX_CHANGED
	 */
	[Event(name="listItemRenderer_listIndexChanged", type="com.sibirjak.asdpc.listview.core.ListItemRendererEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.core.ListItemRendererEvent.VISIBILITY_CHANGED
	 */
	[Event(name="listItemRenderer_visibilityChanged", type="com.sibirjak.asdpc.listview.core.ListItemRendererEvent")]

	/**
	 * Default list item renderer.
	 * 
	 * @author jes 10.11.2009
	 */
	public class ListItemRenderer extends View implements IListItemRenderer {
		
		/* style declarations */

		/**
		 * Central accessor to all ListItemRenderer style property definitions.
		 */
		public static var style : ListItemRendererStyles = new ListItemRendererStyles();

		/* constants */

		/**
		 * Name constant for a background behind the entire item.
		 */
		public static const BACKGROUND_LIST_ITEM : String = "list_item";

		/**
		 * Name constant for a background only behind the list item content.
		 */
		public static const BACKGROUND_CONTENT : String = "content";

		/* data invalidation properties */

		/**
		 * Name constant for the data invalidation property.
		 */
		protected const UPDATE_PROPERTY_DATA : String = "data";

		/**
		 * Name constant for the background invalidation property.
		 */
		protected const UPDATE_PROPERTY_BACKGROUND : String = "background";

		/**
		 * Name constant for the indent invalidation property.
		 */
		protected const UPDATE_PROPERTY_INDENT : String = "indent";

		/**
		 * Name constant for the icon visibility invalidation property.
		 */
		protected const UPDATE_PROPERTY_ICON_VISIBILTIY : String = "icon";

		/**
		 * Name constant for the selected size invalidation property.
		 */
		protected const UPDATE_PROPERTY_SELECTED_SIZE : String = "selected_size";

		/**
		 * Name constant for the background update property.
		 */
		protected const COMMIT_PROPERTY_BACKGROUND : String = "background";

		/**
		 * Name constant for the icon geometry update property.
		 */
		protected const COMMIT_PROPERTY_ICON_GEOMETRY : String = "icon_geometry";

		/**
		 * Name constant for the content geometry update property.
		 */
		protected const COMMIT_PROPERTY_CONTENT_GEOMETRY : String = "content_geometry";

		/**
		 * Name constant for the selected content geometry update property.
		 */
		protected const COMMIT_PROPERTY_SELECTED_CONTENT_GEOMETRY : String = "selected_content_geometry";

		/* properties */

		/**
		 * The list item renderer data.
		 */
		protected var _data : ListItemRendererData;

		/**
		 * The selected content width.
		 */
		protected var _selectedWidth : uint;

		/**
		 * The selected content height.
		 */
		protected var _selectedHeight : uint;
		
		/* children */

		/**
		 * Background skin.
		 */
		protected var _backgroundSkin : ListItemBackgroundSkin;

		/**
		 * Content renderer.
		 */
		protected var _contentRenderer : IListItemContent;

		/**
		 * Additional content renderer for the selected state.
		 */
		protected var _selectedContentRenderer : IListItemContent;

		/**
		 * Icon container.
		 */
		protected var _icon : ListItemIcon;

		/* internals */

		/**
		 * Flag to indicate if the mouse is currently over the list item.
		 */
		protected var _over : Boolean = false;
		
		/* styles */

		/**
		 * Flag to indicate if the icon should be shown.
		 */
		protected var _showIcon : Boolean;		

		/**
		 * Label indent when icon visible.
		 */
		protected var _indent : uint;		

		/**
		 * ListItemRenderer constructor.
		 */
		public function ListItemRenderer() {

			setDefaultStyles([

				/* General */

				style.contentRenderer, ListItemContent,
				style.selectedItemContentRenderer, null,

				/* Icon */

				style.indent, 0,
				style.icon, false,
				style.iconPadding, 2,

				/* Background */

				style.background, true,
				style.backgroundType, BACKGROUND_CONTENT,
				
				style.evenIndexBackgroundColors, [0xF8F8F8],
				style.oddIndexBackgroundColors, [0xFFFFFF],
				style.overBackgroundColors, [0xC2D6F2],
				style.selectedBackgroundColors, [0xAAAAAA],
				
				/* Separator */

				style.separator, false,
				style.separatorColor, 0xEEEEEE,

				/* Selection */

				style.clickSelection, false,
				style.ctrlKeyDeselection, true,

			]);
			
			addEventListener(ListItemRendererEvent.ROLL_OVER, rendererRollOverHandler);
			addEventListener(ListItemRendererEvent.ROLL_OUT, rendererRollOutHandler);
			addEventListener(ListItemRendererEvent.SELECTION_CHANGED, selectionChangedHandler);
			addEventListener(ListItemRendererEvent.LIST_INDEX_CHANGED, listIndexChangedHandler);
		}
		
		/*
		 * IListItemRenderer
		 */
		
		/**
		 * @inheritDoc
		 */
		public function setSelectedSize(width : int, height : int) : void {
			if (_selectedWidth == width && _selectedHeight == height) return;
			
			_selectedWidth = width;
			_selectedHeight = height;

			invalidateProperty(UPDATE_PROPERTY_SELECTED_SIZE);
		}

		/**
		 * @inheritDoc
		 */
		public function set data(data : ListItemRendererData) : void {
			_data = data;
			
			if (!_initialised) return;
			
			if (_selectedContentRenderer) {
				_selectedContentRenderer.visible = _data.selected;		
			}

			invalidateProperty(UPDATE_PROPERTY_DATA); // geometry may change with new data
		}
		
		/**
		 * @inheritDoc
		 */
		public function get data() : ListItemRendererData {
			return _data;
		}
		
		/**
		 * @inheritDoc
		 */
		public function drawListItem() : void {
			// do nothing here since we are a View
			// and use the view life cycle
		}

		/*
		 * Info
		 */

		/**
		 * toString() function.
		 */
		override public function toString() : String {
			return "[ListItemRenderer] " + _data;
		}

		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		override protected function init() : void {
			_indent = getStyle(style.indent);
			_showIcon = getStyle(style.icon);
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			
			// background
			_backgroundSkin = new ListItemBackgroundSkin();
			drawBackground();
			addChild(_backgroundSkin);
			
			// content container
			_contentRenderer = new (getStyle(style.contentRenderer))();
			_contentRenderer.listItemRenderer = this;
			setContentGeometry();
			updateAutomatically(DisplayObject(_contentRenderer));

			_contentRenderer.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			_contentRenderer.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			_contentRenderer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_contentRenderer.addEventListener(MouseEvent.CLICK, clickHandler);

			_contentRenderer.drawContent();
			addChild(DisplayObject(_contentRenderer));

			var selectedItemContentRenderer : Class = getStyle(style.selectedItemContentRenderer);
			if (selectedItemContentRenderer != null) {
				_selectedContentRenderer = new selectedItemContentRenderer();
				
				_selectedContentRenderer.listItemRenderer = this;
				setSelectedContentGeometry();
				_selectedContentRenderer.visible = _data.selected;
				updateAutomatically(DisplayObject(_selectedContentRenderer));

				_selectedContentRenderer.drawContent();
				addChild(DisplayObject(_selectedContentRenderer));
			}
			
			if (_showIcon) createListItemIcon();

		}
		
		/**
		 * @inheritDoc
		 */
		override protected function update() : void {

			if (isInvalid(UPDATE_PROPERTY_SIZE) || isInvalid(UPDATE_PROPERTY_DATA)) {
				updateProperty(COMMIT_PROPERTY_BACKGROUND);
				updateProperty(COMMIT_PROPERTY_ICON_GEOMETRY);
				updateProperty(COMMIT_PROPERTY_CONTENT_GEOMETRY);
			}

			if (isInvalid(UPDATE_PROPERTY_SELECTED_SIZE)) {
				updateProperty(COMMIT_PROPERTY_SELECTED_CONTENT_GEOMETRY);
			}

			if (isInvalid(UPDATE_PROPERTY_BACKGROUND)) {
				updateProperty(COMMIT_PROPERTY_BACKGROUND);
			}
			
			if (isInvalid(UPDATE_PROPERTY_ICON_VISIBILTIY)) {
				if (getStyle(style.backgroundType) == ListItemRenderer.BACKGROUND_CONTENT) {
					updateProperty(COMMIT_PROPERTY_BACKGROUND);
				}

				updateProperty(COMMIT_PROPERTY_CONTENT_GEOMETRY);

				if (!_icon && _showIcon) {
					createListItemIcon();
				} else if (_icon && !_showIcon) {
					_icon.cleanUp();
					removeFromAutoUpdate(_icon);
					_icon.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
					_icon.removeEventListener(MouseEvent.CLICK, clickHandler);
					removeChild(_icon);
					_icon = null;
				}
			}

			if (isInvalid(UPDATE_PROPERTY_INDENT)) {
				if (getStyle(style.backgroundType) == ListItemRenderer.BACKGROUND_CONTENT) {
					updateProperty(COMMIT_PROPERTY_BACKGROUND);
				}

				updateProperty(COMMIT_PROPERTY_ICON_GEOMETRY);
				updateProperty(COMMIT_PROPERTY_CONTENT_GEOMETRY);
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitUpdate() : void {
			
			// background
			
			if (shouldUpdate(COMMIT_PROPERTY_BACKGROUND)) {
				drawBackground();
			}

			// icon
			
			if (shouldUpdate(COMMIT_PROPERTY_ICON_GEOMETRY)) {
				if (_icon) setIconGeometry();
			}

			// content
			
			if (shouldUpdate(COMMIT_PROPERTY_CONTENT_GEOMETRY)) {
				setContentGeometry();
				
				updateProperty(COMMIT_PROPERTY_SELECTED_CONTENT_GEOMETRY);
			}

			// selected content
			
			if (shouldUpdate(COMMIT_PROPERTY_SELECTED_CONTENT_GEOMETRY)) {
				if (_selectedContentRenderer) setSelectedContentGeometry();
			}

		}

		/**
		 * @inheritDoc
		 */
		override protected function styleChanged(property : String, value : *) : void {

			if (property == style.indent) {
				_indent = value;
				invalidateProperty(UPDATE_PROPERTY_INDENT);

			} else if (property == style.icon) {
				_showIcon = value;
				invalidateProperty(UPDATE_PROPERTY_ICON_VISIBILTIY);

			} else {
				invalidateProperty(UPDATE_PROPERTY_BACKGROUND);
			}
				
		}

		/**
		 * @inheritDoc
		 */
		override protected function cleanUpCalled() : void {
			_contentRenderer.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			_contentRenderer.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			_contentRenderer.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_contentRenderer.removeEventListener(MouseEvent.CLICK, clickHandler);
			
			DisplayObjectAdapter.cleanUp(_contentRenderer as DisplayObject);

			if (_icon) {
				_icon.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				_icon.removeEventListener(MouseEvent.CLICK, clickHandler);
			}

			removeEventListener(ListItemRendererEvent.ROLL_OVER, rendererRollOverHandler);
			removeEventListener(ListItemRendererEvent.ROLL_OUT, rendererRollOutHandler);
			removeEventListener(ListItemRendererEvent.SELECTION_CHANGED, selectionChangedHandler);
			removeEventListener(ListItemRendererEvent.LIST_INDEX_CHANGED, listIndexChangedHandler);
		}

		/*
		 * Protected
		 */

		/**
		 * Returns the icon container class.
		 * 
		 * <p>ListView: ListItemIcon</p>
		 * 
		 * <p>TreeView: DirectoryIcon</p>
		 * 
		 * @return The icon container class.
		 */
		protected function getListItemIconClass() : Class {
			return ListItemIcon;
		}

		/**
		 * Returns the x postion of the icon.
		 * 
		 * @return The icon x position.
		 */
		protected function getIconX() : uint {
			return 0;
		}

		/**
		 * Returns the content x position.
		 * 
		 * @return The content x position.
		 */
		protected function getContentX() : uint {
			return _showIcon ? _indent + getStyle(style.iconPadding) : 0;
		}

		/**
		 * Draws or redraws the background.
		 */
		protected function drawBackground() : void {
			
			if (!getStyle(style.background)) {
				_backgroundSkin.visible = false;
				return;
			}
			
			var backgroundType : String = getStyle(style.backgroundType);

			// size

			var backgroundX : uint = backgroundType == BACKGROUND_CONTENT ? getContentX() : 0;

			_backgroundSkin.setSize(_width - backgroundX, _height);
			_backgroundSkin.x = backgroundX;
			
			// background

			_backgroundSkin.visible = true;

			_backgroundSkin.setStyles([
				ListItemBackgroundSkin.style_backgroundColors, findBackgroundColors()
			]);

			// separator
			
			if (getStyle(style.separator) && !_data.isLast) {
				_backgroundSkin.setStyles([
					ListItemBackgroundSkin.style_border, true,
					ListItemBackgroundSkin.style_borderColor, getStyle(style.separatorColor)
				]);
			} else {
				_backgroundSkin.setStyle(ListItemBackgroundSkin.style_border, false);
			}
			
			_backgroundSkin.validateNow();
		}
		
		/*
		 * Private
		 */

		/**
		 * Sets the icon geometry.
		 */
		private function setIconGeometry() : void {
			_icon.setSize(_indent, _height);
			_icon.x = getIconX();
		}

		/**
		 * Sets the content geometry.
		 */
		private function setContentGeometry() : void {
			var contentX : uint = getContentX();

			_contentRenderer.setSize(_width - contentX, _height);
			_contentRenderer.x = contentX;

		}

		/**
		 * Sets the selected content geometry.
		 */
		private function setSelectedContentGeometry() : void {
			var contentX : uint = getContentX();

			_selectedContentRenderer.setSize(_width - contentX,  _selectedHeight - _height);
			_selectedContentRenderer.x = contentX; 
			_selectedContentRenderer.y = _height;
		}
		
		/**
		 * Creates the icon container.
		 */
		private function createListItemIcon() : void {
			_icon = new (getListItemIconClass())();
			setIconGeometry();

			_icon.listItemRenderer = this;
			updateAutomatically(_icon);

			_icon.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_icon.addEventListener(MouseEvent.CLICK, clickHandler);

			addChild(_icon);
		}

		/**
		 * Calculates the colors of the background skin.
		 */
		private function findBackgroundColors() : Array {
			
			var colors : Array;
			
			// selected color
			if (_data.selected) {
				var selectedColors : Array = getStyle(style.selectedBackgroundColors);
				if (selectedColors) colors = selectedColors;
			}
			
			// over color
			if (!colors && _over) {
				var overColors : Array = getStyle(style.overBackgroundColors);
				if (overColors) colors = overColors;
			}
			
			// default color
			if (!colors) {
				if (_data.listIndex % 2) {
					colors = getStyle(style.oddIndexBackgroundColors);
				} else {
					colors = getStyle(style.evenIndexBackgroundColors);
				}
			}
				
			return colors;
		}
		
		/**
		 * Selects or deselects the item.
		 */
		private function selectOrDeselect(ctrlKey : Boolean) : void {
			if (_data.selected) {
				var ctrlKeyDeselection : Boolean = getStyle(style.ctrlKeyDeselection);
				if (ctrlKeyDeselection && ctrlKey || !ctrlKeyDeselection) {
					_data.deselect();
				}
			} else {
				_data.select();					
			}
		}

		/*
		 * Content mouse events
		 */

		/**
		 * Content roll over handler.
		 */
		private function rollOverHandler(event : MouseEvent) : void {
			_data.notifyRollOver();
			
			event.updateAfterEvent();
		}

		/**
		 * Content roll out handler.
		 */
		private function rollOutHandler(event : MouseEvent) : void {
			_data.notifyRollOut();

			event.updateAfterEvent();
		}
		
		/**
		 * Content mouse down handler.
		 */
		protected function mouseDownHandler(event : MouseEvent) : void {
			_data.notifyMouseDown();
			
			if (!getStyle(style.clickSelection)) {
				selectOrDeselect(event.ctrlKey);
			}
			
		}
		
		/**
		 * Content click handler.
		 */
		private function clickHandler(event : MouseEvent) : void {
			_data.notifyClick();

			if (getStyle(style.clickSelection)) {
				selectOrDeselect(event.ctrlKey);
			}
		}

		/*
		 * ListItemRenderer events
		 */

		/**
		 * Roll over handler.
		 */
		private function rendererRollOverHandler(event : ListItemRendererEvent) : void {
			_over = true;
			drawBackground();
		}

		/**
		 * Roll out handler.
		 */
		private function rendererRollOutHandler(event : ListItemRendererEvent) : void {
			_over = false;
			drawBackground();
		}

		/**
		 * Selection changed handler.
		 */
		private function selectionChangedHandler(event : ListItemRendererEvent) : void {
			if (_selectedContentRenderer) {
				_selectedContentRenderer.visible = _data.selected;			
			}
			
			drawBackground();
		}

		/**
		 * List index changed handler.
		 */
		private function listIndexChangedHandler(event : ListItemRendererEvent) : void {
			drawBackground(); // alternating color may change
		}

	}
}

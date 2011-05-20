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
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.constants.Position;
	import com.sibirjak.asdpc.core.dataprovider.genericToStringFunction;
	import com.sibirjak.asdpc.core.skins.GlassFrame;
	import com.sibirjak.asdpc.listview.ListItemData;
	import com.sibirjak.asdpc.listview.core.IListItemRenderer;
	import com.sibirjak.asdpc.listview.core.ListItemRendererData;
	import com.sibirjak.asdpc.listview.core.ListItemRendererEvent;
	import com.sibirjak.asdpc.textfield.ILabel;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpc.tooltip.ToolTip;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/*
	 * Styles
	 */
	
	/**
	 * @copy ListItemContentStyles#labelFunction
	 */
	[Style(name="listItemContent_labelFunction", type="Function", format="String")]

	/**
	 * @copy ListItemContentStyles#labelStyles
	 */
	[Style(name="listItemContent_labelStyles", type="Array", arrayType="mixed", format="Propery, value, property, value, ...")]

	/**
	 * @copy ListItemContentStyles#overLabelStyles
	 */
	[Style(name="listItemContent_overLabelStyles", type="Array", arrayType="mixed", format="Propery, value, property, value, ...")]

	/**
	 * @copy ListItemContentStyles#selectedLabelStyles
	 */
	[Style(name="listItemContent_selectedLabelStyles", type="Array", arrayType="mixed", format="Propery, value, property, value, ...")]

	/**
	 * Default list item content renderer.
	 * 
	 * @author jes 23.11.2009
	 */
	public class ListItemContent extends View implements IListItemContent {
		
		/* style declarations */

		/**
		 * Central accessor to all ListItemContent style property definitions.
		 */
		public static var style : ListItemContentStyles = new ListItemContentStyles();

		/* changeable properties or styles */

		/**
		 * Name constant for the data invalidation property.
		 */
		protected const UPDATE_PROPERTY_DATA : String = "data";

		/**
		 * Name constant for the data property invalidation property.
		 */
		protected const UPDATE_PROPERTY_DATA_PROPERTY : String = "data_property";

		/**
		 * Name constant for the label color invalidation property.
		 */
		protected const UPDATE_PROPERTY_LABEL_STYLE : String = "color";

		/* internals */
		
		/**
		 * The IListItemRenderer instance, that owns the content renderer.
		 */
		protected var _listItemRenderer : IListItemRenderer;

		/**
		 * Flag to indicate if the mouse is currently over the list item.
		 */
		protected var _over : Boolean;
		
		/* children */

		/**
		 * Mouse sensitive area filling out the entire content dimensions.
		 */
		protected var _clickArea : GlassFrame;

		/**
		 * Label.
		 */
		protected var _label : ILabel;

		/* styles */

		/**
		 * Label function.
		 */
		protected var _labelFunction : Function;

		/**
		 * ListItemContent constructor.
		 */
		public function ListItemContent() {

			setDefaultStyles([
				style.labelFunction, function(data : ListItemData) : String {
					return genericToStringFunction(data.item);
				},
				
				style.labelStyles, [
					Label.style.color, 0x444444
				],

				style.overLabelStyles, [
					Label.style.color, 0x444444
				],

				style.selectedLabelStyles, [
					Label.style.color, 0xFFFFFF
				],
				
				style.toolTips, true
			]);
			
		}
		
		/*
		 * IListItemContentRenderer
		 */

		/**
		 * @inheritDoc
		 */
		public function set listItemRenderer(listItemRenderer : IListItemRenderer) : void {
			_listItemRenderer = listItemRenderer;

			_listItemRenderer.addEventListener(ListItemRendererEvent.ROLL_OVER, rollOverHandler);
			_listItemRenderer.addEventListener(ListItemRendererEvent.ROLL_OUT, rollOutHandler);
			_listItemRenderer.addEventListener(ListItemRendererEvent.SELECTION_CHANGED, selectionChangedHandler);
			_listItemRenderer.addEventListener(ListItemRendererEvent.DATA_CHANGED, dataChangedHandler);
			_listItemRenderer.addEventListener(ListItemRendererEvent.DATA_PROPERTY_CHANGED, dataPropertyChangedHandler);
		}

		/**
		 * @inheritDoc
		 */
		public function drawContent() : void {
			// do nothing here since View instances use their
			// custom life cycle
		}
		
		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		override protected function init() : void {
			_labelFunction = getStyle(style.labelFunction);
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			
			// click area

			_clickArea = new GlassFrame();
			_clickArea.name = "clickArea";
			_clickArea.setSize(_width, _height);
			addChild(_clickArea);
			
			// label
			
			_label = new Label();
			_label.setSize(_width, _height);
			_label.setDefaultStyles([
				Label.style.borderType, Label.BORDER_TYPE_TEXT,
				Label.style.horizontalAlign, Position.LEFT,
				Label.style.verticalAlign, Position.MIDDLE
			]);
			setLabelStyles();
			
			_label.text = _labelFunction(data.listItemData);
			
			updateAutomatically(DisplayObject(_label));

			addChild(DisplayObject(_label));
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function update() : void {
			
			var updateLabelStyle : Boolean = false;
			var updateLabelText : Boolean = false;
			
			/*
			 * Size changed
			 * - set new label size.
			 */
			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				_clickArea.setSize(_width, _height);
				_label.setSize(_width, _height);
			}

			/*
			 * Data changed
			 * - set new label text
			 * - set label color (may change due to a selection)
			 * - set label style (may change as well)
			 */
			if (isInvalid(UPDATE_PROPERTY_DATA)) {
				updateLabelText = true;
				updateLabelStyle = true; // style may change as well
			}
			
			/*
			 * Label text changed
			 * - set new label text
			 */
			if (isInvalid(UPDATE_PROPERTY_DATA_PROPERTY)) {
				updateLabelText = true;
			}
			
			/*
			 * Label style changed
			 */
			if (isInvalid(UPDATE_PROPERTY_LABEL_STYLE)) {
				updateLabelStyle = true;
			}

			// updates
			
			if (updateLabelText) {
				_label.text = _labelFunction(data.listItemData);
			}
			
			if (updateLabelStyle) {
				setLabelStyles();
			}
			
		}

		/**
		 * @inheritDoc
		 */
		override protected function styleChanged(property : String, value : *) : void {
			if (property == style.labelFunction) {
				invalidateProperty(UPDATE_PROPERTY_DATA);

			} else {
				invalidateProperty(UPDATE_PROPERTY_LABEL_STYLE);

			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function cleanUpCalled() : void {
			_listItemRenderer.removeEventListener(ListItemRendererEvent.ROLL_OVER, rollOverHandler);
			_listItemRenderer.removeEventListener(ListItemRendererEvent.ROLL_OUT, rollOutHandler);
			_listItemRenderer.removeEventListener(ListItemRendererEvent.SELECTION_CHANGED, selectionChangedHandler);
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
		
		/*
		 * Events
		 */
		
		/**
		 * Roll over handler
		 */
		private function rollOverHandler(event : ListItemRendererEvent) : void {
			_over = true;
			invalidateProperty(UPDATE_PROPERTY_LABEL_STYLE);

			if (_label.textChopped && getStyle(style.toolTips)) {
				ToolTip.getInstance().show(
					this, _labelFunction(data.listItemData), new Point(- 10, 4)
				);
			}
		}
		
		/**
		 * Roll out handler
		 */
		private function rollOutHandler(event : ListItemRendererEvent) : void {
			_over = false;
			invalidateProperty(UPDATE_PROPERTY_LABEL_STYLE);

			if (_label.textChopped && getStyle(style.toolTips)) ToolTip.getInstance().hide(this);
		}
		
		/**
		 * Selection changed handler
		 */
		private function selectionChangedHandler(event : ListItemRendererEvent) : void {
			invalidateProperty(UPDATE_PROPERTY_LABEL_STYLE);
		}
		
		/**
		 * Data changed handler
		 */
		private function dataChangedHandler(event : ListItemRendererEvent) : void {
			invalidateProperty(UPDATE_PROPERTY_DATA);
		}
		
		/**
		 * Data property changed handler
		 */
		private function dataPropertyChangedHandler(event : ListItemRendererEvent) : void {
			invalidateProperty(UPDATE_PROPERTY_DATA_PROPERTY);
		}
		
		/*
		 * Private
		 */
		
		/**
		 * Sets label styles depending on the current state.
		 * 
		 * <p>Priorities</p>
		 * 
		 * <ul>
		 * <li>Selected - Use always selected styles if item is selected, event if the mouse is over.</li>
		 * <li>Over - Use over styles when not selected and over.</li>
		 * <li>Default - Use default styles if no style could be found by state distinction.</li>
		 * </ul>
		 */
		private function setLabelStyles() : void {
			var stylesToSet : Array;

			if (data.selected) stylesToSet = getStyle(style.selectedLabelStyles);
			else if (_over) stylesToSet = getStyle(style.overLabelStyles);

			if (!stylesToSet) stylesToSet = getStyle(style.labelStyles);
			
			for (var i : int = 0; i < stylesToSet.length; i += 2) {
				_label.setStyle(stylesToSet[i], stylesToSet[i + 1]);
			}
		}

	}
}

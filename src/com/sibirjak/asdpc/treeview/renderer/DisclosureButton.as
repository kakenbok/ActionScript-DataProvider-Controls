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
package com.sibirjak.asdpc.treeview.renderer {
	import flash.utils.setTimeout;
	import com.sibirjak.asdpc.core.DisplayObjectAdapter;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.treeview.constants.TreeNodeState;
	import com.sibirjak.asdpc.treeview.core.ITreeNodeRenderer;
	import com.sibirjak.asdpc.treeview.core.TreeNodeRendererData;
	import com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent;
	import com.sibirjak.asdpc.treeview.renderer.skins.DisclosureButtonArrowIconSkin;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/*
	 * Styles
	 */

	/**
	 * @copy DisclosureButton#style_size
	 */
	[Style(name="disclosureButton_size", type="uint", format="Size")]

	/**
	 * @copy DisclosureButton#style_expandedIconSkin
	 */
	[Style(name="disclosureButton_expandedIconSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy DisclosureButton#style_collapsedIconSkin
	 */
	[Style(name="disclosureButton_collapsedIconSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy DisclosureButton#style_expandAll
	 */
	[Style(name="disclosureButton_expandAll", type="Boolean")]

	/**
	 * @copy DisclosureButton#style_expandAllDelay
	 */
	[Style(name="disclosureButton_expandAllDelay", type="Number", format="Time")]

	/**
	 * @copy DisclosureButton#style_collapseAllEffect
	 */
	[Style(name="disclosureButton_collapseAllEffect", type="Boolean")]

	/**
	 * Disclosure button.
	 * 
	 * @author jes 12.08.2009
	 */
	public class DisclosureButton extends View {

		/* style_declarations */

		/**
		 * Style property defining the button size.
		 */
		public static const style_size : String = "disclosureButton_size";

		/**
		 * Style property defining the icon skin for the expanded state.
		 */
		public static const style_expandedIconSkin : String = "disclosureButton_expandedIconSkin";

		/**
		 * Style property defining the icon skin for the collapsed state.
		 */
		public static const style_collapsedIconSkin : String = "disclosureButton_collapsedIconSkin";

		/**
		 * Style property defining the expand all functionality availability.
		 */
		public static const style_expandAll : String = "disclosureButton_expandAll";

		/**
		 * Style property defining the delay between mouse down and expand all.
		 */
		public static const style_expandAllDelay : String = "disclosureButton_expandAllDelay";

		/**
		 * Style property defining the application of the collapse all effect.
		 */
		public static const style_collapseAllEffect : String = "disclosureButton_collapseAllEffect";

		/* constants */

		/**
		 * Name constant defining the expanded icon skin name.
		 */
		public static const EXPANDED_ICON_SKIN_NAME: String = "expandedIcon";

		/**
		 * Name constant defining the collapsed icon skin name.
		 */
		public static const COLLAPSED_ICON_SKIN_NAME: String = "collapsedIcon";

		/* changeable properties or styles */

		/**
		 * Name constant for the icon size invalidation property.
		 */
		private const UPDATE_PROPERTY_ICON_SIZE : String = "icon_size";

		/**
		 * Name constant for the tree node state invalidation property.
		 */
		private const UPDATE_PROPERTY_TREE_NODE_STATE : String = "tree_node_state";

		/**
		 * Name constant for the icon invalidation property.
		 */
		private const UPDATE_PROPERTY_ICON : String = "icon";

		/* properties */

		/**
		 * The ITreeNodeRenderer instance, that owns the disclosure button.
		 */
		private var _treeNodeRenderer : ITreeNodeRenderer;

		/* styles */
		
		/**
		 * The icon size.
		 */
		private var _iconSize : uint;

		/* internal */

		/**
		 * Timer for the expand all functionality.
		 */
		private var _expandAllTimer : Timer;

		/**
		 * Flag, indicates if the expandAll timer did fire or if the
		 * mouse has been released in the meantime.
		 */
		private var _expandAllTimerDidFire : Boolean = false;
		
		/**
		 * Array of all icon skins.
		 */
		private var _icons : Array;

		/* children */
		
		/**
		 * Expanded icon.
		 */
		private var _expandedIcon : DisplayObject;

		/**
		 * Collapsed icon.
		 */
		private var _collapsedIcon : DisplayObject;

		/**
		 * DisclosureButton constructor.
		 */
		public function DisclosureButton() {
			setDefaultStyles([
				style_size, 7,
				style_expandedIconSkin, DisclosureButtonArrowIconSkin,
				style_collapsedIconSkin, DisclosureButtonArrowIconSkin,

				style_expandAll, true,
				style_expandAllDelay, 300,
				style_collapseAllEffect, true
			]);
			
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 * Sets the containing tree node renderer.
		 */
		public function set treeNodeRenderer(treeNodeRenderer : TreeNodeRenderer) : void {
			_treeNodeRenderer = treeNodeRenderer;

			_treeNodeRenderer.addEventListener(TreeNodeRendererEvent.DATA_CHANGED, stateChangedHandler);
			_treeNodeRenderer.addEventListener(TreeNodeRendererEvent.TREE_NODE_STATE_CHANGED, stateChangedHandler);
			_treeNodeRenderer.addEventListener(TreeNodeRendererEvent.COLLAPSED, collapsedHandler);
		}
		
		/*
		 * View life cycle
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function init() : void {
			_iconSize = getStyle(style_size);

			addEventListener(MouseEvent.MOUSE_DOWN, disclosureButtonMouseDownHandler);
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			
			drawBackground();

			// folder closed
			
			var expandedIconSkin : Class = getStyle(style_expandedIconSkin);
			_expandedIcon = new expandedIconSkin(); 
			_expandedIcon.name = EXPANDED_ICON_SKIN_NAME; 

			// folder open

			var collapsedIconSkin : Class = getStyle(style_collapsedIconSkin);
			_collapsedIcon = new collapsedIconSkin(); 
			_collapsedIcon.name = COLLAPSED_ICON_SKIN_NAME; 

			// create enumerable array

			_icons = [_expandedIcon, _collapsedIcon];

			// layout and add

			setIconSize();
			setIconPosition();
			addIcons();

			showIconSkin();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function update() : void {

			if (isInvalid(UPDATE_PROPERTY_ICON)) {
				while (numChildren) {
					removeChildAt(0);
				}
				draw();

			} else {
				var positionIcon : Boolean = false;

				if (isInvalid(UPDATE_PROPERTY_SIZE)) {
					positionIcon = true;
	
					drawBackground();
				}

				if (isInvalid(UPDATE_PROPERTY_ICON_SIZE)) {
					positionIcon = true;
	
					setIconSize();
				}
	
				if (isInvalid(UPDATE_PROPERTY_TREE_NODE_STATE)) {
					showIconSkin();
				}

				if (positionIcon) {
					setIconPosition();
				}
			}

		}

		/**
		 * @inheritDoc
		 */
		override protected function styleChanged(property : String, value : *) : void {
			if (property.indexOf("IconSkin") > -1) {
				invalidateProperty(UPDATE_PROPERTY_ICON);
			} else if (property == style_size) {
				_iconSize = value;
				invalidateProperty(UPDATE_PROPERTY_ICON_SIZE);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function cleanUpCalled() : void {
			removeEventListener(MouseEvent.MOUSE_DOWN, disclosureButtonMouseDownHandler);

			_treeNodeRenderer.removeEventListener(TreeNodeRendererEvent.DATA_CHANGED, stateChangedHandler);
			_treeNodeRenderer.removeEventListener(TreeNodeRendererEvent.TREE_NODE_STATE_CHANGED, stateChangedHandler);
			_treeNodeRenderer.removeEventListener(TreeNodeRendererEvent.COLLAPSED, collapsedHandler);

			if (_expandAllTimer) _expandAllTimer.removeEventListener(TimerEvent.TIMER, timerHandler);

			stage.removeEventListener(MouseEvent.MOUSE_UP, disclosureButtonMouseUpHandler);
		}

		/*
		 * Private
		 */
		
		/**
		 * Casts the renderer ListItemRendererData into TreeNodeRendererData.
		 */
		private function get data() : TreeNodeRendererData {
			return _treeNodeRenderer.data as TreeNodeRendererData;
		}

		/**
		 * Adds all icons to the display list.
		 */
		private function addIcons() : void {
			for each (var icon : DisplayObject in _icons) {
				DisplayObjectAdapter.addChild(icon, this);
			}
		}

		/**
		 * Sets the position for all icons.
		 */
		private function setIconSize() : void {
			for each (var icon : DisplayObject in _icons) {
				DisplayObjectAdapter.setSize(icon, _iconSize, _iconSize);
				DisplayObjectAdapter.validateNow(icon); // be consistent with a possible reposition
			}
		}

		/**
		 * Sets the position for a single icon.
		 */
		private function setIconPosition() : void {
			for each (var icon : DisplayObject in _icons) {
				DisplayObjectAdapter.moveTo(icon, Math.round((_width - _iconSize) / 2), Math.round((_height - _iconSize) / 2));
			}
		}

		/**
		 * Shows the icon depending on the current node state.
		 */
		private function showIconSkin() : void {
			_expandedIcon.visible = data.treeNodeState == TreeNodeState.BRANCH_OPEN;
			_collapsedIcon.visible = data.treeNodeState == TreeNodeState.BRANCH_CLOSED;
		}

		/**
		 * Draws a mouse sensitive background over the entire button area.
		 */
		private function drawBackground() : void {
			graphics.clear();
			graphics.beginFill(0xFFFFFF, 0);
			graphics.drawRect(0, 0, _width, _height);
		}
		
		/*
		 * Events
		 */

		/**
		 * Click handler.
		 */
		private function clickHandler(event : MouseEvent) : void {
			// do not dispatch a click event for the disclosure button
			event.stopPropagation();
		}

		/**
		 * Mouse down handler.
		 */
		private function disclosureButtonMouseDownHandler(event : MouseEvent) : void {
			
			if (data.treeNodeState == TreeNodeState.BRANCH_OPEN) {
				data.collapse();
			} else {
				data.expand();
			}

			if (!getStyle(style_expandAll)) return;
			
			// mouse up listener to stop the timer when the mouse is released
			stage.addEventListener(MouseEvent.MOUSE_UP, disclosureButtonMouseUpHandler);

			if (!_expandAllTimer) {
				_expandAllTimer = new Timer(getStyle(style_expandAllDelay), 1);
				_expandAllTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			}
			_expandAllTimerDidFire = false;
			_expandAllTimer.start();
		}
		
		/**
		 * Mouse up handler.
		 */
		private function disclosureButtonMouseUpHandler(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, disclosureButtonMouseUpHandler);

			if (!_expandAllTimerDidFire) {
				_expandAllTimer.stop();
			}
		}

		/**
		 * Expand all timer handler.
		 */
		private function timerHandler(event : TimerEvent) : void {
			if (data.treeNodeState == TreeNodeState.BRANCH_OPEN) {
				data.expand(true);
			} else {
				data.collapse(true);
			}
			
			_expandAllTimerDidFire = true;
		}

		/*
		 * TreeNodeRenderer events
		 */
		
		/**
		 * Node state changed handler.
		 */
		private function stateChangedHandler(event : TreeNodeRendererEvent) : void {
			showIconSkin();
		}

		/**
		 * Node collapsed handler.
		 */
		private function collapsedHandler(event : TreeNodeRendererEvent) : void {
			if (!getStyle(style_collapseAllEffect)) return;
			
			if (event.collapseAll) {
				visible = false;
				setTimeout(function() : void {visible = true;}, 100);
			}
		}

	}
}

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
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;
	import com.sibirjak.asdpc.treeview.constants.TreeNodeState;
	import com.sibirjak.asdpc.treeview.core.ITreeNodeRenderer;
	import com.sibirjak.asdpc.treeview.core.TreeNodeRendererData;
	import com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	/*
	 * Styles
	 */
	
	/**
	 * @copy TreeNodeRendererStyles#disclosureButton
	 */
	[Style(name="treeNodeRenderer_disclosureButton", type="Boolean")]

	/**
	 * @copy TreeNodeRendererStyles#connectors
	 */
	[Style(name="treeNodeRenderer_connectors", type="Boolean")]

	/**
	 * @copy TreeNodeRendererStyles#expandCollapseOnDoubleClick
	 */
	[Style(name="treeNodeRenderer_expandCollapseOnDoubleClick", type="Boolean")]

	/*
	 * TreeNodeRendererEvent
	 */

	/**
	 * @eventType com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent.CONNECTION_CHANGED
	 */
	[Event(name="treeNodeRenderer_connectionChanged", type="com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent.LEVEL_CHANGED
	 */
	[Event(name="treeNodeRenderer_levelChanged", type="com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent.TREE_NODE_STATE_CHANGED
	 */
	[Event(name="treeNodeRenderer_stateChanged", type="com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent.EXPANDED
	 */
	[Event(name="treeNodeRenderer_expanded", type="com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent.COLLAPSED
	 */
	[Event(name="treeNodeRenderer_collapsed", type="com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent")]

	/**
	 * Default tree node renderer.
	 * 
	 * @author jes 27.07.2009
	 */
	public class TreeNodeRenderer extends ListItemRenderer implements ITreeNodeRenderer {

		/* style declarations */

		/**
		 * Central accessor to all TreeNodeRenderer style property definitions.
		 */
		public static var style : TreeNodeRendererStyles = new TreeNodeRendererStyles();

		/* changeable properties or styles */

		/**
		 * Name constant for the level invalidation property.
		 */
		private const UPDATE_PROPERTY_LEVEL : String = "level";

		/**
		 * Name constant for the connector visibility invalidation property.
		 */
		private const UPDATE_PROPERTY_CONNECTOR_VISIBILITY : String = "connectors";

		/**
		 * Name constant for the disclosure button visibility invalidation property.
		 */
		private const UPDATE_PROPERTY_DISCLOSURE_BUTTON_VISIBILITY : String = "disclosure_button";

		/**
		 * Name constant for the connector geometry update property.
		 */
		protected const COMMIT_PROPERTY_CONNECTOR_GEOMETRY : String = "connector_geometry";

		/**
		 * Name constant for the button geometry update property.
		 */
		protected const COMMIT_PROPERTY_BUTTON_GEOMETRY : String = "button_geometry";

		/* internal */
		
		/**
		 * Elapsed time since the last mouse down event.
		 */
		protected var _lastMouseDownTime : int;

		/* children */
		
		/**
		 * Connector container.
		 */
		private var _connectorContainer : ConnectorContainer;

		/**
		 * Disclosure button.
		 */
		private var _disclosureButton : DisclosureButton;
		
		/* styles */
		
		/**
		 * True, if connectors should be visible.
		 */
		private var _showConnectors : Boolean;

		/**
		 * True, if the disclosure button should be visible.
		 */
		private var _showDisclosureButton : Boolean;

		/**
		 * TreeNodeRenderer constructor.
		 */
		public function TreeNodeRenderer() {
			setDefaultStyles([
				style.connectors, true,
				style.disclosureButton, true,
				
				style.expandCollapseOnDoubleClick, true,
				
				style.indent, 16, // overridden
				style.icon, true // overridden
			]);
			
			addEventListener(TreeNodeRendererEvent.LEVEL_CHANGED, levelChangedHandler);
			addEventListener(TreeNodeRendererEvent.SELECTION_CHANGED, selectionChangedHandler);
			addEventListener(TreeNodeRendererEvent.DATA_CHANGED, selectionChangedHandler);
			addEventListener(TreeNodeRendererEvent.DATA_CHANGED, selectionChangedHandler);
		}
		
		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		override protected function init() : void {
			super.init();

			_showConnectors = getStyle(style.connectors);
			_showDisclosureButton = getStyle(style.disclosureButton);
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			super.draw(); // draws background and content renderer
			
			// connectors

			if (_showConnectors) createConnectorContainer();

			// disclosure button

			if (_showDisclosureButton) createDisclosureButton();


		}
		
		/**
		 * @inheritDoc
		 */
		override protected function update() : void {
			super.update(); // already draws background
			
			// resize and resposition all children
			// icon and content geometry is already set by ListItemRenderer
			
			if (isInvalid(UPDATE_PROPERTY_SIZE) || isInvalid(UPDATE_PROPERTY_INDENT)) { 
				updateProperty(COMMIT_PROPERTY_CONNECTOR_GEOMETRY);
				updateProperty(COMMIT_PROPERTY_BUTTON_GEOMETRY);
			}
			
			// resize connectors if selected
			
			if (isInvalid(UPDATE_PROPERTY_SELECTED_SIZE)) { 
				if (_data.selected) {
					updateProperty(COMMIT_PROPERTY_CONNECTOR_GEOMETRY);
				}
			}
			
			// data changes - reset all components
			// level may change and therefore all positions
			// and measurings

			if (isInvalid(UPDATE_PROPERTY_DATA)) {
				updateProperty(COMMIT_PROPERTY_BUTTON_GEOMETRY);
				updateProperty(COMMIT_PROPERTY_CONTENT_GEOMETRY);
			}
			
			// reset all positions and dimensions
			// the background and content already have been updated
			// in ListItemRenderer at the place where the data has
			// been reset.
			
			if (isInvalid(UPDATE_PROPERTY_LEVEL)) {
				if (getStyle(style.backgroundType) == ListItemRenderer.BACKGROUND_CONTENT) {
					updateProperty(COMMIT_PROPERTY_BACKGROUND);
				}

				updateProperty(COMMIT_PROPERTY_BUTTON_GEOMETRY);
				updateProperty(COMMIT_PROPERTY_ICON_GEOMETRY);
				updateProperty(COMMIT_PROPERTY_CONTENT_GEOMETRY);
			}

			// connector visibility

			if (isInvalid(UPDATE_PROPERTY_CONNECTOR_VISIBILITY)) {
				if (!_connectorContainer && _showConnectors) {
					createConnectorContainer();
				} else if (_connectorContainer && !_showConnectors) {
					_connectorContainer.cleanUp();
					removeFromAutoUpdate(_connectorContainer);
					removeChild(_connectorContainer);
					_connectorContainer = null;
				}
			}

			// disclosure button visibility

			if (isInvalid(UPDATE_PROPERTY_DISCLOSURE_BUTTON_VISIBILITY)) {
				if (getStyle(style.backgroundType) == ListItemRenderer.BACKGROUND_CONTENT) {
					updateProperty(COMMIT_PROPERTY_BACKGROUND);
				}

				updateProperty(COMMIT_PROPERTY_ICON_GEOMETRY);
				updateProperty(COMMIT_PROPERTY_CONTENT_GEOMETRY);

				if (!_disclosureButton && _showDisclosureButton) {
					createDisclosureButton();
				} else if (_disclosureButton && !_showDisclosureButton) {
					_disclosureButton.cleanUp();
					removeFromAutoUpdate(_disclosureButton);
					removeChild(_disclosureButton);
					_disclosureButton = null;
				}
			}

		}

		/**
		 * @inheritDoc
		 */
		override protected function commitUpdate() : void {
			
			super.commitUpdate();
			
			// connectors

			if (shouldUpdate(COMMIT_PROPERTY_CONNECTOR_GEOMETRY)) {
				if (_connectorContainer) setConnectorContainerGeometry();
			}
			
			// button

			if (shouldUpdate(COMMIT_PROPERTY_BUTTON_GEOMETRY)) {
				if (_disclosureButton) setDisclosureButtonGeometry();
			}

		}

		/**
		 * @inheritDoc
		 */
		override protected function styleChanged(property : String, value : *) : void {
			
			if (property.indexOf("treeNodeRenderer_") == 0) {
				if (property == style.disclosureButton) {
					_showDisclosureButton = getStyle(style.disclosureButton);
					if (_connectorContainer) _connectorContainer.disclosureButton = _showDisclosureButton;
					invalidateProperty(UPDATE_PROPERTY_DISCLOSURE_BUTTON_VISIBILITY);
				}
	
				if (property == style.connectors) {
					_showConnectors = getStyle(style.connectors);
					invalidateProperty(UPDATE_PROPERTY_CONNECTOR_VISIBILITY);
				}
				
			} else {
				if (property == style.indent) {
					if (_connectorContainer) _connectorContainer.indent = value;
				}

				if (property == style.icon) {
					if (_connectorContainer) _connectorContainer.icon = value;
				}

				super.styleChanged(property, value);
			}
			
		}

		/**
		 * @inheritDoc
		 */
		override protected function cleanUpCalled() : void {
			super.cleanUpCalled();

			removeEventListener(TreeNodeRendererEvent.LEVEL_CHANGED, levelChangedHandler);
			removeEventListener(TreeNodeRendererEvent.SELECTION_CHANGED, selectionChangedHandler);
			removeEventListener(TreeNodeRendererEvent.DATA_CHANGED, selectionChangedHandler);
		}

		/*
		 * ListItemRenderer protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function getListItemIconClass() : Class {
			return DirectoryIcon;
		}

		/**
		 * @inheritDoc
		 */
		override protected function getIconX() : uint {
			var iconLevel : uint = treeNodeData.level;
			if (_showDisclosureButton) iconLevel++;
			return iconLevel * _indent;
		}

		/**
		 * @inheritDoc
		 */
		override protected function getContentX() : uint {
			var contentX : uint = treeNodeData.level * _indent;

			if (_showDisclosureButton) contentX += _indent;
			if (_showIcon) contentX += _indent + getStyle(style.iconPadding);

			return contentX;
		}

		/**
		 * @inheritDoc
		 */
		override protected function mouseDownHandler(event : MouseEvent) : void {
			super.mouseDownHandler(event);
			
			if (!getStyle(style.expandCollapseOnDoubleClick)) return;

			if (_lastMouseDownTime && getTimer() - _lastMouseDownTime < 300) {
				_lastMouseDownTime = 0;

				if (treeNodeData.treeNodeState == TreeNodeState.BRANCH_OPEN) {
					treeNodeData.collapse();
				} else {
					treeNodeData.expand();
				}

			} else {
				_lastMouseDownTime = getTimer();
			}
		}

		/*
		 * ListItemRenderer events
		 */
		
		/**
		 * Level changed handler.
		 */
		private function levelChangedHandler(event : TreeNodeRendererEvent) : void {
			invalidateProperty(UPDATE_PROPERTY_LEVEL);
		}

		/**
		 * Selection changed handler.
		 */
		private function selectionChangedHandler(event : TreeNodeRendererEvent) : void {
			if (_connectorContainer) setConnectorContainerGeometry();
		}

		/*
		 * Private
		 */
		
		/**
		 * Creates the disclosure button.
		 */
		private function createDisclosureButton() : void {
			_disclosureButton = new DisclosureButton(); 
			setDisclosureButtonGeometry();
			_disclosureButton.treeNodeRenderer = this;
			updateAutomatically(_disclosureButton);
			
			addChild(DisplayObject(_disclosureButton));
		}

		/**
		 * Creates the connector container button.
		 */
		private function createConnectorContainer() : void {
			_connectorContainer = new ConnectorContainer();
			setConnectorContainerGeometry();
			_connectorContainer.treeNodeRenderer = this;
			_connectorContainer.indent = _indent;
			_connectorContainer.icon = getStyle(style.icon);
			_connectorContainer.disclosureButton = _showDisclosureButton;
			updateAutomatically(_connectorContainer);
			
			addChildAt(DisplayObject(_connectorContainer), getChildIndex(DisplayObject(_contentRenderer)));
		}
		
		/**
		 * Casts the ListItemRendererData into TreeNodeRendererData.
		 */
		private function get treeNodeData() : TreeNodeRendererData {
			return _data as TreeNodeRendererData;
		}

		/**
		 * Sets the disclosure button size and position.
		 */
		private function setDisclosureButtonGeometry() : void {
			_disclosureButton.setSize(_indent, _height);
			_disclosureButton.x = treeNodeData.level * _indent;
		}

		/**
		 * Sets the connector container size and position.
		 */
		private function setConnectorContainerGeometry() : void {
			_connectorContainer.setSize(_height, _height); // width not important here

			if (_data.selected && _selectedHeight != _height) {
				_connectorContainer.extendedHeight = _selectedHeight - _height;
			} else {
				_connectorContainer.extendedHeight = 0;
			}

		}

	}
}

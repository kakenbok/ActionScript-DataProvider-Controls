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
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.treeview.constants.TreeNodeState;
	import com.sibirjak.asdpc.treeview.core.ITreeNodeRenderer;
	import com.sibirjak.asdpc.treeview.core.TreeNodeRendererData;
	import com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent;
	import com.sibirjak.asdpc.treeview.renderer.skins.DottedConnectorSkin;

	/*
	 * Styles
	 */

	/**
	 * @copy ConnectorContainer#style_connectorSkin
	 */
	[Style(name="connectorContainer_connectorSkin", type="Class", format="com.sibirjak.asdpc.treeview.renderer.IConnectorSkin")]

	/**
	 * @copy ConnectorContainer#style_connectorAtRootLevel
	 */
	[Style(name="connectorContainer_connectorAtRootLevel", type="Boolean")]

	/**
	 * @copy ConnectorContainer#style_connectorAtButton
	 */
	[Style(name="connectorContainer_connectorAtButton", type="Boolean")]

	/**
	 * @copy ConnectorContainer#style_connectorAtIcon
	 */
	[Style(name="connectorContainer_connectorAtIcon", type="Boolean")]

	/**
	 * Container for the tree node connectors.
	 * 
	 * @author jes 02.11.2009
	 */
	public class ConnectorContainer extends View {

		/* style declarations */

		/**
		 * Style property defining the connector skin.
		 */
		public static const style_connectorSkin : String = "connectorContainer_connectorSkin";

		/**
		 * Style property defining the visibility of the connectors at root level.
		 */
		public static const style_connectorAtRootLevel : String = "connectorContainer_connectorAtRootLevel";

		/**
		 * Style property defining the visibility of the connectors at button level.
		 */
		public static const style_connectorAtButton : String = "connectorContainer_connectorAtButton";

		/**
		 * Style property defining the visibility of the connectors at icon level.
		 */
		public static const style_connectorAtIcon : String = "connectorContainer_connectorAtIcon";

		/* changeable properties or styles */

		/**
		 * Name constant for the connector skin invalidation property.
		 */
		private const UPDATE_PROPERTY_CONNECTOR_SKIN : String = "skin";

		/**
		 * Name constant for the data invalidation property.
		 */
		private const UPDATE_PROPERTY_CONNECTIONS : String = "data";

		/* properties */

		/**
		 * The ITreeNodeRenderer instance, that owns the connector container.
		 */
		private var _treeNodeRenderer : ITreeNodeRenderer;

		/* styles */

		/**
		 * The level indention size.
		 */
		private var _indent : uint;

		/**
		 * Disclosure button visibility.
		 */
		private var _disclosureButton : Boolean;

		/**
		 * Icon visibility.
		 */
		private var _icon : Boolean;

		/**
		 * The bottom position of all bottom connections of all connectors.
		 */
		private var _extendedHeight : uint;
		 
		/**
		 * ConnectorContainer constructor.
		 */
		public function ConnectorContainer() {
			
			setDefaultStyles([
				style_connectorSkin, DottedConnectorSkin,
				style_connectorAtRootLevel, true,
				style_connectorAtButton, false,
				style_connectorAtIcon, false,
			]);

		}

		/**
		 * Sets the containing tree node renderer.
		 */
		public function set treeNodeRenderer(treeNodeRenderer : TreeNodeRenderer) : void {
			_treeNodeRenderer = treeNodeRenderer;
			
			_treeNodeRenderer.addEventListener(TreeNodeRendererEvent.DATA_CHANGED, connectionChangedHandler);
			_treeNodeRenderer.addEventListener(TreeNodeRendererEvent.TREE_NODE_STATE_CHANGED, connectionChangedHandler);
			_treeNodeRenderer.addEventListener(TreeNodeRendererEvent.CONNECTION_CHANGED, connectionChangedHandler);
			_treeNodeRenderer.addEventListener(TreeNodeRendererEvent.LEVEL_CHANGED, connectionChangedHandler);
		}
		
		/**
		 * Sets the level indention size.
		 */
		public function set indent(indent : uint) : void {
			_indent = indent;
			
			invalidateProperty(UPDATE_PROPERTY_CONNECTIONS);
		}

		/**
		 * Sets the disclosure button visibility.
		 */
		public function set disclosureButton(disclosureButton : Boolean) : void {
			_disclosureButton = disclosureButton;
			
			invalidateProperty(UPDATE_PROPERTY_CONNECTIONS);
		}

		/**
		 * Sets the disclosure icon visibility.
		 */
		public function set icon(icon : Boolean) : void {
			_icon = icon;

			invalidateProperty(UPDATE_PROPERTY_CONNECTIONS);
		}

		/**
		 * If this value is set, the bottom connector should reach
		 * the _height + extendedHeight position. 
		 */
		public function set extendedHeight(extendedHeight : uint) : void {
			if (extendedHeight == _extendedHeight) return;

			_extendedHeight = extendedHeight;
			
			invalidateProperty(UPDATE_PROPERTY_CONNECTIONS);
		}

		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			showConnections();
		}

		/**
		 * @inheritDoc
		 */
		override protected function update() : void {
			var updateConnections : Boolean = false;

			if (isInvalid(UPDATE_PROPERTY_CONNECTOR_SKIN)) {
				while (numChildren) {
					removeChildAt(0);
				}
				
				updateConnections = true;
			}

			if (isInvalid(UPDATE_PROPERTY_SIZE) || isInvalid(UPDATE_PROPERTY_CONNECTIONS)) {
				updateConnections = true;
			}

			if (updateConnections) {
				showConnections();
			}

		}

		/**
		 * @inheritDoc
		 */
		override protected function styleChanged(property : String, value : *) : void {
			if (property == style_connectorSkin) { // recreate connectors
				invalidateProperty(UPDATE_PROPERTY_CONNECTOR_SKIN);
			} else { // show/hide connector below icon or button or at root level
				invalidateProperty(UPDATE_PROPERTY_CONNECTIONS);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function cleanUpCalled() : void {
			_treeNodeRenderer.removeEventListener(TreeNodeRendererEvent.DATA_CHANGED, connectionChangedHandler);
			_treeNodeRenderer.removeEventListener(TreeNodeRendererEvent.TREE_NODE_STATE_CHANGED, connectionChangedHandler);
			_treeNodeRenderer.removeEventListener(TreeNodeRendererEvent.CONNECTION_CHANGED, connectionChangedHandler);
			_treeNodeRenderer.removeEventListener(TreeNodeRendererEvent.LEVEL_CHANGED, connectionChangedHandler);
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
		 * Shows all connections.
		 */
		private function showConnections() : void {
			
			var skinClass : Class = getStyle(style_connectorSkin);
			if (skinClass == null) return;
			
			var i : uint;
			var connector : Connector;
			var connectorTypeArray : Array = getConnectionsArray();
			var visibleConnections : uint;
			
			// data.level + 1 = position at icon
			// data.level = left to the icon
			for (i = 0; i <= data.level + 1; i++) {
				
				visibleConnections = connectorTypeArray[i];

				if (numChildren > i) {
					connector = getChildAt(i) as Connector;
					connector.visible = true;
				} else { // create another connector
					connector = new Connector();
					connector.skinClass = skinClass;
				}
				
				connector.setSize(_indent, _height);

				connector.extendedHeight = _extendedHeight;
				
				if (_extendedHeight && visibleConnections == Connector.BOTTOM) {
					connector.bottomY = _height;
				} else {
					connector.bottomY = 0;
				}

				connector.moveTo(_indent * i, 0);

				if (!connector.addedToStage) addChild(connector);
				else connector.validateNow();

				connector.show(visibleConnections);
			}
			
			// hide unused connectors
			
			while (i < numChildren) {
				connector = getChildAt(i) as Connector;
				connector.visible = false;
				i++;
			}
			
		}
		
		/**
		 * Returns the connection configuration.
		 */
		private function getConnectionsArray() : Array {
			
			var connectionsArray : Array = new Array();
			var visibleConnections : uint;
			
			/*
			 * Connector at icon
			 * 
			 * We always show a connection to the left.
			 * 
			 * If the node is an open branch, we also show a connection to the
			 * bottom.
			 */
			
			visibleConnections = visibleConnections = Connector.LEFT;
			
			// open branch
			if (data.treeNodeState == TreeNodeState.BRANCH_OPEN) {
				visibleConnections += Connector.BOTTOM;
			}

			connectionsArray[data.level + 1] = visibleConnections;

			/*
			 * Connector at disclosure button
			 * 
			 * We always show a connection towards the icon (right).
			 * 
			 * We show a top connector for all nodes except the very top node.
			 * 
			 * We show a bottom connector for all nodes except the last node
			 * of a branch.
			 */
			
			visibleConnections = visibleConnections = Connector.RIGHT;

			// top connector
			
			// hide top connector, if the item is our first
			// visible item in list (root node)
			if (data.level != 0 || !data.isFirstItemInBranch) {
				visibleConnections += Connector.TOP;
			}

			// bottom connector

			// show bottom connector if succeeding siblings exist
			if (!data.isLastItemInBranch) {
				visibleConnections += Connector.BOTTOM;
			}

			connectionsArray[data.level] = visibleConnections;

			/*
			 * Connectors before the disclosure button
			 * 
			 * There can be only a TOP+BOTTOM connection.
			 * This connection is shown if the particular parent is not
			 * the last item in its branch.
			 */

			var parentData : TreeNodeRendererData = data.parentTreeNodeRendererData;
			while (parentData) {
				visibleConnections = 0;

				if (!parentData.isLastItemInBranch) {
					visibleConnections = Connector.TOP + Connector.BOTTOM;
				}

				connectionsArray[parentData.level] = visibleConnections;
				parentData = parentData.parentTreeNodeRendererData;
			}
			
			updateConnectionsArray(connectionsArray);
			
			return connectionsArray;
		}

		/**
		 * Applies rules to the connection configuration.
		 */
		private function updateConnectionsArray(connectionsArray : Array) : void {
			
			// remove root level if no disclosure button available
			
			if (!_disclosureButton) {
				connectionsArray.splice(0, 1);

				// at root level we never have a left connector
				
				connectionsArray[0] -= (connectionsArray[0] & (Connector.LEFT));
			}
			
			// do not show top/bottom connections at root
			// if no disclosure button is present we ignore showAtRoot
			// since in the first level we have icons then rather than
			// buttons, and we want to see icon connectors.

			if (!getStyle(style_connectorAtRootLevel) && _disclosureButton) {
				
				if (data.treeNodeState == TreeNodeState.LEAF || !_disclosureButton) {
					connectionsArray[0] = 0;
				} else {
					connectionsArray[0] -= (connectionsArray[0] & (Connector.TOP + Connector.BOTTOM));
				}
				
			}
			
			// do not show right connection at 0 if only a sole item is present 
			if (data.level == 0
				&& data.treeNodeState == TreeNodeState.LEAF
				&& data.isFirstItemInBranch
				&& data.isLastItemInBranch
			) {
				connectionsArray[0] -= (connectionsArray[0] & (Connector.RIGHT));
			}
			
			// do not show connections at button
			
			var indexBeforeLast : uint = connectionsArray.length - 2;
			
			if (data.treeNodeState != TreeNodeState.LEAF) {
				if (!getStyle(style_connectorAtButton) && _disclosureButton) {
					if (_extendedHeight) {
						connectionsArray[indexBeforeLast] -= (connectionsArray[indexBeforeLast]  & (Connector.TOP + Connector.RIGHT + Connector.LEFT));
					} else {
						connectionsArray[indexBeforeLast]  = 0;
					}
				}
			}

			var indexLast : uint = connectionsArray.length - 1;
			
			// do not show connections at icon

			if (!getStyle(style_connectorAtIcon)) {
				if (_extendedHeight && _icon) {
					connectionsArray[indexLast] -= (connectionsArray[indexLast] & (Connector.TOP + Connector.RIGHT + Connector.LEFT));
				} else {
					connectionsArray[indexLast] = 0;
				}
			}
			
		}

		/*
		 * TreeNodeRenderer events
		 */
		
		/**
		 * Handler for the connection changed event.
		 */
		private function connectionChangedHandler(event : TreeNodeRendererEvent) : void {
			invalidateProperty(UPDATE_PROPERTY_CONNECTIONS);
		}
		
	}
}

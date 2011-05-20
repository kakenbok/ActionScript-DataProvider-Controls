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
	import com.sibirjak.asdpc.listview.core.IListItemRenderer;
	import com.sibirjak.asdpc.listview.renderer.ListItemIcon;
	import com.sibirjak.asdpc.treeview.constants.TreeNodeState;
	import com.sibirjak.asdpc.treeview.core.TreeNodeRendererData;
	import com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent;
	
	/*
	 * Styles
	 */

	/**
	 * @copy DirectoryIconStyles#branchClosedIconSkin
	 */
	[Style(name="directoryIcon_branchClosedIconSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy DirectoryIconStyles#branchOpenIconSkin
	 */
	[Style(name="directoryIcon_branchOpenIconSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy DirectoryIconStyles#leafIconSkin
	 */
	[Style(name="directoryIcon_leafIconSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy DirectoryIconStyles#branchClosedIconSkinName
	 */
	[Style(name="directoryIcon_branchClosedIconSkinName", type="String", enumeration="branchClosedIconSkin, branchOpenIconSkin, leafIconSkin")]

	/**
	 * @copy DirectoryIconStyles#branchOpenIconSkinName
	 */
	[Style(name="directoryIcon_branchOpenIconSkinName", type="String", enumeration="branchClosedIconSkin, branchOpenIconSkin, leafIconSkin")]

	/**
	 * @copy DirectoryIconStyles#leafIconSkinName
	 */
	[Style(name="directoryIcon_leafIconSkinName", type="String", enumeration="branchClosedIconSkin, branchOpenIconSkin, leafIconSkin")]

	/**
	 * Tree node icon.
	 * 
	 * @author jes 05.08.2009
	 */
	public class DirectoryIcon extends ListItemIcon {
		
		/* style declarations */

		/**
		 * Central accessor to all ListItemIcon style property definitions.
		 */
		public static var style : DirectoryIconStyles = new DirectoryIconStyles();

		/* constants */

		/**
		 * Name constant for the closed branch icon skin.
		 */
		public static const BRANCH_CLOSED_ICON_SKIN_NAME : String = "branchClosedIconSkin";

		/**
		 * Name constant for the open branch icon skin.
		 */
		public static const BRANCH_OPEN_ICON_SKIN_NAME : String = "branchOpenIconSkin";

		/**
		 * Name constant for the leaf node icon skin.
		 */
		public static const LEAF_ICON_SKIN_NAME : String = "leafIconSkin";

		/* changeable properties or styles */

		/**
		 * Name constant for the icon name invalidation property.
		 */
		private const UPDATE_PROPERTY_ICON_NAME : String = "icon_name";

		/* internal */

		/**
		 * State to icon name map.
		 */
		private var _stateIconNameMap : Object;

		/* assets */

		/**
		 * Default closed branch node icon skin.
		 */
		[Embed(source="assets/folder.png")]
		private var _branchClosedIcon : Class;

		/**
		 * Default open branch node icon skin.
		 */
		[Embed(source="assets/folder_open.png")]
		private var _branchOpenIcon : Class;

		/**
		 * Default leaf node icon skin.
		 */
		[Embed(source="assets/document.png")]
		private var _leafIcon : Class;

		/**
		 * DirectoryIcon constructor.
		 */
		public function DirectoryIcon() {

			setDefaultStyles([

				style.branchClosedIconSkin, _branchClosedIcon,
				style.branchOpenIconSkin, _branchOpenIcon,
				style.leafIconSkin, _leafIcon,
		
				style.branchClosedIconSkinName, BRANCH_CLOSED_ICON_SKIN_NAME,
				style.branchOpenIconSkinName, BRANCH_OPEN_ICON_SKIN_NAME,
				style.leafIconSkinName, LEAF_ICON_SKIN_NAME,

				style.iconSkin, null // overriden
			]);

			_stateIconNameMap = new Object();
		}
		
		/*
		 * ListItemIcon protected
		 */

		/**
		 * @inheritDoc
		 */
		override public function set listItemRenderer(listItemRenderer : IListItemRenderer) : void {
			super.listItemRenderer = listItemRenderer;
			
			_listItemRenderer.addEventListener(TreeNodeRendererEvent.TREE_NODE_STATE_CHANGED, stateChangeHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getIconSkin() : Class {
			var iconSkin : Class;

			if (_iconSkinFunction != null) {
				iconSkin = _iconSkinFunction(data.listItemData);
			}
			
			if (iconSkin == null) {
				iconSkin = _iconSkin;
			}
			
			if (iconSkin == null) {
				var iconSkinName : String = _stateIconNameMap[TreeNodeRendererData(data).treeNodeState];
				iconSkin = getStyle(style[iconSkinName]);
			}
			
			return iconSkin;
		}
		
		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		override protected function init() : void {
			super.init();
			
			// state icon name mapping
			_stateIconNameMap[TreeNodeState.BRANCH_OPEN] = getStyle(style.branchOpenIconSkinName);
			_stateIconNameMap[TreeNodeState.BRANCH_CLOSED] = getStyle(style.branchClosedIconSkinName);
			_stateIconNameMap[TreeNodeState.LEAF] = getStyle(style.leafIconSkinName);
		}

		/**
		 * @inheritDoc
		 */
		override protected function styleChanged(property : String, value : *) : void {
			if (property.indexOf("directoryIcon_") == 0) {
				if (property.indexOf("IconSkinName") > -1) {
					invalidateProperty(UPDATE_PROPERTY_ICON_NAME);
	
				} else if (property.indexOf("IconSkin") > -1) {
					invalidateProperty(UPDATE_PROPERTY_ICON);
				}	

			} else {
				super.styleChanged(property, value);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function cleanUpCalled() : void {
			super.cleanUpCalled();

			_listItemRenderer.removeEventListener(TreeNodeRendererEvent.TREE_NODE_STATE_CHANGED, stateChangeHandler);
		}

		/*
		 * Private
		 */

		/**
		 * State change event handler.
		 */
		private function stateChangeHandler(event : TreeNodeRendererEvent) : void {
			showIconSkin();
		}

	}
}

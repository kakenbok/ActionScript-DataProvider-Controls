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
package com.sibirjak.asdpc.treeview.interfacedemo.windows.data {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.common.dataprovider.IItem;
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.core.dataprovider.genericToStringFunction;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.data.DataWindowContent;
	import com.sibirjak.asdpc.treeview.TreeView;
	import com.sibirjak.asdpc.treeview.TreeViewInterfaceDemo;
	import com.sibirjak.asdpc.treeview.renderer.DirectoryIcon;
	import com.sibirjak.asdpcbeta.window.core.WindowPosition;

	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author jes 12.01.2010
	 */
	public class TreeViewDataWindowContent extends DataWindowContent {

		private var _xmlButton : Button;

		public function TreeViewDataWindowContent(view : IView) {
			super(view);
		}

		override protected function viewStyleChanged(property : String, value : *) : void {

			if (
				property == DirectoryIcon.style.branchOpenIconSkin
				|| property == DirectoryIcon.style.branchClosedIconSkin
				|| property == DirectoryIcon.style.leafIconSkin
			) {
				_listBuilder.setStyle(property, value);
			}

		}

		override protected function getListBuilderClass() : Class {
			return TreeView;
		}
		
		override protected function getContentRenderer() : Class {
			return TreeBuilderContentRenderer;
		}
		
		override protected function setListBuilderProperties() : void {
			TreeView(_listBuilder).expandNodeAt(0);
		}

		override protected function getDataSource() : IItem {
 			return TreeViewInterfaceDemo.createDataSource();
		}

		override protected function draw() : void {
			super.draw();

			_inputWindow.title = "Input XML";
			_inputWindow.minimisePosition = new WindowPosition(function() : Point {
				return _xmlButton.localToGlobal(new Point(Math.round(_xmlButton.width / 2), 0));
			});
		}

		override protected function createButtons() : void {
			super.createButtons();

			// input

			_xmlButton = new Button();
			_xmlButton.setSize(22, _buttonSize);
			_xmlButton.setStyles(_buttonStyles);
			_xmlButton.setStyle(Button.style.upIconSkin, IconFactory.getInstance().getIconSkin("xml"));

			_xmlButton.toolTip = "Input xml";

			_xmlButton.addEventListener(ButtonEvent.CLICK, inputButtonClickHandler);
			_buttons.addChild(_xmlButton);

		}
		
		override protected function getClearButtonTip() : String {
			return "Remove children of root";
		}

		override protected function getAddAtStartTip() : String {
			return "Add item as first child of root";
		}
		
		override protected function getAddAtEndTip() : String {
			return "Add item as last child of root";
		}

		override protected function getResetTip() : String {
			return "Replace children of root";
		}

		override protected function setButtonPositions() : void {

			_reverseButton.visible = false;
			_zASortButton.visible = false;
			_aZSortButton.visible = false;
			_inputButton.visible = false;

			_clearButton.x = _width - (_clearButton.width + _buttonPadding);

			_addAtEndButton.x = _clearButton.x - (_addAtEndButton.width + _buttonPadding) - 6;
			_addAtStartButton.x = _addAtEndButton.x - (_addAtStartButton.width + _buttonPadding);
			_resetButton.x = _addAtStartButton.x - (_resetButton.width + _buttonPadding);
			_xmlButton.x = _resetButton.x - (_xmlButton.width + _buttonPadding);
		}

		override protected function addAtStart() : void {
			super.addAtStart();

			if (_listView.getStyle(TreeView.style.showRoot)) TreeView(_listView).expandNodeAt(0);
			TreeView(_listBuilder).expandNodeAt(0);
		}

		override protected function addAtEnd() : void {
			super.addAtEnd();

			if (_listView.getStyle(TreeView.style.showRoot)) TreeView(_listView).expandNodeAt(0);
			TreeView(_listBuilder).expandNodeAt(0);
		}

		override protected function reset() : void {
			super.reset();
			
			if (_listView.getStyle(TreeView.style.showRoot)) TreeView(_listView).expandNodeAt(0);
			TreeView(_listBuilder).expandNodeAt(0);
		}

		override protected function processInputContent(content : String) : Boolean {
			var xml : XML;
			
			try {
				xml = new XML(content);
			} catch (e : Error) {
				_inputWindowDocument.error = e.message;
				return false;
			}
			
			var dataSource : IItem = parseXML(xml);

			_listView.dataSource = dataSource;
			_listBuilder.dataSource = dataSource;

			if (_listView.getStyle(TreeView.style.showRoot)) TreeView(_listView).expandNodeAt(0);
			TreeView(_listBuilder).expandNodeAt(0);
			
			return true;
		}
		
		private function parseXML(xml : XML, parentItem : IItem = null) : IItem {
			
			var item : IItem;
			var isRoot : Boolean;
			
			if (!parentItem) {
				parentItem = TreeViewInterfaceDemo.createDataSource(0, 0);
				isRoot = true;
			}
			
			item = new (getDefinitionByName(getQualifiedClassName(parentItem)))();
			item.name = genericToStringFunction(xml).split("\r").join(" ").split("\n").join("");
			
            var childNode : XML;
            for each(childNode in xml.*) {
            	item.i_nextChildIndex; // increase internal index
                item.i_addItemAtEnd(parseXML(childNode, item));
            }
			
			return item;
			
		}

	}
}

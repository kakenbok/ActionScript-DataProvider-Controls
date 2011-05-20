package com.sibirjak.asdpc.treeview {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.treeview.renderer.DirectoryIcon;

	import flash.display.Sprite;

	public class DynamicIconExample2 extends Sprite {

		[Embed(source="assets/as.png")]
		private var _as : Class;
		[Embed(source="assets/html.png")]
		private var _html : Class;
		[Embed(source="assets/php.png")]
		private var _php : Class;
		[Embed(source="assets/pdf.png")]
		private var _pdf : Class;
		
		private var _treeView : TreeView;
		private	var _endings : Array = ["as", "html", "php", "pdf"];
		private var _itemCount : uint;

		public function DynamicIconExample2() {

			_treeView = new TreeView();
			_treeView.setSize(260, 120);
			_treeView.expandNodeAt(0, true);
			
			var dataSource : DataItem = new DataItem("Files", "");
			dataSource.array = [
				new DataItem("serialz", "txt"),
				new DataItem("asdoc", "pdf"),
				new DataItem("images", "zip"),
				new DataItem("index", "php"),
				new DataItem("contact", "html"),
				new DataItem("popup", "html"),
				new DataItem("main", "as"),
				new DataItem("asdpc", "exe")
			];

			_treeView.dataSource = dataSource;
			_treeView.setStyle(DirectoryIcon.style.iconSkinFunction, createIconFunction());
			addChild(_treeView);
			
			var button : Button = new Button();
			button.setSize(100, 20);
			button.moveTo(10, 140);
			button.label = "data item event";
			button.addEventListener(ButtonEvent.CLICK, setItemNameWithEvent);
			addChild(button);

			button = new Button();
			button.setSize(100, 20);
			button.moveTo(130, 140);
			button.label = "set icon function";
			button.addEventListener(ButtonEvent.CLICK, setIconFunction);
			addChild(button);

			button = new Button();
			button.setSize(100, 20);
			button.moveTo(250, 140);
			button.label = "add item";
			button.addEventListener(ButtonEvent.CLICK, addItem);
			addChild(button);
		}
		
		private function setItemNameWithEvent(event : ButtonEvent) : void {
			if (!_treeView.selectedItemData) return;
			
			var dataItem : DataItem = _treeView.selectedItemData.item as DataItem;
			dataItem.setExtensionWithEvent(createNewExtension(dataItem.extension));
		}

		private function setIconFunction(event : ButtonEvent) : void {
			if (!_treeView.selectedItemData) return;
			
			var dataItem : DataItem = _treeView.selectedItemData.item as DataItem;
			dataItem.setExtensionWithoutEvent(createNewExtension(dataItem.extension));

			_treeView.setStyle(DirectoryIcon.style.iconSkinFunction, createIconFunction());
		}
		
		private function addItem(event : ButtonEvent) : void {
			if (!_treeView.selectedItemData) return;

			var dataItem : DataItem = new DataItem("New item " + ++_itemCount, createNewExtension("..."));
			var dataSource : DataItem = _treeView.dataSource as DataItem;
			dataSource.addAt(_treeView.selectedIndex, dataItem);
		}

		private function createIconFunction() : Function {
			return function (data : TreeNodeData) : Class {
				switch (DataItem(data.item).extension) {
					case "as":
						return _as;
					case "php":
						return _php;
					case "pdf":
						return _pdf;
					case "html":
						return _html;
				}
				return null;
			};
		}
		
		private function createNewExtension(oldExtension : String) : String {
			if (!oldExtension) return oldExtension; // for the "Files" item
			var newExtension : String = oldExtension;
			while (oldExtension == newExtension) {
				newExtension = _endings[Math.round(Math.random() * 3)];
			}
			return newExtension;
		}
		
	}
}

import org.as3commons.collections.fx.ArrayListFx;

import flash.events.Event;

internal class DataItem extends ArrayListFx {
	
	private var _name : String;
	private var _extension : String;

	public function DataItem(name : String, extension : String) {
		_name = name;
		_extension = extension;
	}
	
	public function setExtensionWithEvent(extension : String) : void {
		_extension = extension;
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	public function setExtensionWithoutEvent(extension : String) : void {
		_extension = extension;
	}

	public function get name() : String {
		return _name;
	}
	
	public function get extension() : String {
		return _extension;
	}
}
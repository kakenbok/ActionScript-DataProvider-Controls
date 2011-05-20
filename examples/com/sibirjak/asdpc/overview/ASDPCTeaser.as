package com.sibirjak.asdpc.overview {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.common.Example;
	import com.sibirjak.asdpc.common.dataprovider.ArrayListItem;
	import com.sibirjak.asdpc.common.dataprovider.IItem;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.listview.ListView;
	import com.sibirjak.asdpc.textfield.TextInput;
	import com.sibirjak.asdpc.textfield.TextInputEvent;
	import com.sibirjak.asdpc.tooltip.ToolTip;
	import com.sibirjak.asdpc.treeview.TreeView;
	import com.sibirjak.asdpcbeta.checkbox.CheckBox;
	import com.sibirjak.asdpcbeta.colorpicker.ColorPicker;
	import com.sibirjak.asdpcbeta.layout.HLayout;
	import com.sibirjak.asdpcbeta.layout.VLayout;
	import com.sibirjak.asdpcbeta.radiobutton.RadioButton;
	import com.sibirjak.asdpcbeta.radiobutton.RadioGroup;
	import com.sibirjak.asdpcbeta.scrollbar.ScrollPane;
	import com.sibirjak.asdpcbeta.selectbox.SelectBox;
	import com.sibirjak.asdpcbeta.slider.Slider;
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.core.WindowPosition;

	import flash.display.DisplayObject;
	import flash.display.Shape;

	/**
	 * @author jes 01.02.2010
	 */
	public class ASDPCTeaser extends Example {

		[Embed(source="assets/dresden.jpg")]
		private var _dresden : Class;
		
		public function ASDPCTeaser() {
			
			ToolTip.enabled = false;
			
			addChild(
			
				vLayout(
				
					hLayout(
						selectBox(),
						
						button(),
						toggleButton(),
						checkBox(),

						radioGroup(
							radioButton({
								selected: true,
								value: "On",
								label: "On"
							}),
							radioButton({
								selected: false,
								value: "Off",
								label: "Off"
							})
						),

						textInput(),
						
						slider(),
						
						colorPicker()
					),
					
					hLayout(
						listView(),
						treeView(),
						window()
					
					)
					
					
				
				)
			
			);
			
		}

		private function createTree(depth : uint = 3, parentItem : IItem = null) : IItem {
			if (!parentItem) {
				parentItem = new ArrayListItem();
				parentItem.name = "Item";
			}
			
			var newItem : IItem;
			
			for (var i : int = 0; i < 3; i++) {
				
				newItem = new ArrayListItem();
				newItem.name = parentItem.name + "." + parentItem.i_nextChildIndex;
				parentItem.i_addItemAtEnd(newItem);
				
				if (depth > 1) {
					createTree(depth - 1, newItem);
				}
				
			}
			
			return parentItem;
		}

		private function vLayout(...args) : VLayout {
			var vLayout : VLayout = new VLayout();
			vLayout.setStyle(VLayout.style.itemPadding, 10);
			
			for (var i : int = 0; i < args["length"]; i++) {
				if (args[i] is DisplayObject) vLayout.addChild(args[i]);
			}
			return vLayout;
		}

		private function hLayout(...args) : HLayout {
			var hLayout : HLayout = new HLayout();
			hLayout.setStyle(HLayout.style.itemPadding, 10);
			
			for (var i : int = 0; i < args["length"]; i++) {
				if (args[i] is DisplayObject) hLayout.addChild(args[i]);
			}
			return hLayout;
		}

		private function listView() : ListView {
			var listView : ListView = new ListView();
			listView.setSize(120, 200);
			listView.dataSource = new ListDataSource(50);
			return listView;
		}

		private function treeView() : TreeView {
			var treeView : TreeView = new TreeView();
			treeView.setSize(180, 200);
			treeView.dataSource = createTree();
			treeView.expandNodeAt(0, true);
			treeView.expandNodeAt(1, true);
			treeView.expandNodeAt(2, true);
			return treeView;
		}

		private function window() : View {
			var scrollPane : ScrollPane = new ScrollPane();
			scrollPane.setStyle(ScrollPane.style.scrollBarSize, 10);
			scrollPane.document = new _dresden();
			
			var window : Window = new Window();
			window.setSize(154, 200);
			window.setStyle(Window.style.padding, 4);
			window.documents = [
				"Tab", new Shape(),
				"Scroll", scrollPane
			];
			window.title = "Window";
			window.minimisePosition = new WindowPosition(73, 40);
			
			var button : Button = new Button();
			button.setSize(18, 18);
			button.setStyles([
				Button.style.upIconSkin, window.getStyle(Window.style.windowIconSkin),
				Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME
			]);
			button.moveTo(73, 40);
			button.addEventListener(ButtonEvent.CLICK, function(event : ButtonEvent) : void {
				window.restorePosition = new WindowPosition(0, 0);
				window.restore();
			});

			var view : View = new View();
			view.setSize(154, 200);
			view.addChild(button);
			view.addChild(window);

			return view;
		}

		private function selectBox() : SelectBox {
			var selectBox : SelectBox = new SelectBox();
			selectBox.setSize(80, 20);
			selectBox.setStyle(SelectBox.style.maxVisibleItems, 5);
			selectBox.dataSource = new ListDataSource(10);
			selectBox.selectItemAt(0);
			return selectBox;
		}
		
		private function button() : Button {
			var button : Button = new Button();
			button.setSize(34, 20);
			button.label = "OK";
			return button;
		}

		private function toggleButton() : Button {
			var button : Button = new Button();
			button.setSize(34, 20);
			button.toggle = true;
			button.selected = true;
			button.label = "Off";
			button.selectedLabel = "On";
			return button;
		}
		
		private function checkBox() : CheckBox {
			var checkBox : CheckBox = new CheckBox();
			checkBox.setSize(38, 16);
			checkBox.setStyle(CheckBox.style_buttonWidth, 16);
			checkBox.setStyle(CheckBox.style_buttonHeight, 16);
			with (checkBox) {
				checkBox.label = "Off"; // label = properties causes confusion with this.label()
				selectedLabel = "On";
				selected = true;
			}
			return checkBox;
		}

		private function radioGroup(...args) : HLayout {
			var layout : HLayout = hLayout.apply(null, args);
			layout.setStyle(HLayout.style.itemPadding, 0);
			
			
			var buttons : Array = new Array();
			
			for (var i : int = 0; i < args["length"]; i++) {
				buttons.push(args[i]);
			}

			var radioGroup : RadioGroup = new RadioGroup();
			radioGroup.setButtons(buttons);

			return layout;
		}

		private function radioButton(properties : Object) : RadioButton {
			var radioButton : RadioButton = new RadioButton();
			with (radioButton) {
				setSize(40, 16);

				radioButton.label = properties["label"]; // label = properties causes confusion with this.label()
				selectedLabel = properties["selectedLabel"];
				
				value = properties["value"];

				if (properties["selected"]) selected = true;
				if (properties["disabled"]) enabled = false;
			}

			return radioButton as RadioButton;
		}

		private function textInput() : TextInput {
			var textInput : TextInput = new TextInput();
			textInput.setSize(54, 20);
			textInput.setStyle(TextInput.style.font, "_typewriter");
			textInput.text = "Input";
			
			textInput.addEventListener(TextInputEvent.FOCUS_IN, function(event : TextInputEvent) : void {
				textInput.setSelection(0, textInput.text.length);
				textInput.scrollTo(0);
			});
			
			return textInput;
		}

		private function slider() : Slider {
			var slider : Slider = new Slider();
			slider.setSize(64, 16);
			with (slider) {
				value = 20;
				minValue = 0;
				maxValue = 100;
				snapInterval = 5;
			}
			return slider;
		}

		private function colorPicker() : ColorPicker {
			var colorPicker : ColorPicker = new ColorPicker();
			colorPicker.selectedColor = 0xFF0000;
			return colorPicker;
		}
	}
}

import org.as3commons.collections.framework.IDataProvider;

internal class ListDataSource implements IDataProvider {

	private var _numItems : uint;
	
	public function ListDataSource(numItems : uint) {
		_numItems = numItems;
	}
	
	public function itemAt(index : uint) : * {
		return "Item " + (index + 1);
	}
	
	public function get size() : uint {
		return _numItems;
	}
}

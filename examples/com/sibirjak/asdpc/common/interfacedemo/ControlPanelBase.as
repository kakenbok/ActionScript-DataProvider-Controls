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
package com.sibirjak.asdpc.common.interfacedemo {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.common.iconselector.IconSelector;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.constants.Position;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpcbeta.checkbox.CheckBox;
	import com.sibirjak.asdpcbeta.colorpicker.ColorPicker;
	import com.sibirjak.asdpcbeta.layout.AbstractLayout;
	import com.sibirjak.asdpcbeta.layout.HLayout;
	import com.sibirjak.asdpcbeta.layout.VLayout;
	import com.sibirjak.asdpcbeta.radiobutton.RadioButton;
	import com.sibirjak.asdpcbeta.radiobutton.RadioGroup;
	import com.sibirjak.asdpcbeta.slider.Slider;

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.framework.IIterator;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * @author jes 03.12.2009
	 */
	public class ControlPanelBase extends View {

		protected var _view : IView;
		protected var _radioGroups : LinkedMap;
		private var _viewIDs : LinkedMap;
		
		private const LABEL_SIZE : uint = 110;

		protected const DOCUMENT : String = "document";

		public function ControlPanelBase() {
			_radioGroups = new LinkedMap(); 
			_viewIDs = new LinkedMap(); 
		}

		public function get view() : IView {
			return _view;
		}
		
		public function set view(view : IView) : void {
			_view = view;
			_view.addEventListener(StyleChangeEvent.CHANGE, styleChangeHandler);
		}
		
		/*
		 * View life cycle
		 */

		override protected function initialised() : void {
			
			// create radiogroups
			
			var iterator : IIterator = _radioGroups.iterator();
			var radioGroupEntry : Array;
			while (iterator.hasNext()) {
				radioGroupEntry = iterator.next();
				RadioGroup(radioGroupEntry[0]).setButtons(radioGroupEntry[1]);
			}

			viewVisibilityChanged();
		}

		/*
		 * Protected
		 */
		
		protected function viewStyleChanged(property : String, value : *) : void {
		}

		protected function setViewVisibility(id : String, visible : Boolean, changeLayout : Boolean = true) : void {
			var view : DisplayObject = _viewIDs.itemFor(id);
			if (view.visible == visible) return;
			
			if (view.parent is AbstractLayout && changeLayout) {
				if (visible) AbstractLayout(view.parent).includeInLayout(view);
				else AbstractLayout(view.parent).excludeFromLayout(view);
				
				AbstractLayout(view.parent).validateNow();
			} else {
				view.visible = visible;
			}
			
			if (_initialised) viewVisibilityChanged();
		}
			
		protected function getView(id : String) : View {
			return _viewIDs.itemFor(id);
		}
		
		protected function viewVisibilityChanged() : void {
		}
			
		protected function dispatchChange(property : String, value : *) : void {
			if (!_initialised) return;

			_view.dispatchEvent(new StyleChangeEvent(property, value));
		}

		protected function getRadioGroup(name : String) : RadioGroup {
			return _radioGroups.itemFor(name)[0];
		}

		/*
		 * Factories
		 */
		
		protected function vLayout(...args) : VLayout {
			var vLayout : VLayout = new VLayout();
			vLayout.setStyle(AbstractLayout.style.itemPadding, 4);
			
			for (var i : int = 0; i < args["length"]; i++) {
				// id
				if (args[i] is String) {
					_viewIDs.add(args[i], vLayout);
				}
				// visible component
				if (args[i] is DisplayObject) vLayout.addChild(args[i]);
			}
			return vLayout;
		}

		protected function document(...args) : VLayout {
			var layout : VLayout = vLayout.apply(null, args);
			layout.y = 8;

			_viewIDs.add(DOCUMENT, layout);

			return layout;
		}
		
		protected function hLayout(...args) : HLayout {
			var hLayout : HLayout = new HLayout();
			hLayout.setStyle(AbstractLayout.style.itemPadding, 4);
			
			for (var i : int = 0; i < args["length"]; i++) {
				// id
				if (args[i] is String) {
					_viewIDs.add(args[i], hLayout);
				}
				// visible component
				if (args[i] is DisplayObject) hLayout.addChild(args[i]);
			}
			return hLayout;
		}

		protected function iconSelector(properties : Object) : IconSelector {
			var iconSelector : IconSelector = new IconSelector();
			iconSelector.setSize(20, 20);
			iconSelector.dataSource = getIconList(properties["emptyIcon"]);
			iconSelector.selectedIconSkin = properties["iconSkin"];
			iconSelector.toolTip = properties["tip"];

			iconSelector.bindProperty(IconSelector.BINDABLE_PROPERTY_SELECTED_ICON, properties["change"]);

			register(iconSelector, properties);

			return iconSelector;
		}
		
		private function getIconList(addEmptyIcon : Boolean) : Array {
			var list : Array = IconFactory.getInstance().list;
			if (addEmptyIcon) list.unshift("no_icon");
			return list;
		}

		protected function colorPicker(properties : Object) : ColorPicker {
			var colorPicker : ColorPicker = new ColorPicker();

			colorPicker.setSize(16, 16);
			colorPicker.selectedColor = properties["color"];
			colorPicker.toolTip = properties["tip"];
			colorPicker.bindProperty(ColorPicker.BINDABLE_PROPERTY_SELECTED_COLOR, properties["change"]);

			register(colorPicker, properties);

			return colorPicker;
		}

		protected function headline(labelText : String, diff : int = 0) : Label {
			var label : Label = new Label();
			label.setSize(_width + diff, 18);
			label.text = labelText.toUpperCase();
			label.setStyle(Label.style.bold, true);
			label.setStyle(Label.style.size, 11);
			return label;
		}

		protected function label(labelText : String, diff : int = 0, id : String = "") : Label {
			var label : Label = new Label();
			label.setSize(LABEL_SIZE + diff, 18);
			label.text = labelText;
			label.setStyle(Label.style.verticalAlign, Position.MIDDLE);
			label.setStyle(Label.style.size, 10);

			register(label, {id:id});

			return label;
		}

		protected function sliderWithLabel(properties : Object) : HLayout {
			var label : Label = new Label();
			label.setSize(40, 18);
			label.setStyle(Label.style.verticalAlign, Position.MIDDLE);

			var slider : Slider = new Slider();
			slider.setSize(120, 16);

			slider.value = properties["value"];
			slider.minValue = properties["minValue"];
			slider.maxValue = properties["maxValue"];
			slider.snapInterval = properties["snapInterval"];

			slider.bindProperty(Slider.BINDABLE_PROPERTY_VALUE, properties["change"]);
			slider.bindProperty(Slider.BINDABLE_PROPERTY_VALUE, label, "text");
			
			register(slider, properties);
			
			return hLayout(slider, label);
		}
		
		protected function  button(properties : Object) : Button {

			var button : Button = new Button();
			button.setSize(14, 14);
			button.toggle = true;
			button.selected = properties["selected"];
			button.label = properties["label"]; // label = properties causes confusion with this.label()
			if (properties["iconSkin"]) {
				button.setStyles([
					Button.style.upIconSkin, properties["iconSkin"],
					Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
					Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME,
					Button.style.selectedUpIconSkinName, Button.UP_ICON_SKIN_NAME,
					Button.style.selectedOverIconSkinName, Button.UP_ICON_SKIN_NAME,
					Button.style.selectedDownIconSkinName, Button.UP_ICON_SKIN_NAME
				]);
			}
			button.toolTip = properties["tip"];
			button.selectedToolTip = properties["selectedTip"];

			if (properties["change"]) button.bindProperty(Button.BINDABLE_PROPERTY_SELECTED, properties["change"]);

			register(button, properties);

			return button;
		}

		protected function checkBox(properties : Object) : CheckBox {
			var checkBox : CheckBox = new CheckBox();

			var width : uint = 14;
			if (properties["label"]) width = LABEL_SIZE - 2;
			else if (properties["icon"]) width += DisplayObject(properties["icon"]).width + 9;
			
			if (properties["diff"]) width += properties["diff"];

			checkBox.setSize(width, 18);
			
			checkBox.setStyle(CheckBox.style_buttonWidth, 14);
			checkBox.setStyle(CheckBox.style_buttonHeight, 14);

			if (properties["labelPosition"]) {
				checkBox.setStyle(CheckBox.style_labelPosition, properties["labelPosition"]);
			}

			checkBox.selected = properties["selected"];

			checkBox.label = properties["label"]; // label = properties causes confusion with this.label()
			checkBox.icon = properties["icon"];

			checkBox.toolTip = properties["tip"];
			checkBox.selectedToolTip = properties["selectedTip"];
			
			if (properties["change"]) checkBox.bindProperty(Button.BINDABLE_PROPERTY_SELECTED, properties["change"]);
			if (properties["enabled"] != null) checkBox.enabled = properties["enabled"];
			
			register(checkBox, properties);

			return checkBox;
		}
		
		protected function radioGroup(name : String, change : Function) : void {
			var radioGroup : RadioGroup = new RadioGroup();
			radioGroup.bindProperty(RadioGroup.BINDABLE_PROPERTY_SELECTED_VALUE, change);
			_radioGroups.add(name, [radioGroup]);
		}
		
		protected function radioButton(properties : Object) : RadioButton {
			var radioButton : RadioButton = new RadioButton();

			var width : uint = 14;
			if (properties["label"]) width = LABEL_SIZE - 4;
			else if (properties["icon"]) width += DisplayObject(properties["icon"]).width + 9;

			if (properties["diff"]) width += properties["diff"];

			radioButton.setSize(width, 18);

			radioButton.setStyle(CheckBox.style_buttonWidth, 14);
			radioButton.setStyle(CheckBox.style_buttonHeight, 14);
			
			if (properties["labelPosition"]) {
				radioButton.setStyle(CheckBox.style_labelPosition, properties["labelPosition"]);
			}

			radioButton.label = properties["label"]; // label = properties causes confusion with this.label()
			radioButton.icon = properties["icon"];

			radioButton.value = properties["value"];
			radioButton.selected = properties["selected"];
			radioButton.toolTip = properties["tip"];
			
			var radioGroupEntry : Array = _radioGroups.itemFor(properties["group"]);
			if (!radioGroupEntry[1]) {
				radioGroupEntry[1] = new Array();
			}
			(radioGroupEntry[1] as Array).push(radioButton);

			return radioButton;
		}
			
		protected function image(asset : Class) : DisplayObject {
			var view : View = new View();
			var image : DisplayObject = new asset();
			view.setSize(image.width + 4, 18);
			view.addChild(image);
			image.y = Math.round((18 - image.height) / 2);
			
			return view;
		}

		protected function spacer(size : uint = LABEL_SIZE) : DisplayObject {
			var spacer : View = new View();
			spacer.setSize(size, 1);
			return spacer;
		}
		
		protected function vSpacer(size : uint = 4) : DisplayObject {
			var spacer : View = new View();
			spacer.setSize(1, size);
			return spacer;
		}
		
		protected function dottedSeparator(size : uint = 0) : View {
			var separator : View = new View();
			
			var width : uint = size ? size : _width;
			dashHorizontal(0, 0, width);
			
			return separator;

			function dashHorizontal(x : int, y : int, width : int) : void {
				var r1 : Rectangle = new Rectangle(0, 0, 2, 1);
				var r2 : Rectangle = new Rectangle(2, 0, 2, 1);
	
				var horizontalTile : BitmapData = new BitmapData(4, 1, true);
				horizontalTile.fillRect(r1, (0xFF << 24) + 0xCCCCCC);
				horizontalTile.fillRect(r2, 0x00000000);
	
				with (separator.graphics) {
					lineStyle();
					beginBitmapFill(horizontalTile, null, true);
					drawRect(x, y, width, 1);
					endFill();
				}
			}

		}
		
		/*
		 * Private
		 */

		private function styleChangeHandler(event : StyleChangeEvent) : void {
			if (!_initialised) return;
			
			viewStyleChanged(event.property, event.value);
		}
		
		private function register(view : DisplayObject, properties : Object) : void {
			if (properties["id"]) {
				_viewIDs.add(properties["id"], view);
			}
		}

	}
}

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
package com.sibirjak.asdpc.listview.interfacedemo.windows.styles {
	import com.sibirjak.asdpc.common.interfacedemo.ControlPanelBase;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.listview.ListItemData;
	import com.sibirjak.asdpc.listview.renderer.ListItemContent;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpcbeta.checkbox.CheckBox;
	import com.sibirjak.asdpcbeta.colorpicker.ColorPicker;
	import com.sibirjak.asdpcbeta.selectbox.SelectBox;

	import flash.text.Font;

	/**
	 * @author jes 15.12.2009
	 */
	public class LabelTab extends ControlPanelBase {

		/* internal */
		private const LABEL_STYLE_GROUP : String = "labelStyles";

		private const COLOR_PICKER : String = "colorPicker";
		private const UNDERLINE_BOX : String = "underlineBox";
		private const BOLD_BOX : String = "boldBox";

		private const OVER_COLOR_GROUP : String = "overColor";
		private const OVER_COLOR_PICKER : String = "overColorPicker";
		private const OVER_UNDERLINE_BOX : String = "overUnderlineBox";
		private const OVER_BOLD_BOX : String = "overBoldBox";

		private const SELECTED_COLOR_GROUP : String = "selectedColor";
		private const SELECTED_COLOR_PICKER : String = "selectedColorPicker";
		private const SELECTED_UNDERLINE_BOX : String = "selectedUnderlineBox";
		private const SELECTED_BOLD_BOX : String = "selectedBoldBox";

		/* assets */
		[Embed(source="assets/label/text_bold2.png")]
		private var _bold : Class;
		[Embed(source="assets/label/text_underline2.png")]
		private var _underline : Class;

		public function LabelTab(view : IView) {
			super.view = view;
		}

		override protected function draw() : void {

			addChild(
				document(
				
					headline("Label"),

					hLayout(
						label("Font"),
						
						fontSelector()
					),
				
					hLayout(
						label("Size"),
						
						sliderWithLabel({
							value: 9,
							minValue: 6,
							maxValue: 20,
							snapInterval: 1,
							change: setFontSize
						})
					),
				
					vSpacer(),
					
					vLayout(
					
						LABEL_STYLE_GROUP,

						hLayout(
							checkBox({
								selected: true,
								enabled: false,
								label: "Default",
								tip: "Default label styles"
							}),
	
							hLayout(
								colorPicker({
									id : COLOR_PICKER,
									color: 0x666666,
									tip: "Label color",
									change: setLabelStyles
								}),
								
								spacer(6),
	
								checkBox({
									id : UNDERLINE_BOX,
									selected: false,
									icon: new _underline(),
									tip: "Label underline",
									change: setLabelStyles
								}),
								
								checkBox({
									id : BOLD_BOX,
									selected: false,
									icon: new _bold(),
									tip: "Label bold",
									change: setLabelStyles
								})
	
							)
						),
	
						hLayout(
							
							checkBox({
								selected: true,
								label: "Over",
								tip: "Mouse over label styles",
								change: setApplyOverLabelStyles
							}),
	
							hLayout(
								OVER_COLOR_GROUP,
								colorPicker({
									id : OVER_COLOR_PICKER,
									color: 0x444444,
									tip: "Over label color",
									change: setOverLabelStyles
								}),
	
								spacer(6),
	
								checkBox({
									id: OVER_UNDERLINE_BOX,
									selected: false,
									icon: new _underline(),
									tip: "Mouse over label underline",
									change: setOverLabelStyles
								}),
								
								checkBox({
									id: OVER_BOLD_BOX,
									selected: false,
									icon: new _bold(),
									tip: "Mouse over label bold",
									change: setOverLabelStyles
								})
	
							)
	
						),
					
						hLayout(
	
							checkBox({
								selected: true,
								label: "Selected",
								tip: "Selected label styles",
								change: applySelectedLabelStyles
							}),
	
							hLayout(
								SELECTED_COLOR_GROUP,
								colorPicker({
									id : SELECTED_COLOR_PICKER,
									color: 0xFFFFFF,
									tip: "Selected label color",
									change: setSelectedLabelStyles
								}),
	
								spacer(6),
	
								checkBox({
									id: SELECTED_UNDERLINE_BOX,
									selected: false,
									icon: new _underline(),
									tip: "Selected label underline",
									change: setSelectedLabelStyles
								}),
								
								checkBox({
									id: SELECTED_BOLD_BOX,
									selected: false,
									icon: new _bold(),
									tip: "Selected label bold",
									change: setSelectedLabelStyles
								})
	
							)
						)

					)

				) // document
			); // addChild

		}

		override protected function viewVisibilityChanged() : void {
			getView(LABEL_STYLE_GROUP).x = 2;
		}

		/*
		 * Factories
		 */

		private function labelFunction(data : ListItemData) : String {
			return data.item is Font ? Font(data.item).fontName : data.item;
		}
		
		private function fontSelector() : SelectBox {
			var selectBox : SelectBox = new SelectBox();
			selectBox.setSize(160, 18);
			selectBox.setStyle(SelectBox.style.labelFunction, labelFunction);
			selectBox.setStyle(SelectBox.style.maxVisibleItems, 14);
			
			var allFonts : Array = Font.enumerateFonts(true);
			allFonts.sortOn("fontName", Array.CASEINSENSITIVE);
			allFonts = ["_sans", "_serif", "_typewriter"].concat(allFonts);
			selectBox.dataSource = allFonts;
			
			selectBox.liveSelecting = true;
			selectBox.selectItemAt(0);
			selectBox.bindProperty(SelectBox.BINDABLE_PROPERTY_SELECTED_ITEM, setFont);

			return selectBox;
		}

		/*
		 * Binding events
		 */

		private function setFont(item : *) : void {
			var fontName : String = item is Font ? Font(item).fontName : item;
			_view.setStyle(Label.style.font, fontName);
		}

		private function setFontSize(size : uint) : void {
			_view.setStyle(Label.style.size, size);
		}

		// default
		
		private function setLabelStyles(arg : * = null) : void {
			_view.setStyle(ListItemContent.style.labelStyles, [
				Label.style.color, ColorPicker(getView(COLOR_PICKER)).selectedColor,
				Label.style.underline, CheckBox(getView(UNDERLINE_BOX)).selected,
				Label.style.bold, CheckBox(getView(BOLD_BOX)).selected
			]);
		}

		// over

		private function setApplyOverLabelStyles(setOver : Boolean) : void {
			
			if (setOver) {
				setOverLabelStyles();
			} else {
				_view.setStyle(ListItemContent.style.overLabelStyles, null);
			}

			setViewVisibility(OVER_COLOR_GROUP, setOver);
		}

		private function setOverLabelStyles(arg : * = null) : void {
			_view.setStyle(ListItemContent.style.overLabelStyles, [
				Label.style.color, ColorPicker(getView(OVER_COLOR_PICKER)).selectedColor,
				Label.style.underline, CheckBox(getView(OVER_UNDERLINE_BOX)).selected,
				Label.style.bold, CheckBox(getView(OVER_BOLD_BOX)).selected
			]);
		}

		// selected
		
		private function applySelectedLabelStyles(setSelected : Boolean) : void {
			
			if (setSelected) {
				setSelectedLabelStyles();
			} else {
				_view.setStyle(ListItemContent.style.selectedLabelStyles, null);
			}

			setViewVisibility(SELECTED_COLOR_GROUP, setSelected);
		}

		private function setSelectedLabelStyles(arg : * = null) : void {
			_view.setStyle(ListItemContent.style.selectedLabelStyles, [
				Label.style.color, ColorPicker(getView(SELECTED_COLOR_PICKER)).selectedColor,
				Label.style.underline, CheckBox(getView(SELECTED_UNDERLINE_BOX)).selected,
				Label.style.bold, CheckBox(getView(SELECTED_BOLD_BOX)).selected
			]);
		}

	}
}

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
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.common.interfacedemo.ControlPanelBase;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.listview.ListViewInterfaceDemo;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;
	import com.sibirjak.asdpcbeta.colorpicker.ColorPicker;

	/**
	 * @author jes 15.12.2009
	 */
	public class BackgroundTab extends ControlPanelBase {

		/* internal */

		// default colors
		private const BACKGROUND_COLORS_GROUP : String = "backgroundColors";
		private const BACKGROUND_COLOR_GROUP : String = "defaultBackgroundColor";

		private const EVEN_INDEX_TOP_LEFT_BACKGROUND_COLOR_PICKER : String = "evenIndexTopLeftColorPicker";
		private const EVEN_INDEX_BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER : String = "evenIndexBottomRightColorPicker";
		private const EVEN_INDEX_GRADIENT_BACKGROUND_COLOR_GROUP : String = "evenIndexBackgroundColorGradientGroup";
		private const EVEN_INDEX_GRADIENT_BOX : String = "evenIndexBackgroundColorGradientBox";

		private const ODD_INDEX_TOP_LEFT_BACKGROUND_COLOR_PICKER : String = "oddIndexTopLeftColorPicker";
		private const ODD_INDEX_BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER : String = "oddIndexBottomRightColorPicker";
		private const ODD_INDEX_GRADIENT_BACKGROUND_COLOR_GROUP : String = "oddIndexBackgroundColorGradientGroup";
		private const ODD_INDEX_GRADIENT_BOX : String = "oddIndexBackgroundColorGradientBox";

		// over colors
		private const OVER_BACKGROUND_COLOR_GROUP : String = "overBackgroundColor";
		private const OVER_TOP_LEFT_BACKGROUND_COLOR_PICKER : String = "overTopLeftColorPicker";
		private const OVER_BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER : String = "overBottomRightColorPicker";
		private const OVER_GRADIENT_BACKGROUND_COLOR_GROUP : String = "overBackgroundColorGradientGroup";
		private const OVER_GRADIENT_BOX : String = "overBackgroundColorGradientBox";

		// selected colors
		private const SELECTED_BACKGROUND_COLOR_GROUP : String = "selectedBackgroundColor";
		private const SELECTED_TOP_LEFT_BACKGROUND_COLOR_PICKER : String = "selectedTopLeftColorPicker";
		private const SELECTED_BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER : String = "selectedBottomRightColorPicker";
		private const SELECTED_GRADIENT_BACKGROUND_COLOR_GROUP : String = "selectedBackgroundColorGradientGroup";
		private const SELECTED_GRADIENT_BOX : String = "selectedBackgroundColorGradientBox";


		private const SEPARATOR_PROPERTIES : String = "separatorProperties";

		/* assets */
		[Embed(source="assets/background/background_content.png")]
		private var _backgroundContentArea : Class;
		[Embed(source="assets/background/background_full.png")]
		private var _backgroundItem : Class;

		[Embed(source="assets/background/gradient.png")]
		private var _gradient : Class;

		[Embed(source="assets/scrollbar/background_topleft.png")]
		private var _topLeftBackground : Class;
		[Embed(source="assets/scrollbar/background_bottomright.png")]
		private var _bottomRightBackground : Class;

		public function BackgroundTab(view : IView) {
			super.view = view;
		}

		override protected function draw() : void {

			addChild(
				document(
				
					headline("Application"),
					
					hLayout(
						label("Background"),

						colorPicker({
							color: 0xFFFFFF,
							tip: "Application background color",
							change: setBackgroundColor
						})
					),

					vSpacer(),
					
					dottedSeparator(),
					
					headline("Item"),

					vLayout(
					
						hLayout(
						
							label("Type"),
							
							radioGroup("backgroundType", setBackgroundType),
				
							radioButton({
								group: "backgroundType",
								value: ListItemRenderer.BACKGROUND_LIST_ITEM,
								selected: false,
								icon: new _backgroundItem(),
								tip: "Background behind the entire item"
							}),
	
							radioButton({
								group: "backgroundType",
								value: ListItemRenderer.BACKGROUND_CONTENT,
								selected: true,
								icon: new _backgroundContentArea(),
								tip: "Background behind the item content"
							})
	
						),
					
						vSpacer(),
						
						vLayout(
						
							BACKGROUND_COLORS_GROUP,
						
							hLayout(
								checkBox({
									selected: true,
									label: "Default",
									diff: -28,
									tip: "Default background",
									change: setShowDefaultBackground
								})
							),

							vLayout(
								BACKGROUND_COLOR_GROUP,
	
								hLayout(
								
									spacer(14),
	
									label("Even index", -20),
									
									button({
										id: EVEN_INDEX_GRADIENT_BOX,
										selected: false,
										iconSkin: _gradient,
										tip: "Gradient",
										change: setEvenIndexBackgroundGradient
									}),
									
									spacer(4),
									
									colorPicker({
										id: EVEN_INDEX_TOP_LEFT_BACKGROUND_COLOR_PICKER,
										color: 0xF8F8F8,
										tip: "Even index top background color",
										change: setEvenIndexBackgroundColors
									}),
									
	
									hLayout (
									
										EVEN_INDEX_GRADIENT_BACKGROUND_COLOR_GROUP,
										
										image(_topLeftBackground),
										
										colorPicker({
											id: EVEN_INDEX_BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER,
											color: 0xF8F8F8,
											tip: "Even index bottom background color",
											change: setEvenIndexBackgroundColors
										}),
										
										image(_bottomRightBackground)
									)
	
								),
								
								hLayout(
								
									spacer(14),
	
									label("Odd index", -20),
									
									button({
										id: ODD_INDEX_GRADIENT_BOX,
										selected: false,
										iconSkin: _gradient,
										tip: "Gradient",
										change: setOddIndexBackgroundGradient
									}),
	
									spacer(4),
									
									colorPicker({
										id: ODD_INDEX_TOP_LEFT_BACKGROUND_COLOR_PICKER,
										color: 0xFFFFFF,
										tip: "Odd index top background color",
										change: setOddIndexBackgroundColors
									}),
	
									hLayout (
									
										ODD_INDEX_GRADIENT_BACKGROUND_COLOR_GROUP,
										
										image(_topLeftBackground),
										
										colorPicker({
											id: ODD_INDEX_BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER,
											color: 0xFFFFFF,
											tip: "Odd index top background color",
											change: setOddIndexBackgroundColors
										}),
										
										image(_bottomRightBackground)
									)
									
								)
							),
							
							vLayout(
	
								hLayout(
									checkBox({
										selected: true,
										label: "Over",
										tip: "Mouse over background",
										change: setHighlightBackgroundUnderMouse
									}),
										
								
									hLayout(
										OVER_BACKGROUND_COLOR_GROUP,

										button({
											id: OVER_GRADIENT_BOX,
											selected: false,
											iconSkin: _gradient,
											tip: "Gradient",
											change: setOverBackgroundGradient
										}),
				
										spacer(4),
										
										colorPicker({
											id: OVER_TOP_LEFT_BACKGROUND_COLOR_PICKER,
											color: 0xE0E0E0,
											tip: "Mouse over background top color",
											change: setOverBackgroundColors
										}),
										
										hLayout (
										
											OVER_GRADIENT_BACKGROUND_COLOR_GROUP,
											
											image(_topLeftBackground),
											
											colorPicker({
												id: OVER_BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER,
												color: 0xE0E0E0,
												tip: "Mouse over background bottom color",
												change: setOverBackgroundColors
											}),
											
											image(_bottomRightBackground)
										)
										
									)
								),
			
								hLayout(
									checkBox({
										selected: true,
										label: "Selected",
										tip: "Selected background",
										change: setHighlightSelectedBackground
									}),
										
									hLayout(
										SELECTED_BACKGROUND_COLOR_GROUP,
										
										button({
											id: SELECTED_GRADIENT_BOX,
											selected: false,
											iconSkin: _gradient,
											tip: "Gradient",
											change: setSelectedBackgroundGradient
										}),
				
										spacer(4),
											
										colorPicker({
											id: SELECTED_TOP_LEFT_BACKGROUND_COLOR_PICKER,
											color: 0xAAAAAA,
											tip: "Selected background top color",
											change: setSelectedBackgroundColors
										}),
										
										hLayout (
										
											SELECTED_GRADIENT_BACKGROUND_COLOR_GROUP,
											
											image(_topLeftBackground),
											
											colorPicker({
												id: SELECTED_BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER,
												color: 0xAAAAAA,
												tip: "Selected background bottom color",
												change: setSelectedBackgroundColors
											}),
											
											image(_bottomRightBackground)
										)
										
									)
								), // selected

								hLayout(
									checkBox({
										selected: false,
										label: "Separator",
										tip: "Separator between items",
										change: setSeparatorVisibility
									}),
										
									spacer(22),
										
									hLayout(
										SEPARATOR_PROPERTIES,
										
										colorPicker({
											color: 0xEEEEEE,
											tip: "Separator color",
											change: setSeparatorColor
										})
										
									)
								) // separator

							) // background colors group
						)
					)
					
				));
		}
		
		override protected function viewVisibilityChanged() : void {
			getView(BACKGROUND_COLORS_GROUP).x = 2;
		}

		// application color

		private function setBackgroundColor(color : uint) : void {
			ListViewInterfaceDemo(stage.getChildAt(0)).backgroundColor = color;
		}

		// background type

		private function setBackgroundType(type : String) : void {
			_view.setStyle(ListItemRenderer.style.backgroundType, type);
		}

		// default background
		
		private function setShowDefaultBackground(show : Boolean) : void {
			if (show) {
				setEvenIndexBackgroundColors();
				setOddIndexBackgroundColors();
			} else {
				_view.setStyle(ListItemRenderer.style.evenIndexBackgroundColors, null); 
				_view.setStyle(ListItemRenderer.style.oddIndexBackgroundColors, null); 
			}

			setViewVisibility(BACKGROUND_COLOR_GROUP, show);
		}

		private function setEvenIndexBackgroundColors(arg : * = null) : void {
			if (Button(getView(EVEN_INDEX_GRADIENT_BOX)).selected) {
				_view.setStyle(ListItemRenderer.style.evenIndexBackgroundColors, [
					ColorPicker(getView(EVEN_INDEX_TOP_LEFT_BACKGROUND_COLOR_PICKER)).selectedColor,
					ColorPicker(getView(EVEN_INDEX_BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER)).selectedColor
				]);
			} else {
				_view.setStyle(ListItemRenderer.style.evenIndexBackgroundColors, [
					ColorPicker(getView(EVEN_INDEX_TOP_LEFT_BACKGROUND_COLOR_PICKER)).selectedColor
				]);
			}
		}

		private function setEvenIndexBackgroundGradient(show : Boolean) : void {
			setViewVisibility(EVEN_INDEX_GRADIENT_BACKGROUND_COLOR_GROUP, show, true);
			
			setEvenIndexBackgroundColors();
		}

		private function setOddIndexBackgroundColors(arg : * = null) : void {
			if (Button(getView(ODD_INDEX_GRADIENT_BOX)).selected) {
				_view.setStyle(ListItemRenderer.style.oddIndexBackgroundColors, [
					ColorPicker(getView(ODD_INDEX_TOP_LEFT_BACKGROUND_COLOR_PICKER)).selectedColor,
					ColorPicker(getView(ODD_INDEX_BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER)).selectedColor
				]);
			} else {
				_view.setStyle(ListItemRenderer.style.oddIndexBackgroundColors, [
					ColorPicker(getView(ODD_INDEX_TOP_LEFT_BACKGROUND_COLOR_PICKER)).selectedColor
				]);
			}
		}

		private function setOddIndexBackgroundGradient(show : Boolean) : void {
			setViewVisibility(ODD_INDEX_GRADIENT_BACKGROUND_COLOR_GROUP, show);
			
			setOddIndexBackgroundColors();
		}

		// over background

		private function setHighlightBackgroundUnderMouse(highlight : Boolean) : void {
			if (highlight) {
				setOverBackgroundColors();
			} else {
				_view.setStyle(ListItemRenderer.style.overBackgroundColors, null);
			}

			setViewVisibility(OVER_BACKGROUND_COLOR_GROUP, highlight);
		}

		private function setOverBackgroundColors(arg : * = null) : void {
			if (Button(getView(OVER_GRADIENT_BOX)).selected) {
				_view.setStyle(ListItemRenderer.style.overBackgroundColors, [
					ColorPicker(getView(OVER_TOP_LEFT_BACKGROUND_COLOR_PICKER)).selectedColor,
					ColorPicker(getView(OVER_BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER)).selectedColor
				]);
			} else {
				_view.setStyle(ListItemRenderer.style.overBackgroundColors, [
					ColorPicker(getView(OVER_TOP_LEFT_BACKGROUND_COLOR_PICKER)).selectedColor
				]);
			}
		}

		private function setOverBackgroundGradient(show : Boolean) : void {
			setViewVisibility(OVER_GRADIENT_BACKGROUND_COLOR_GROUP, show);
			
			setOverBackgroundColors();
		}

		// selected background
		
		private function setHighlightSelectedBackground(highlight : Boolean) : void {
			if (highlight) {
				setSelectedBackgroundColors();
			} else {
				_view.setStyle(ListItemRenderer.style.selectedBackgroundColors, null);
			}

			setViewVisibility(SELECTED_BACKGROUND_COLOR_GROUP, highlight);
		}

		private function setSelectedBackgroundColors(arg : * = null) : void {
			if (Button(getView(SELECTED_GRADIENT_BOX)).selected) {
				_view.setStyle(ListItemRenderer.style.selectedBackgroundColors, [
					ColorPicker(getView(SELECTED_TOP_LEFT_BACKGROUND_COLOR_PICKER)).selectedColor,
					ColorPicker(getView(SELECTED_BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER)).selectedColor
				]);
			} else {
				_view.setStyle(ListItemRenderer.style.selectedBackgroundColors, [
					ColorPicker(getView(SELECTED_TOP_LEFT_BACKGROUND_COLOR_PICKER)).selectedColor
				]);
			}

		}

		private function setSelectedBackgroundGradient(show : Boolean) : void {
			setViewVisibility(SELECTED_GRADIENT_BACKGROUND_COLOR_GROUP, show);
			
			setSelectedBackgroundColors();
		}

		// separator

		private function setSeparatorVisibility(visible : Boolean) : void {
			_view.setStyle(ListItemRenderer.style.separator, visible);

			setViewVisibility(SEPARATOR_PROPERTIES, visible);
		}

		private function setSeparatorColor(color : uint) : void {
			_view.setStyle(ListItemRenderer.style.separatorColor, color);
		}
	}
}

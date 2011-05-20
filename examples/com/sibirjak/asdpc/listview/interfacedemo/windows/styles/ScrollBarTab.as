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
	import com.sibirjak.asdpc.button.skins.ButtonSkin;
	import com.sibirjak.asdpc.common.interfacedemo.ControlPanelBase;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.scrollbar.skins.ScrollButtonIconSkin;
	import com.sibirjak.asdpc.scrollbar.skins.ScrollThumbIconSkin;
	import com.sibirjak.asdpc.scrollbar.skins.ScrollTrackSkin;
	import com.sibirjak.asdpcbeta.colorpicker.ColorPicker;

	import mx.utils.ColorUtil;

	/**
	 * @author jes 17.12.2009
	 */
	public class ScrollBarTab extends ControlPanelBase {

		/* internal */
		private const TOP_LEFT_BORDER_COLOR_PICKER : String = "topLeftBorder";
		private const TOP_LEFT_BACKGROUND_COLOR_PICKER : String = "topLeftBackground";
		private const BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER : String = "bottomRightBackground";
		private const BOTTOM_RIGHT_BORDER_COLOR_PICKER : String = "bottomRightBorder";

		/* assets */
		[Embed(source="assets/scrollbar/buttonBorderSolid.png")]
		private var _solidBorder : Class;
		[Embed(source="assets/scrollbar/buttonCornerGap.png")]
		private var _gappedBorder : Class;

		[Embed(source="assets/scrollbar/background_topleft.png")]
		private var _topLeftBackground : Class;
		[Embed(source="assets/scrollbar/background_bottomright.png")]
		private var _bottomRightBackground : Class;
		[Embed(source="assets/scrollbar/border_topleft.png")]
		private var _topLeftBorder : Class;
		[Embed(source="assets/scrollbar/border_bottomright.png")]
		private var _bottomRightBorder : Class;

		public function ScrollBarTab(view : IView) {
			super.view = view;
		}

		override protected function draw() : void {

			addChild(
				document(
				
					headline("Scrollbar"),
					
					hLayout(

						label("Style"),
		
						radioGroup("borderStyle", setBorderStyle),

						radioButton({
							group: "borderStyle",
							value: true,
							selected: true,
							icon: new _gappedBorder(),
							tip: "Gapped button corners"
						}),
					
						radioButton({
							group: "borderStyle",
							value: false,
							selected: false,
							icon: new _solidBorder(),
							tip: "Solid button corners"
						})

					),
	
					vSpacer(),

					dottedSeparator(),
					
					headline("Colors"),
	
					hLayout(
						label("Track"),
						
						colorPicker({
							color: 0xCCCCCC,
							tip: "Track color",
							change: setTrackColor
						})
					),

					hLayout(
						label("Buttons"),
						
						colorPicker({
							id: TOP_LEFT_BORDER_COLOR_PICKER,
							color: 0xCCCCCC,
							tip: "Top left border color",
							change: setBorderColors
						}),
						
						image(_topLeftBorder),

						colorPicker({
							id: TOP_LEFT_BACKGROUND_COLOR_PICKER,
							color: 0xF8F8F8,
							tip: "Top left background color",
							change: setBackgroundColor
						}),

						image(_topLeftBackground),

						colorPicker({
							id: BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER,
							color: 0xE0E0E0,
							tip: "Bottom right background color",
							change: setBackgroundColor
						}),

						image(_bottomRightBackground),

						colorPicker({
							id: BOTTOM_RIGHT_BORDER_COLOR_PICKER,
							color: 0x666666,
							tip: "Bottom right border color",
							change: setBorderColors
						}),

						image(_bottomRightBorder)
					),

					hLayout(
						label("Thumb icon"),
						
						colorPicker({
							color: 0xF8F8F8,
							tip: "Light icon color",
							change: setThumbIconLightColor
						}),
						
						colorPicker({
							color: 0x666666,
							tip: "Dark icon color",
							change: setThumbIconDarkColor
						})
					),

					vSpacer(),

					dottedSeparator(),
						
					headline("Buttons"),

					hLayout(

						label("Icon size"),
		
						sliderWithLabel({
							value: 6,
							minValue: 3,
							maxValue: 16,
							snapInterval: 1,
							change: setScrollButtonIconSize
						})
					),
		
					hLayout(

						label("Icon color"),
						
						colorPicker({
							color: 0x000000,
							tip: "Scroll button icon color",
							change: setButtonIconColor
						})
					)
				)
			);

		}
		
		/*
		 * Binding events
		 */
				
		private function setBorderStyle(cornerRadius : Boolean) : void {
			_view.setStyle(ButtonSkin.style_cornerRadius, cornerRadius ? 1 : 0);
		}

		private function setBackgroundColor(color : uint) : void {
			var topLeftColor : uint = ColorPicker(getView(TOP_LEFT_BACKGROUND_COLOR_PICKER)).selectedColor;
			var bottomRightColor : uint = ColorPicker(getView(BOTTOM_RIGHT_BACKGROUND_COLOR_PICKER)).selectedColor;

			_view.setStyle(ButtonSkin.style_backgroundColors, [topLeftColor, bottomRightColor]);

			_view.setStyle(ButtonSkin.style_overBackgroundColors, [
				ColorUtil.adjustBrightness2(topLeftColor, 60),
				ColorUtil.adjustBrightness2(bottomRightColor, 60)
			]);

			_view.setStyle(ButtonSkin.style_disabledBackgroundColors, [topLeftColor, topLeftColor]);
		}

		private function setBorderColors(color : uint) : void {
			var topLeftColor : uint = ColorPicker(getView(TOP_LEFT_BORDER_COLOR_PICKER)).selectedColor;
			var bottomRightColor : uint = ColorPicker(getView(BOTTOM_RIGHT_BORDER_COLOR_PICKER)).selectedColor;
			_view.setStyle(ButtonSkin.style_borderColors, [topLeftColor, bottomRightColor]);
		}

		private function setTrackColor(trackColor : uint) : void {
			_view.setStyle(ScrollTrackSkin.style_color, trackColor);
		}

		private function setThumbIconLightColor(thumbIconLightColor : uint) : void {
			_view.setStyle(ScrollThumbIconSkin.style_iconLightColor, thumbIconLightColor);
		}

		private function setThumbIconDarkColor(thumbIconDarkColor : uint) : void {
			_view.setStyle(ScrollThumbIconSkin.style_iconDarkColor, thumbIconDarkColor);
		}

		private function setScrollButtonIconSize(size : uint) : void {
			_view.setStyle(ScrollButtonIconSkin.style_iconSize, size);
		}

		private function setButtonIconColor(buttonIconColor : uint) : void {
			_view.setStyle(ScrollButtonIconSkin.style_iconColor, buttonIconColor);
			
			var disabledColor : uint = ColorUtil.adjustBrightness2(buttonIconColor, 60);
			_view.setStyle(ScrollButtonIconSkin.style_disabledIconColor, disabledColor);
		}

	}
}

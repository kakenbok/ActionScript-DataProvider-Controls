package com.sibirjak.asdpc.overview {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.skins.ButtonSkin;
	import com.sibirjak.asdpc.common.Example;
	import com.sibirjak.asdpc.textfield.Label;

	public class StyleExample extends Example {
		public function StyleExample() {

			// button 1

			var button : Button = new Button();
			button.setSize(60, 30);
			button.toggle = true;
			button.label = "Off";
			button.selectedLabel = "On";

			button.setStyle(ButtonSkin.style_backgroundColors, [0xAAAAAA, 0x333333]);
			button.setStyle(ButtonSkin.style_overBackgroundColors, [0xBBBBBB, 0x444444]);
			button.setStyle(ButtonSkin.style_borderColors, [0x999999, 0x000000]);

			button.setStyle(Button.style.labelStyles, [
				Label.style.color, 0xEEEEEE,
				Label.style.underline, false,
				Label.style.size, 12
			]);
			button.setStyle(Button.style.overLabelStyles, [
				Label.style.color, 0xEEEEEE,
				Label.style.underline, true,
				Label.style.size, 12
			]);
			button.setStyle(Button.style.selectedLabelStyles, [
				Label.style.color, 0xEEEEEE,
				Label.style.underline, false,
				Label.style.size, 12
			]);

			addChild(button);

			// button 2

			button = new Button();
			button.setSize(60, 30);
			button.moveTo(80, 0);
			button.toggle = true;
			button.label = "Off";
			button.selectedLabel = "On";
			
			button.setStyles([
				ButtonSkin.style_backgroundColors, [0xFF0000, 0xAA0000],
				ButtonSkin.style_overBackgroundColors, [0xFF0000, 0xDD0000],
				ButtonSkin.style_borderColors, [0xFF0000, 0x990000],
				ButtonSkin.style_cornerRadius, 0,
				
				Button.style.labelStyles, [
					Label.style.color, 0xFFFFFF,
					Label.style.size, 12
				],
				Button.style.overLabelStyles, [
					Label.style.color, 0xFFFFFF,
					Label.style.size, 12
				],
				Button.style.selectedLabelStyles, [
					Label.style.color, 0xFFFFFF,
					Label.style.size, 12
				]
			]);

			addChild(button);
		}
	}
}
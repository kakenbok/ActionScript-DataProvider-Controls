package com.sibirjak.asdpc.common {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	/**
	 * @author jes 03.02.2010
	 */
	public class Example extends Sprite {
		public function Example() {
			
			x = y = 10;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;			

			var background : Background = new Background();
			background.setSize(stage.stageWidth, stage.stageHeight);
			stage.addChildAt(background, 0);
		}
	}
}

import com.sibirjak.asdpc.core.skins.BackgroundSkin;

internal class Background extends BackgroundSkin {
	override protected function border() : Boolean {
		return false;
	}
}
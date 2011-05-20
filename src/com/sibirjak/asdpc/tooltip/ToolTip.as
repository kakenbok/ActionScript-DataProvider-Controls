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
package com.sibirjak.asdpc.tooltip {
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Cubic;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.managers.StageProxy;
	import com.sibirjak.asdpc.tooltip.core.ToolTipLabel;
	import com.sibirjak.asdpc.tooltip.skins.ToolTipSkin;

	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/*
	 * Styles
	 */
	
	/**
	 * @copy ToolTip#style_maxWidth
	 */
	[Style(name="toolTip_maxWidth", type="uint", format="Size")]

	/**
	 * ToolTip component.
	 * 
	 * @author jes 10.12.2009
	 */
	public class ToolTip extends View {

		/*
		 * Static context
		 */

		/**
		 * Single ToolTip instance.
		 */
		private static var _instance : ToolTip;

		/**
		 * Flag, indicates if tooltips are enabled or not.
		 */
		public static var enabled : Boolean = true;

		/**
		 * ToolTip activation/deactivation button, if any. 
		 */
		public static var master : DisplayObject;

		/**
		 * Returns the sole ToolTip instance.
		 * 
		 * @return The sole ToolTip instance.
		 */
		public static function getInstance() : ToolTip {
			if (!_instance) {
				_instance = new ToolTip();
			}
			return _instance;
		}
		
		/* style_declarations */

		/**
		 * Style property defining the max tooltip width.
		 */
		public static const style_maxWidth : String = "toolTip_maxWidth";

		/* properties */
		
		/**
		 * The tooltip owner.
		 */
		private var _owner : DisplayObject;

		/* internals */

		/**
		 * Show/hide tween.
		 */
		private var _tween : GTween;

		/* children */

		/**
		 * Background shadow.
		 */
		private var _shadow : ToolTipSkin;

		/**
		 * Background skin.
		 */
		private var _skin : ToolTipSkin;

		/**
		 * Label.
		 */
		private var _label : ToolTipLabel;
		
		/**
		 * ToolTip constructor.
		 */
		public function ToolTip() {
			
			setDefaultStyles([
				style_maxWidth, 140
			]);
		}
		
		/*
		 * Public
		 */
		
		/**
		 * Shows a tooltip.
		 * 
		 * <p>The left bottom tooltip position is relatively set to the owners
		 * top right positioin with a default offset of (x:4, y-4). It is
		 * possible to specify a different offset.</p>
		 * 
		 * @param owner The tooltip owner.
		 * @param text The tool text.
		 * @param offset The left bottom position offset.
		 */
		public function show(owner : DisplayObject, text : String, offset : Point = null) : void {
			if (!enabled && owner != master) return;
			
			if (!addedToStage) {
				StageProxy.toolTipContainer.addChild(this);
			}
			
			var noseSize : uint = _skin.getStyle(ToolTipSkin.style_noseSize);

			// reset alpha if not updated =
			// keep alpha if switched from hide to show
			if (_owner != owner) alpha = 0;

			_owner = owner;

			if (!offset) offset = new Point(4, -4);

			_label.text = text;
			_label.validateNow();
			
			var newWidth : Number = _label.innerWidth + 6;
			var newHeight : Number = _label.innerHeight + 6;
			_skin.setSize(newWidth, newHeight + noseSize);
			_shadow.setSize(newWidth, newHeight + noseSize);

			_skin.scaleX = _skin.scaleY = 1;
			_skin.moveTo(0, 0);
			_label.moveTo(3, 3);

			var position : Point = _owner.localToGlobal(new Point(0, 0));
			x = position.x + _owner.width + offset.x - noseSize;
			y = position.y + offset.y - _skin.height;
			
			if (y < 2) {
				_skin.scaleY = -1;
				_skin.y = _skin.height;
				_label.y = noseSize + 3;

				y = position.y + _owner.height - offset.y;
			}
			
			if (x + _skin.width > stage.stageWidth - 2) {
				_skin.scaleX = -1;
				_skin.x = _skin.width;

				x = position.x - _skin.width + offset.y + noseSize;
			}
			
			_shadow.x = _skin.x + 3;
			_shadow.y = _skin.y + 3;
			_shadow.scaleX = _skin.scaleX;
			_shadow.scaleY = _skin.scaleY;
			
			/*
			 * Tween in
			 */
			
			var delay : Number = .5;

			// stop old tween, if any 
			if (_tween) {
				_tween.paused = true;
				
				delay = 0; // asap start tweening in
			}

			// dont tween if already hidden
			if (alpha == 1) {
				_tween = null;
				return;
			}

			_tween = new GTween(this, .3);
			_tween.ease = Cubic.easeInOut;
			_tween.delay = delay;
			_tween.setValue("alpha", 1);
			
			_tween.onComplete = function(tween : GTween) : void {
				_tween = null;
			};

		}

		/**
		 * Hides a tooltip.
		 * 
		 * @param owner The owner of the tooltip.
		 */
		public function hide(owner : DisplayObject) : void {
			if (owner != _owner) return;
			
			// stop old tween, if any
			if (_tween) _tween.paused = true;

			// dont tween if already hidden
			if (alpha == 0) {
				_owner = null;
				_tween = null;
				return;
			}
			
			_tween = new GTween(this, .2);
			_tween.ease = Cubic.easeInOut;
			_tween.setValue("alpha", 0);
			
			_tween.onComplete = function(tween : GTween) : void {
				_owner = null;
				_tween = null;
			};
		}
		
		/*
		 * View life cycle
		 */
		
		/**
		 * @inheritDoc
		 */
		protected override function draw() : void {
			blendMode = BlendMode.LAYER;
			
			_shadow = new ToolTipSkin();
			_shadow.setSize(100, 100);
			_shadow.setStyle(ToolTipSkin.style_backgroundColor, 0x000000);
			_shadow.alpha = .1;
			addChild(_shadow);
			
			_skin = new ToolTipSkin();
			_skin.setSize(100, 100);
			addChild(_skin);
			
			_label = new ToolTipLabel();
			_label.setSize(getStyle(style_maxWidth), 20);
			addChild(_label);
		}
		
	}
}

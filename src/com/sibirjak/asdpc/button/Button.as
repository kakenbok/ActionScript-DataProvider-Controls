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
package com.sibirjak.asdpc.button {
	import com.sibirjak.asdpc.button.skins.ButtonSkin;
	import com.sibirjak.asdpc.core.BindableView;
	import com.sibirjak.asdpc.core.DisplayObjectAdapter;
	import com.sibirjak.asdpc.core.constants.Position;
	import com.sibirjak.asdpc.textfield.ILabel;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpc.tooltip.ToolTip;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/*
	 * Styles
	 */
	
	/* Background skin */

	/**
	 * @copy ButtonStyles#upSkin
	 */
	[Style(name="button_upSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ButtonStyles#overSkin
	 */
	[Style(name="button_overSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ButtonStyles#downSkin
	 */
	[Style(name="button_downSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ButtonStyles#disabledSkin
	 */
	[Style(name="button_disabledSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ButtonStyles#selectedUpSkin
	 */
	[Style(name="button_selectedUpSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ButtonStyles#selectedOverSkin
	 */
	[Style(name="button_selectedOverSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ButtonStyles#selectedDownSkin
	 */
	[Style(name="button_selectedDownSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ButtonStyles#selectedDisabledSkin
	 */
	[Style(name="button_selectedDisabledSkin", type="Class", format="DisplayObject")]

	/* State to skin name mapping */

	/**
	 * @copy ButtonStyles#upSkinName
	 */
	[Style(name="button_upSkinName", type="String", enumeration="upSkin, overSkin, downSkin, disabledSkin, selectedUpSkin, selectedOverSkin, selectedDownSkin, selectedDisabledSkin", format="Button skin name")]

	/**
	 * @copy ButtonStyles#overSkinName
	 */
	[Style(name="button_overSkinName", type="String", enumeration="upSkin, overSkin, downSkin, disabledSkin, selectedUpSkin, selectedOverSkin, selectedDownSkin, selectedDisabledSkin", format="Button skin name")]

	/**
	 * @copy ButtonStyles#downSkinName
	 */
	[Style(name="button_downSkinName", type="String", enumeration="upSkin, overSkin, downSkin, disabledSkin, selectedUpSkin, selectedOverSkin, selectedDownSkin, selectedDisabledSkin", format="Button skin name")]

	/**
	 * @copy ButtonStyles#disabledSkinName
	 */
	[Style(name="button_disabledSkinName", type="String", enumeration="upSkin, overSkin, downSkin, disabledSkin, selectedUpSkin, selectedOverSkin, selectedDownSkin, selectedDisabledSkin", format="Button skin name")]

	/**
	 * @copy ButtonStyles#selectedUpSkinName
	 */
	[Style(name="button_selectedUpSkinName", type="String", enumeration="upSkin, overSkin, downSkin, disabledSkin, selectedUpSkin, selectedOverSkin, selectedDownSkin, selectedDisabledSkin", format="Button skin name")]

	/**
	 * @copy ButtonStyles#selectedOverSkinName
	 */
	[Style(name="button_selectedOverSkinName", type="String", enumeration="upSkin, overSkin, downSkin, disabledSkin, selectedUpSkin, selectedOverSkin, selectedDownSkin, selectedDisabledSkin", format="Button skin name")]

	/**
	 * @copy ButtonStyles#selectedDownSkinName
	 */
	[Style(name="button_selectedDownSkinName", type="String", enumeration="upSkin, overSkin, downSkin, disabledSkin, selectedUpSkin, selectedOverSkin, selectedDownSkin, selectedDisabledSkin", format="Button skin name")]

	/**
	 * @copy ButtonStyles#selectedDisabledSkinName
	 */
	[Style(name="button_selectedDisabledSkinName", type="String", enumeration="upSkin, overSkin, downSkin, disabledSkin, selectedUpSkin, selectedOverSkin, selectedDownSkin, selectedDisabledSkin", format="Button skin name")]

	/* Icon skin */

	/**
	 * @copy ButtonStyles#upIconSkin
	 */
	[Style(name="button_upIconSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ButtonStyles#overIconSkin
	 */
	[Style(name="button_overIconSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ButtonStyles#downIconSkin
	 */
	[Style(name="button_downIconSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ButtonStyles#disabledIconSkin
	 */
	[Style(name="button_disabledIconSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ButtonStyles#selectedUpIconSkin
	 */
	[Style(name="button_selectedUpIconSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ButtonStyles#selectedOverIconSkin
	 */
	[Style(name="button_selectedOverIconSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ButtonStyles#selectedDownIconSkin
	 */
	[Style(name="button_selectedDownIconSkin", type="Class", format="DisplayObject")]

	/**
	 * @copy ButtonStyles#selectedDisabledIconSkin
	 */
	[Style(name="button_selectedDisabledIconSkin", type="Class", format="DisplayObject")]

	/* State to icon skin name mapping */

	/**
	 * @copy ButtonStyles#upIconSkinName
	 */
	[Style(name="button_upIconSkinName", type="String", enumeration="upIconSkin, overIconSkin, downIconSkin, disabledIconSkin, selectedUpIconSkin, selectedOverIconSkin, selectedDownIconSkin, selectedDisabledIconSkin", format="Button IconSkin name")]

	/**
	 * @copy ButtonStyles#overIconSkinName
	 */
	[Style(name="button_overIconSkinName", type="String", enumeration="upIconSkin, overIconSkin, downIconSkin, disabledIconSkin, selectedUpIconSkin, selectedOverIconSkin, selectedDownIconSkin, selectedDisabledIconSkin", format="Button IconSkin name")]

	/**
	 * @copy ButtonStyles#downIconSkinName
	 */
	[Style(name="button_downIconSkinName", type="String", enumeration="upIconSkin, overIconSkin, downIconSkin, disabledIconSkin, selectedUpIconSkin, selectedOverIconSkin, selectedDownIconSkin, selectedDisabledIconSkin", format="Button IconSkin name")]

	/**
	 * @copy ButtonStyles#disabledIconSkinName
	 */
	[Style(name="button_disabledIconSkinName", type="String", enumeration="upIconSkin, overIconSkin, downIconSkin, disabledIconSkin, selectedUpIconSkin, selectedOverIconSkin, selectedDownIconSkin, selectedDisabledIconSkin", format="Button IconSkin name")]

	/**
	 * @copy ButtonStyles#selectedUpIconSkinName
	 */
	[Style(name="button_selectedUpIconSkinName", type="String", enumeration="upIconSkin, overIconSkin, downIconSkin, disabledIconSkin, selectedUpIconSkin, selectedOverIconSkin, selectedDownIconSkin, selectedDisabledIconSkin", format="Button IconSkin name")]

	/**
	 * @copy ButtonStyles#selectedOverIconSkinName
	 */
	[Style(name="button_selectedOverIconSkinName", type="String", enumeration="upIconSkin, overIconSkin, downIconSkin, disabledIconSkin, selectedUpIconSkin, selectedOverIconSkin, selectedDownIconSkin, selectedDisabledIconSkin", format="Button IconSkin name")]

	/**
	 * @copy ButtonStyles#selectedDownIconSkinName
	 */
	[Style(name="button_selectedDownIconSkinName", type="String", enumeration="upIconSkin, overIconSkin, downIconSkin, disabledIconSkin, selectedUpIconSkin, selectedOverIconSkin, selectedDownIconSkin, selectedDisabledIconSkin", format="Button IconSkin name")]

	/**
	 * @copy ButtonStyles#selectedDisabledIconSkinName
	 */
	[Style(name="button_selectedDisabledIconSkinName", type="String", enumeration="upIconSkin, overIconSkin, downIconSkin, disabledIconSkin, selectedUpIconSkin, selectedOverIconSkin, selectedDownIconSkin, selectedDisabledIconSkin", format="Button IconSkin name")]

	/* icon */

	/**
	 * @copy ButtonStyles#coloriseIcon
	 */
	[Style(name="button_coloriseIcon", type="Boolean")]

	/**
	 * @copy ButtonStyles#iconColor
	 */
	[Style(name="button_iconColor", type="uint", format="Color")]

	/**
	 * @copy ButtonStyles#disabledIconAlpha
	 */
	[Style(name="button_disabledIconAlpha", type="Number", format="Alpha")]

	/* label */

	/**
	 * @copy ButtonStyles#labelStyles
	 */
	[Style(name="button_labelStyles", type="Array", arrayType="mixed", format="Propery, value, property, value, ...")]

	/**
	 * @copy ButtonStyles#overLabelStyles
	 */
	[Style(name="button_overLabelStyles", type="Array", arrayType="mixed", format="Propery, value, property, value, ...")]

	/**
	 * @copy ButtonStyles#selectedLabelStyles
	 */
	[Style(name="button_selectedLabelStyles", type="Array", arrayType="mixed", format="Propery, value, property, value, ...")]

	/**
	 * @copy ButtonStyles#disabledLabelStyles
	 */
	[Style(name="button_selectedLabelStyles", type="Array", arrayType="mixed", format="Propery, value, property, value, ...")]

	/* Auto repeat */

	/**
	 * @copy ButtonStyles#autoRepeatDelay
	 */
	[Style(name="button_autoRepeatDelay", type="uint", format="Time")]

	/**
	 * @copy ButtonStyles#autoRepeatRate
	 */
	[Style(name="button_autoRepeatRate", type="uint", format="Time")]

	/* Tooltip */

	/**
	 * @copy ButtonStyles#toolTipOffsetX
	 */
	[Style(name="button_toolTipOffsetX", type="uint", format="Position")]

	/**
	 * @copy ButtonStyles#toolTipOffsetY
	 */
	[Style(name="button_toolTipOffsetY", type="uint", format="Position")]

	/*
	 * ButtonEvent
	 */

	/**
	 * @eventType com.sibirjak.asdpc.button.ButtonEvent.ROLL_OVER
	 */
	[Event(name="button_rollOver", type="com.sibirjak.asdpc.button.ButtonEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.button.ButtonEvent.ROLL_OUT
	 */
	[Event(name="button_rollOut", type="com.sibirjak.asdpc.button.ButtonEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.button.ButtonEvent.MOUSE_DOWN
	 */
	[Event(name="button_mouseDown", type="com.sibirjak.asdpc.button.ButtonEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.button.ButtonEvent.CLICK
	 */
	[Event(name="button_click", type="com.sibirjak.asdpc.button.ButtonEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.button.ButtonEvent.MOUSE_UP_OUTSIDE
	 */
	[Event(name="button_mouseUpOutside", type="com.sibirjak.asdpc.button.ButtonEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.button.ButtonEvent.SELECTION_CHANGED
	 */
	[Event(name="button_selectionChanged", type="com.sibirjak.asdpc.button.ButtonEvent")]

	/**
	 * Button component.
	 * 
	 * @author jes 14.07.2009
	 */
	public class Button extends BindableView implements IButton {
		
		/* style declarations */

		/**
		 * Central accessor to all Button style property definitions.
		 */
		public static var style : ButtonStyles = new ButtonStyles();
		
		/* constants */

		/**
		 * Name constant for the bindable property Button.selected.
		 */
		public static const BINDABLE_PROPERTY_SELECTED : String = "selected";

		/**
		 * Name constant for the up skin.
		 */
		public static const UP_SKIN_NAME: String = "upSkin";

		/**
		 * Name constant for the over skin.
		 */
		public static const OVER_SKIN_NAME : String = "overSkin";

		/**
		 * Name constant for the down skin.
		 */
		public static const DOWN_SKIN_NAME : String = "downSkin";

		/**
		 * Name constant for the disabled skin.
		 */
		public static const DISABLED_SKIN_NAME : String = "disabledSkin";

		/**
		 * Name constant for the selected up skin.
		 */
		public static const SELECTED_UP_SKIN_NAME: String = "selectedUpSkin";

		/**
		 * Name constant for the selected over skin.
		 */
		public static const SELECTED_OVER_SKIN_NAME : String = "selectedOverSkin";

		/**
		 * Name constant for the selected down skin.
		 */
		public static const SELECTED_DOWN_SKIN_NAME : String = "selectedDownSkin";

		/**
		 * Name constant for the selected disabled skin.
		 */
		public static const SELECTED_DISABLED_SKIN_NAME : String = "selectedDisabledSkin";

		/**
		 * Name constant for the up icon skin.
		 */
		public static const UP_ICON_SKIN_NAME: String = "upIconSkin";

		/**
		 * Name constant for the over icon skin.
		 */
		public static const OVER_ICON_SKIN_NAME: String = "overIconSkin";

		/**
		 * Name constant for the down icon skin.
		 */
		public static const DOWN_ICON_SKIN_NAME : String = "downIconSkin";

		/**
		 * Name constant for the disabled icon skin.
		 */
		public static const DISABLED_ICON_SKIN_NAME : String = "disabledIconSkin";
		
		/**
		 * Name constant for the selected up icon skin.
		 */
		public static const SELECTED_UP_ICON_SKIN_NAME: String = "selectedUpIconSkin";

		/**
		 * Name constant for the selected over icon skin.
		 */
		public static const SELECTED_OVER_ICON_SKIN_NAME: String = "selectedOverIconSkin";

		/**
		 * Name constant for the selected down icon skin.
		 */
		public static const SELECTED_DOWN_ICON_SKIN_NAME : String = "selectedDownIconSkin";

		/**
		 * Name constant for the selected disabled icon skin.
		 */
		public static const SELECTED_DISABLED_ICON_SKIN_NAME : String = "selectedDisabledIconSkin";

		/**
		 * Name constant for the up state.
		 */
		private static const STATE_UP : String = "up";

		/**
		 * Name constant for the down state.
		 */
		private static const STATE_DOWN : String = "down";

		/**
		 * Name constant for the over state.
		 */
		private static const STATE_OVER : String = "over";

		/**
		 * Name constant for the disabled state.
		 */
		private static const STATE_DISABLED : String = "disabled";

		/**
		 * Name constant for the selected up state.
		 */
		private static const STATE_SELECTED_UP : String = "selectedUp";

		/**
		 * Name constant for the selected down state.
		 */
		private static const STATE_SELECTED_DOWN : String = "selectedDown";

		/**
		 * Name constant for the selected over state.
		 */
		private static const STATE_SELECTED_OVER : String = "selectedOver";

		/**
		 * Name constant for the selected disabled state.
		 */
		private static const STATE_SELECTED_DISABLED : String = "selectedDisabled";

		/* changeable properties or styles */

		/**
		 * Name constant for the label invalidation property.
		 */
		private const UPDATE_PROPERTY_LABEL : String = "label";

		/**
		 * Name constant for the icon invalidation property.
		 */
		private const UPDATE_PROPERTY_ICON : String = "icon";

		/**
		 * Name constant for the state to icon name invalidation property.
		 */
		private const UPDATE_PROPERTY_ICON_NAME : String = "icon_name";

		/**
		 * Name constant for the skin invalidation property.
		 */
		private const UPDATE_PROPERTY_SKIN : String = "skin";

		/**
		 * Name constant for the state to skin name invalidation property.
		 */
		private const UPDATE_PROPERTY_SKIN_NAME : String = "skin_name";
		
		/* properties */

		/**
		 * The text displayed on the button.
		 */
		protected var _labelText : String;

		/**
		 * The text displayed on the button in selected state.
		 */
		private var _selectedLabelText : String;

		/**
		 * Tool tip.
		 */
		private var _toolTip : String;

		/**
		 * Tool tip in selected state.
		 */
		private var _selectedToolTip : String;

		/**
		 * Auto repeat flag.
		 */
		private var _autoRepeat : Boolean = false;

		/**
		 * Toggle button flag.
		 */
		private var _toggle : Boolean = false;

		/**
		 * Selected flag.
		 */
		private var _selected : Boolean = false;

		/**
		 * Enabled flag.
		 */
		private var _enabled : Boolean = true;
		
		/* internals */

		/**
		 * The current button state.
		 */
		private var _state : String = STATE_UP;

		/**
		 * Auto repeat timer.
		 */
		private var _autoRepeatTimer : Timer;

		/**
		 * Mouse down flag.
		 */
		private var _mouseDown : Boolean = false;

		/**
		 * Mouse over flag.
		 */
		private var _over : Boolean = false;

		/**
		 * State to skin name map.
		 */
		private var _stateSkinNameMap : Object;

		/**
		 * Skin name to skin map.
		 */
		private var _skins : Dictionary;

		/**
		 * State to icon name map.
		 */
		private var _stateIconNameMap : Object;

		/**
		 * Icon name to icon map.
		 */
		private var _icons : Dictionary;

		/* children */

		/**
		 * The currently displayed skin.
		 */
		protected var _skin : DisplayObject; // currently displayed skin
		
		/**
		 * The currently displayed icon.
		 */
		protected var _icon : DisplayObject; // currently displayed icon

		/**
		 * The label.
		 */
		protected var _label : ILabel;

		/**
		 * Button constructor.
		 */
		public function Button() {
			
			// default size
			setDefaultSize(40, 20);
			
			// bindable properties
			setBindableProperties([BINDABLE_PROPERTY_SELECTED]);
			
			// default styles
			setDefaultStyles([
				/* background skin */
				style.upSkin, ButtonSkin,
				style.overSkin, ButtonSkin,
				style.downSkin, ButtonSkin,
				style.disabledSkin, ButtonSkin,

				style.selectedUpSkin, ButtonSkin,
				style.selectedOverSkin, ButtonSkin,
				style.selectedDownSkin, ButtonSkin,
				style.selectedDisabledSkin, ButtonSkin,

				/* state to skin name mapping */
				style.upSkinName, UP_SKIN_NAME,
				style.overSkinName, OVER_SKIN_NAME,
				style.downSkinName, DOWN_SKIN_NAME,
				style.disabledSkinName, DISABLED_SKIN_NAME,

				style.selectedUpSkinName, SELECTED_UP_SKIN_NAME,
				style.selectedOverSkinName, SELECTED_OVER_SKIN_NAME,
				style.selectedDownSkinName, SELECTED_DOWN_SKIN_NAME,
				style.selectedDisabledSkinName, SELECTED_DISABLED_SKIN_NAME,

				/* icon */
				style.upIconSkin, null,
				style.overIconSkin, null,
				style.downIconSkin, null,
				style.disabledIconSkin, null,
				
				style.selectedUpIconSkin, null,
				style.selectedOverIconSkin, null,
				style.selectedDownIconSkin, null,
				style.selectedDisabledIconSkin, null,

				style.coloriseIcon, false,
				style.iconColor, 0x666666,
				style.disabledIconAlpha, .4,
				
				/* state to icon name mapping */
				style.upIconSkinName, UP_ICON_SKIN_NAME,
				style.downIconSkinName, DOWN_ICON_SKIN_NAME,
				style.overIconSkinName, OVER_ICON_SKIN_NAME,
				style.disabledIconSkinName, DISABLED_ICON_SKIN_NAME,

				style.selectedUpIconSkinName, SELECTED_UP_ICON_SKIN_NAME,
				style.selectedDownIconSkinName, SELECTED_DOWN_ICON_SKIN_NAME,
				style.selectedOverIconSkinName, SELECTED_OVER_ICON_SKIN_NAME,
				style.selectedDisabledIconSkinName, SELECTED_DISABLED_ICON_SKIN_NAME,

				/* label */
				style.labelStyles, [
					Label.style.color, 0x333333
				],
				style.overLabelStyles, [
					Label.style.color, 0x333333
				],
				style.selectedLabelStyles, [
					Label.style.color, 0x333333
				],
				style.disabledLabelStyles, [
					Label.style.color, 0xBBBBBB
				],

				/* auto repeat */
				style.autoRepeatDelay, 400,
				style.autoRepeatRate, 50,
				
				/* tool tip */
				style.toolTipOffsetX, -4,
				style.toolTipOffsetY, -2
			]);
			
			_stateSkinNameMap = new Object();
			_stateIconNameMap = new Object();

			_skins = new Dictionary();
			_icons = new Dictionary();
			
			mouseChildren = false;

			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		/*
		 * IButton
		 */

		/**
		 * @inheritDoc
		 */
		public function set label(label : String) : void {
			if (_labelText == label) return;
			
			_labelText = label;
			
			invalidateProperty(UPDATE_PROPERTY_LABEL);
		}

		/**
		 * @inheritDoc
		 */
		public function get label() : String {
			return _labelText;
		}

		/**
		 * @inheritDoc
		 */
		public function set selectedLabel(label : String) : void {
			if (_selectedLabelText == label) return;
			
			_selectedLabelText = label;
			
			invalidateProperty(UPDATE_PROPERTY_LABEL);
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedLabel() : String {
			return _selectedLabelText;
		}

		/**
		 * @inheritDoc
		 */
		public function set toolTip(toolTip : String) : void {
			_toolTip = toolTip;

			if (_initialised) {
				// tooltip may change while it is visible
				showToolTip();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedToolTip(toolTip : String) : void {
			_selectedToolTip = toolTip;

			if (_initialised) {
				// tooltip may change while it is visible
				showToolTip();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(enabled : Boolean) : void {
			if (_enabled == enabled) return;
			
			_enabled = enabled;
			
			setState();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get enabled() : Boolean {
			return _enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set toggle(toggle : Boolean) : void {
			// cannot be set at runtime
			if (_initialised) return;

			_toggle = toggle;

			if (_toggle) _autoRepeat = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get toggle() : Boolean {
			return _toggle;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selected(selected : Boolean) : void {
			
			if (!_initialised) {
				_selected = selected;
				return;
			}
			
			if (!_toggle) return;
			
			if (_selected == selected) return;
			
			_selected = selected;
			
			invalidateProperty(UPDATE_PROPERTY_LABEL);

			setState();

			updateBindingsForProperty(BINDABLE_PROPERTY_SELECTED);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selected() : Boolean {
			return _selected;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set autoRepeat(autoRepeat : Boolean) : void {
			if (_toggle) return;

			_autoRepeat = autoRepeat;
		}

		/**
		 * @inheritDoc
		 */
		public function get autoRepeat() : Boolean {
			return _autoRepeat;
		}

		/*
		 * View life cycle
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function init() : void {

			// state skin mapping, can be overridden
			createStateSkinNameMap();

			// state icon mapping, can be overridden
			createStateIconNameMap();
			
			if (_toggle) {
				// auto repeat only for click buttons
				_autoRepeat = false;
			} else {
				// selection only for toggle buttons
				_selected = false;
			}
			
			setState();

		}
		
		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			
			drawBackground();
			
			setLabelText(); // creates a new label if necessary
			
			showSkin();
			showIcon();
		}

		/**
		 * @inheritDoc
		 */
		override protected function initialised() : void {
			updateAllBindings();
		}

		/**
		 * @inheritDoc
		 */
		override protected function update() : void {
			
			var resizeSkins : Boolean = false;
			var setSkin : Boolean = false;
			var skin : DisplayObject;

			var resizeIcons : Boolean = false;
			var setIcon : Boolean = false;
			var icon : DisplayObject;
			
			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				
				drawBackground();

				// remove all skins
				//removeSkins = true;
				resizeSkins = true;
				setSkin = true;

				// remove all icons
				//removeIcons = true;
				resizeIcons = true;
				setIcon = true;

				// resize label
				if (_label) setLabelSize();
				
			}

			if (isInvalid(UPDATE_PROPERTY_LABEL)) {
				setLabelText();
			}

			if (isInvalid(UPDATE_PROPERTY_ICON_NAME)) {
				createStateIconNameMap();
				setIcon = true;
			}

			if (isInvalid(UPDATE_PROPERTY_ICON)) {
				for each (icon in _icons) removeChild(icon);
				_icons = new Dictionary();

				setIcon = true;
			}

			if (isInvalid(UPDATE_PROPERTY_SKIN_NAME)) {
				createStateSkinNameMap();
				setSkin = true;
			}

			if (isInvalid(UPDATE_PROPERTY_SKIN)) {
				for each (skin in _skins) removeChild(skin);
				_skins = new Dictionary();

				setSkin = true;
			}

			// upates
			
			if (resizeIcons) {
				for each (icon in _icons) {
					DisplayObjectAdapter.setSize(icon, buttonWidth, buttonHeight, true);
					DisplayObjectAdapter.validateNow(icon);
				}
			}

			if (setSkin) {
				showSkin();
			}
			
			if (resizeSkins) {
				for each (skin in _skins) {
					DisplayObjectAdapter.setSize(skin, buttonWidth, buttonHeight);
					DisplayObjectAdapter.validateNow(skin);
				}
			}

			if (setIcon) {
				showIcon();
			}
			
			// validate now all children
			
			if (_label) _label.validateNow();

		}
		
		/**
		 * @inheritDoc
		 */
		override protected function styleChanged(property : String, value : *) : void {
			if (property.indexOf("IconSkinName") > -1) {
				invalidateProperty(UPDATE_PROPERTY_ICON_NAME);
			} else if (property.indexOf("IconSkin") > -1) {
				invalidateProperty(UPDATE_PROPERTY_ICON);
			} else if (property.indexOf("SkinName") > -1) {
				invalidateProperty(UPDATE_PROPERTY_SKIN_NAME);
			} else if (property.indexOf("Skin") > -1) {
				invalidateProperty(UPDATE_PROPERTY_SKIN);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function cleanUpCalled() : void {
			super.cleanUpCalled();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);

			if (_autoRepeatTimer) _autoRepeatTimer.removeEventListener(TimerEvent.TIMER, autoRepeatHandler);
		}

		/*
		 * Protected
		 */
		
		/**
		 * Template method to enable toggle button sub classes the
		 * control of the selected state.
		 * 
		 * <p>E.g. a radio button cannot be deselected manually but
		 * only programmatically.</p>
		 */
		protected function allowedToChangeSelection() : Boolean {
			return true;
		}

		/**
		 * Returns the tool tip.
		 * 
		 * <p>A sub class may return a custom tooltip. E.g. a color
		 * picker button always adds the currently selected color value
		 * to the end of the tip.</p>
		 * 
		 * @return The tooltip for the current button state.
		 */
		protected function getToolTip() : String {
			if (!_enabled) return "";

			var toolTip : String = _toolTip;
			if (_selected && _selectedToolTip) {
				toolTip = _selectedToolTip;
			}
			return toolTip;
		}

		/**
		 * Template method for the roll over event. 
		 */
		protected function onRollOver() : void {
		}

		/**
		 * Template method for the roll out event. 
		 */
		protected function onRollOut() : void {
		}

		/**
		 * Template method for the mouse down event. 
		 */
		protected function onMouseDown() : void {
		}

		/**
		 * Template method for the mouse up outside event. 
		 */
		protected function onMouseUpOutside() : void {
		}
		
		/**
		 * Template method for the click event. 
		 */
		protected function onClick() : void{
		}

		/**
		 * Template method for the selection changed event. 
		 * 
		 * <p>This method is called only if the selection has been
		 * changed by the user and not if changed programmatically.</p>
		 */
		protected function onSelectionChanged() : void{
		}

		/**
		 * Returns a value for the actual button width.
		 * 
		 * <p>If not overridden, this is the value the button has been
		 * initialised with.</p>
		 * 
		 * <p>Sub classes may display its label left or right to the actual
		 * button (such as CheckBox or RadioButton) and have therefore aberrant
		 * dimensions.</p>
		 * 
		 * @return The actual button width.
		 */
		protected function get buttonWidth() : uint {
			return _width;
		}
		
		/**
		 * Returns a value for the actual button height.
		 * 
		 * <p>If not overridden, this is the value the button has been
		 * initialised with.</p>
		 * 
		 * <p>Sub classes may display its label left or right to the actual
		 * button (such as CheckBox or RadioButton) and have therefore aberrant
		 * dimensions.</p>
		 * 
		 * @return The actual button height.
		 */
		protected function get buttonHeight() : uint {
			return _height;
		}

		/**
		 * The place where the label size is set.
		 * 
		 * <p>Sub classes may need different label dimensions.</p>
		 */
		protected function setLabelSize() : void {
			_label.setSize(_width, _height);
		}

		/**
		 * The place where the label styles are set.
		 * 
		 * <p>Sub classes may need different label styles.</p>
		 */
		protected function setLabelBaseStyles() : void {
			_label.setStyles([
				Label.style.horizontalAlign, Position.CENTER,
				Label.style.verticalAlign, Position.MIDDLE,
				Label.style.fittingMode, Label.FITTING_MODE_SCALE
			]);
		}

		/**
		 * Returns the position of the tooltip.
		 * 
		 * <p>Sub classes may need a different tool tip position.</p>
		 */
		protected function getToolTipOffsetX() : int {
			return getStyle(style.toolTipOffsetX);
		}

		/**
		 * Shows the skin depending on the current state.
		 * 
		 * <p>Sub classes may perform additional layout operations.</p>
		 */
		protected function showSkin() : void {
			var skin : DisplayObject = _skins[_stateSkinNameMap[_state]];

			if (!skin) {
				
				var skinClass : Class = getStyle(style[_stateSkinNameMap[_state]]);
				
				if (skinClass) {
					skin = new skinClass();
					skin.name = _stateSkinNameMap[_state];
	
					DisplayObjectAdapter.setSize(skin, buttonWidth, buttonHeight);
					DisplayObjectAdapter.addChildAt(skin, this, 0);

					_skins[_stateSkinNameMap[_state]] = skin;
				}
			}
			
			if (_skin) _skin.visible = false;
			
			if (skin) {
				_skin = skin;
				_skin.visible = true;
			}
		}
		
		/**
		 * Shows the icon depending on the current state.
		 * 
		 * <p>Sub classes may perform additional layout operations.</p>
		 */
		protected function showIcon() : void {
			
			var icon : DisplayObject = _icons[_stateIconNameMap[_state]];
			
			if (!icon) {
				var iconClass : Class = getStyle(style[_stateIconNameMap[_state]]);
				if (iconClass) {
					icon = new iconClass();
					icon.name = _stateIconNameMap[_state];
					
					/*
					 * A programmatic skin should inherit from View
					 * and is in charge to fit and center its content.
					 * A bitmap skin must be fitted and centered here.
					 */
					
					DisplayObjectAdapter.setSize(icon, buttonWidth, buttonHeight, true);
					DisplayObjectAdapter.addChild(icon, this);
					
					// colorise
					
					if (getStyle(style.coloriseIcon)) {
						DisplayObjectAdapter.colorise(icon, getStyle(style.iconColor));
					}

					_icons[_stateIconNameMap[_state]] = icon;
				}
			}
			
			if (_icon) _icon.visible = false;

			if (icon) {
				_icon = icon;
				_icon.visible = true;
				_icon.alpha = _enabled ? 1 : getStyle(style.disabledIconAlpha);
			}
		}

		/*
		 * Events
		 */
		
		/**
		 * Mouse over handler
		 */
		private function mouseOverHandler(event : MouseEvent) : void {
			_over = true;
			
			showToolTip();

			if (!_enabled) return;

			dispatchRollOver();

			setState();
		}

		/**
		 * Mouse out handler
		 */
		private function mouseOutHandler(event : MouseEvent) : void {
			_over = false;

			hideToolTip();

			if (!_enabled) return;

			dispatchRollOut();

			setState();
		}

		/**
		 * Mouse down handler
		 */
		private function mouseDownHandler(event : MouseEvent) : void {
			if (!_enabled) return;
			
			// mouse up listener
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

			// mouse down
			_mouseDown = true;
			dispatchMouseDown();
			
			// auto repeat
			if (_autoRepeat) {
				var delay : uint = getStyle(style.autoRepeatDelay);
				if (!_autoRepeatTimer) {
					_autoRepeatTimer = new Timer(delay);
					_autoRepeatTimer.addEventListener(TimerEvent.TIMER, autoRepeatHandler);
				} else {
					_autoRepeatTimer.delay = delay;
				}
				_autoRepeatTimer.start();
			}

			setState();
		}
		
		/**
		 * Mouse up handler
		 */
		private function mouseUpHandler(event : MouseEvent) : void {
			// mouse up listener
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

			// mouse up
			_mouseDown = false;

			if (_over) {
				if (_toggle) {
					if (allowedToChangeSelection()) {
						_selected = !_selected;
						
						setLabelText();

						showToolTip(); // tooltip may change

						updateBindingsForProperty(BINDABLE_PROPERTY_SELECTED);
						dispatchSelectionChanged();
					}
				}
				dispatchClick();
			} else {
				dispatchMouseUpOutside();
			}

			// auto repeat
			if (_autoRepeat) {
				_autoRepeatTimer.stop();
			}

			setState();
		}
		
		/**
		 * Auto repeat handler
		 */
		private function autoRepeatHandler(event : TimerEvent) : void {
			_autoRepeatTimer.delay = getStyle(style.autoRepeatRate);

			if (_over) dispatchMouseDown();
		}

		/**
		 * Dispatchs ButtonEvent.ROLL_OVER
		 */
		private function dispatchRollOver() : void {
			onRollOver();
			dispatchEvent(new ButtonEvent(ButtonEvent.ROLL_OVER));
		}
		
		/**
		 * Dispatchs ButtonEvent.ROLL_OUT
		 */
		private function dispatchRollOut() : void {
			onRollOut();
			dispatchEvent(new ButtonEvent(ButtonEvent.ROLL_OUT));
		}
		
		/**
		 * Dispatchs ButtonEvent.MOUSE_DOWN
		 */
		private function dispatchMouseDown() : void {
			onMouseDown();
			dispatchEvent(new ButtonEvent(ButtonEvent.MOUSE_DOWN));
		}
		
		/**
		 * Dispatchs ButtonEvent.CLICK
		 */
		private function dispatchClick() : void {
			onClick();
			dispatchEvent(new ButtonEvent(ButtonEvent.CLICK));
		}

		/**
		 * Dispatchs ButtonEvent.SELECTION_CHANGED
		 */
		private function dispatchSelectionChanged() : void {
			onSelectionChanged();
			dispatchEvent(new ButtonEvent(ButtonEvent.SELECTION_CHANGED));
		}

		/**
		 * Dispatchs ButtonEvent.MOUSE_UP_OUTSIDE
		 */
		private function dispatchMouseUpOutside() : void {
			onMouseUpOutside();
			dispatchEvent(new ButtonEvent(ButtonEvent.MOUSE_UP_OUTSIDE));
		}

		/*
		 * Private
		 */
		
		/**
		 * Draws a transparent background, which makes the button interactiv
		 * within the entire button area.
		 */
		private function drawBackground() : void {
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, _width, _height);
		}
		
		/**
		 * Creates the state icon name map.
		 */
		private function createStateIconNameMap() : void {
			_stateIconNameMap[STATE_UP] = getStyle(style.upIconSkinName);
			_stateIconNameMap[STATE_OVER] = getStyle(style.overIconSkinName);
			_stateIconNameMap[STATE_DOWN] = getStyle(style.downIconSkinName);
			_stateIconNameMap[STATE_DISABLED] = getStyle(style.disabledIconSkinName);

			_stateIconNameMap[STATE_SELECTED_UP] = getStyle(style.selectedUpIconSkinName);
			_stateIconNameMap[STATE_SELECTED_OVER] = getStyle(style.selectedOverIconSkinName);
			_stateIconNameMap[STATE_SELECTED_DOWN] = getStyle(style.selectedDownIconSkinName);
			_stateIconNameMap[STATE_SELECTED_DISABLED] = getStyle(style.selectedDisabledIconSkinName);
		}

		/**
		 * Creates the state skin name map.
		 */
		private function createStateSkinNameMap() : void {
			_stateSkinNameMap[STATE_UP] = getStyle(style.upSkinName);
			_stateSkinNameMap[STATE_OVER] = getStyle(style.overSkinName);
			_stateSkinNameMap[STATE_DOWN] = getStyle(style.downSkinName);
			_stateSkinNameMap[STATE_DISABLED] = getStyle(style.disabledSkinName);

			_stateSkinNameMap[STATE_SELECTED_UP] = getStyle(style.selectedUpSkinName);
			_stateSkinNameMap[STATE_SELECTED_OVER] = getStyle(style.selectedOverSkinName);
			_stateSkinNameMap[STATE_SELECTED_DOWN] = getStyle(style.selectedDownSkinName);
			_stateSkinNameMap[STATE_SELECTED_DISABLED] = getStyle(style.selectedDisabledSkinName);
		}

		/**
		 * Sets the label text depending on the current state.
		 */
		private function setLabelText() : void {
			if (!_selectedLabelText && !_labelText) return;

			if (!_label) {

				_label = new Label();
				setLabelSize();
				setLabelBaseStyles();
				setLabelStyles();
				addChild(DisplayObject(_label));
			}

			_label.text = _selected && _selectedLabelText ? _selectedLabelText : _labelText;
		}

		/**
		 * Shows the tool tip.
		 */
		private function showToolTip() : void {
			if (!_over) return;
			
			var toolTip : String = getToolTip();
			
			if (!toolTip) return;
			
			ToolTip.getInstance().show(
				this, toolTip,
				new Point(getToolTipOffsetX(), getStyle(style.toolTipOffsetY))
			);
		}
		
		/**
		 * Hides the tool tip.
		 */
		private function hideToolTip() : void {
			ToolTip.getInstance().hide(this);
		}

		/**
		 * Calculates the current state and sets skin, icon and label.
		 */
		private function setState() : void {
			var state : String;
			
			if (_selected) {
				state =
					_enabled
						? _over && allowedToChangeSelection()
							 ? _mouseDown
								? STATE_SELECTED_DOWN
								: STATE_SELECTED_OVER
							: STATE_SELECTED_UP
						: STATE_SELECTED_DISABLED;
				
			} else { // up, down, over, disabled
				state =
					_enabled
						? _over && allowedToChangeSelection()
							 ? _mouseDown
								? STATE_DOWN
								: STATE_OVER
							: STATE_UP
						: STATE_DISABLED;
			
			}
			
			if (state == _state) return;
			
			_state = state;

			if (!_initialised) return;

			showSkin();
			showIcon();

			if (_label) {
				setLabelStyles();
				_label.validateNow();
			}
			
		}

		/**
		 * Sets label styles depending on the current button state.
		 * 
		 * <p>Priorities</p>
		 * 
		 * <ul>
		 * <li>Disabled - Use always disabled styles if button is disabled, event if selected or mouse over.</li>
		 * <li>Over - Use over styles when over and enabled, even if the button is selected.</li>
		 * <li>Selected - Use selected styles only if enabled and not over.</li>
		 * <li>Default - Use default styles if enabled and not selected and not over.</li>
		 * </ul>
		 */
		private function setLabelStyles() : void {
			var stylesToSet : Array;
			
			// disabled
			if (!_enabled) {
				stylesToSet = getStyle(style.disabledLabelStyles);

			// enabled
			} else {
				// over
				if (_over) stylesToSet = getStyle(style.overLabelStyles);

				// not over but selected
				else if (_selected) stylesToSet = getStyle(style.selectedLabelStyles);
			}
			
			// defaults
			if (!stylesToSet) stylesToSet = getStyle(style.labelStyles);

			// set styles
			for (var i : uint = 0; i < stylesToSet.length; i += 2) {
				_label.setStyle(stylesToSet[i], stylesToSet[i + 1]);
			}
			
		}

	}
}

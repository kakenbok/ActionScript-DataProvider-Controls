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
package com.sibirjak.asdpc.treeview.interfacedemo.windows.styles {
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.common.interfacedemo.ControlPanelBase;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.listview.renderer.ListItemIcon;
	import com.sibirjak.asdpc.treeview.renderer.ConnectorContainer;
	import com.sibirjak.asdpc.treeview.renderer.DirectoryIcon;
	import com.sibirjak.asdpc.treeview.renderer.DisclosureButton;
	import com.sibirjak.asdpc.treeview.renderer.skins.DisclosureButtonArrowIconSkin;
	import com.sibirjak.asdpc.treeview.renderer.skins.DisclosureButtonBoxIconSkin;
	import com.sibirjak.asdpc.treeview.renderer.skins.DottedConnectorSkin;
	import com.sibirjak.asdpc.treeview.renderer.skins.SolidConnectorSkin;

	/**
	 * @author jes 14.01.2010
	 */
	public class TreeViewIconTab extends ControlPanelBase {
		
		/* internal */
		private const DISCLOSURE_BUTTON_COLOR_GROUP : String = "disclosureButtonColorProperties";
		private const DISCLOSURE_BUTTON_COLOR2 : String = "disclosureButtonColor2";

		/* assets */
		[Embed(source="assets/connector/connectorDotted.png")]
		private var _connectorDotted : Class;
		[Embed(source="assets/connector/connectorSolid.png")]
		private var _connectorSolid : Class;

		[Embed(source="assets/disclosure/disclosureArrow.png")]
		private var _disclosureArrow : Class;
		[Embed(source="assets/disclosure/disclosureRect.png")]
		private var _disclosureRect : Class;
		[Embed(source="assets/disclosure/disclosurePlus.png")]
		private var _disclosurePlus : Class;
		[Embed(source="assets/disclosure/disclosureMinus.png")]
		private var _disclosureMinus : Class;

		public function TreeViewIconTab(view : IView) {
			super.view = view;
		}
		
		override protected function draw() : void {

			addChild(
				document(
				
					headline("Connector"),

					hLayout(
					
						label("Type"),
					
						radioGroup("connectorType", setConnectorType),

						radioButton({
							group: "connectorType",
							value: "dotted",
							selected: true,
							icon: new _connectorDotted(),
							tip: "Dotted connector"
						}),
						
						radioButton({
							group: "connectorType",
							value: "solid",
							selected: false,
							icon: new _connectorSolid(),
							tip: "Solid connector"
						})
					),
					
					hLayout(
						label("Color"),
					
						colorPicker({
							color: 0xCCCCCC,
							change: setConnectorColor,
							tip: "Connector color"
						})
						
					),

					vSpacer(),

					dottedSeparator(),

					headline("Disclosure button"),
					
					hLayout(
						label("Type"),
					
						radioGroup("disclosureButtonType", setDisclosureButtonType),

						radioButton({
							group: "disclosureButtonType",
							value: "arrow",
							selected: true,
							icon: new _disclosureArrow(),
							tip: "Arrow icon"
						}),
						
						radioButton({
							group: "disclosureButtonType",
							value: "rect",
							selected: false,
							icon: new _disclosureRect(),
							tip: "Box icon"
						}),
					
						radioButton({
							group: "disclosureButtonType",
							value: "plus",
							selected: false,
							icon: new _disclosurePlus(),
							tip: "Plus minus icon"
						})
					),

					hLayout(
						label("Size"),
					
						sliderWithLabel({
							value: 7,
							minValue: 3,
							maxValue: 17,
							snapInterval: 1,
							change: setDisclosureButtonSize
						})
					),

					hLayout(
					
						DISCLOSURE_BUTTON_COLOR_GROUP,
						
						label("Color"),

						colorPicker({
							color: 0x999999,
							change: setDisclosureButtonColor,
							tip: "Icon color"
						}),

						colorPicker({
							id: DISCLOSURE_BUTTON_COLOR2,
							color: 0xFFFFFF,
							change: setDisclosureButtonColor2
						})
					),
					
					vSpacer(),

					dottedSeparator(),

					headline("Directory icon"),

					hLayout(
						label("Type"),
						
						iconSelector({
							iconSkin: IconFactory.getInstance().getIconSkin("folder_open"),
							change: setBranchOpenIcon,
							tip: "Open branch default icon"
						}),

						iconSelector({
							iconSkin: IconFactory.getInstance().getIconSkin("folder2"),
							change: setBranchClosedIcon,
							tip: "Closed branch default icon"
						}),

						iconSelector({
							iconSkin: IconFactory.getInstance().getIconSkin("document"),
							change: setLeafIcon,
							tip: "Leaf node default icon"
						})
					),

					hLayout(
						label("Size"),
		
						sliderWithLabel({
							value: 12,
							minValue: 6,
							maxValue: 20,
							snapInterval: 1,
							change: setIconSize
						})
					)

				) // document
			); // addchild
			
			IconFactory;
		}

		override protected function viewStyleChanged(property : String, value : *) : void {
//			if (property == TreeView.style.showRoot) {
//				var radioGroup : RadioGroup = getRadioGroup("disclosureButtonVisibility");
//				var box : CheckBox = getView(CONNECTOR_AT_ROOT_BOX) as CheckBox;
//
//				box.enabled = !value && radioGroup.selectedValue;
//			}
		}

		/*
		 * Binding events
		 */

		private function setConnectorType(connectorType : String) : void {
			var skin : Class;
			
			switch (connectorType) {
				case "dotted":
					skin = DottedConnectorSkin;
					break;
				case "solid":
					skin = SolidConnectorSkin;
					break;
			}
			_view.setStyle(ConnectorContainer.style_connectorSkin, skin);
		}

		private function setConnectorColor(connectorColor : uint) : void {
			_view.setStyle(DottedConnectorSkin.style_color, connectorColor);
			_view.setStyle(SolidConnectorSkin.style_color, connectorColor);
		}

		private function setDisclosureButtonType(type : String) : void {
			var skin : Class;
			
			switch (type) {
				case "arrow":
					_view.setStyle(DisclosureButton.style_collapsedIconSkin, DisclosureButtonArrowIconSkin);
					_view.setStyle(DisclosureButton.style_expandedIconSkin, DisclosureButtonArrowIconSkin);
					break;
				case "rect":
					_view.setStyle(DisclosureButton.style_collapsedIconSkin, DisclosureButtonBoxIconSkin);
					_view.setStyle(DisclosureButton.style_expandedIconSkin, DisclosureButtonBoxIconSkin);
					break;
				case "plus":
					_view.setStyle(DisclosureButton.style_collapsedIconSkin, _disclosurePlus);
					_view.setStyle(DisclosureButton.style_expandedIconSkin, _disclosureMinus);
					break;
			}
			
			setViewVisibility(DISCLOSURE_BUTTON_COLOR_GROUP, type != "plus");
			setViewVisibility(DISCLOSURE_BUTTON_COLOR2, type == "rect");
		}

		private function setDisclosureButtonSize(size : uint) : void {
			_view.setStyle(DisclosureButton.style_size, size);
		}

		private function setDisclosureButtonColor(disclosureButtonColor : uint) : void {
			_view.setStyle(DisclosureButtonBoxIconSkin.style_iconColor, disclosureButtonColor);
			_view.setStyle(DisclosureButtonArrowIconSkin.style_iconColor, disclosureButtonColor);
		}

		private function setDisclosureButtonColor2(disclosureButtonColor2 : uint) : void {
			_view.setStyle(DisclosureButtonBoxIconSkin.style_fillColor, disclosureButtonColor2);
		}

		private function setIconSize(iconSize : uint) : void {
			_view.setStyle(ListItemIcon.style.size, iconSize);
		}

		private function setBranchOpenIcon(iconSkin : Class) : void {
			_view.setStyle(DirectoryIcon.style.branchOpenIconSkin, iconSkin);
			
			dispatchChange(DirectoryIcon.style.branchOpenIconSkin, iconSkin);
		}

		private function setBranchClosedIcon(iconSkin : Class) : void {
			_view.setStyle(DirectoryIcon.style.branchClosedIconSkin, iconSkin);

			dispatchChange(DirectoryIcon.style.branchClosedIconSkin, iconSkin);
		}

		private function setLeafIcon(iconSkin : Class) : void {
			_view.setStyle(DirectoryIcon.style.leafIconSkin, iconSkin);

			dispatchChange(DirectoryIcon.style.leafIconSkin, iconSkin);
		}
	}
}

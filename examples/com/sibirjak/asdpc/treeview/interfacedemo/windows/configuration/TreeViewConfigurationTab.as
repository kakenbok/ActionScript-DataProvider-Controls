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
package com.sibirjak.asdpc.treeview.interfacedemo.windows.configuration {
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.configuration.ConfigurationTab;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;
	import com.sibirjak.asdpc.treeview.TreeView;
	import com.sibirjak.asdpc.treeview.renderer.ConnectorContainer;
	import com.sibirjak.asdpc.treeview.renderer.TreeNodeRenderer;
	import com.sibirjak.asdpcbeta.checkbox.CheckBox;
	import com.sibirjak.asdpcbeta.radiobutton.RadioGroup;

	/**
	 * @author jes 20.01.2010
	 */
	public class TreeViewConfigurationTab extends ConfigurationTab {

		/* internal */
		private const CONNECTOR_GROUP : String = "connectorGroup";
		private const CONNECTOR_AT_ROOT_GROUP : String = "connectorAtRootGroup";
		private const CONNECTOR_AT_ROOT_BOX : String = "connectorAtRootBox";

		private const CONNECTOR_AT_BUTTON_GROUP : String = "connectorAtButtonGroup";
		private const CONNECTOR_AT_BUTTON_BOX : String = "connectorAtButtonBox";

		private const CONNECTOR_AT_ICON_GROUP : String = "connectorAtIconGroup";
		private const CONNECTOR_AT_ICON_BOX : String = "connectorAtIconBox";

		public function TreeViewConfigurationTab(view : IView) {
			super(view);
		}

		override protected function draw() : void {

			addChild(
				document(
				
					headline("Tree"),

					hLayout(

						label("Root node"),
						
						radioGroup("rootVisibility", setShowRoot),

						radioButton({
							group: "rootVisibility",
							value: true,
							selected: true,
							icon: new (IconFactory.getInstance().getIconSkin("eye"))(),
							tip: "Show root node"
						}),
					
						radioButton({
							group: "rootVisibility",
							value: false,
							selected: false,
							icon: new (IconFactory.getInstance().getIconSkin("hidden_eye"))(),
							tip: "Hide root node"
						})
					),
					
					vSpacer(),
		
					dottedSeparator(),
	
					itemHeadline(),

					backgroundConfiguration(),

					hLayout(

						label("Connector"),
						
						radioGroup("connectorVisibility", setShowConnectors),

						radioButton({
							group: "connectorVisibility",
							value: true,
							selected: true,
							icon: new (IconFactory.getInstance().getIconSkin("eye"))(),
							tip: "Show connectors"
						}),
					
						radioButton({
							group: "connectorVisibility",
							value: false,
							selected: false,
							icon: new (IconFactory.getInstance().getIconSkin("hidden_eye"))(),
							tip: "Hide connectors"
						})
					),
					
					hLayout(
					
						CONNECTOR_GROUP,
						spacer(),
						
						vLayout(
							CONNECTOR_AT_ROOT_GROUP,
							checkBox({
								id: CONNECTOR_AT_ROOT_BOX,
								selected: true,
								label: "Level 0",
								diff: -46,
								tip: "Show connector at level 0",
								change: setConnectorAtRoot
							}),
							vSpacer(8)
						),
						
						vLayout(
							CONNECTOR_AT_BUTTON_GROUP,
							checkBox({
								id: CONNECTOR_AT_BUTTON_BOX,
								selected: false,
								label: "Button",
								diff: -50,
								tip: "Show connector behind button",
								change: setConnectorAtButton
							}),
							vSpacer(8)
						),

						vLayout(
							CONNECTOR_AT_ICON_GROUP,
							checkBox({
								id: CONNECTOR_AT_ICON_BOX,
								selected: false,
								label: "Icon",
								diff: -40,
								tip: "Show connector behind icon",
								change: setConnectorAtIcon
							}),
							vSpacer(8)
						)

					),
					
					hLayout(
						label("Disclosure button"),
						
						radioGroup("disclosureButtonVisibility", setShowDisclosureButton),

						radioButton({
							group: "disclosureButtonVisibility",
							value: true,
							selected: true,
							icon: new (IconFactory.getInstance().getIconSkin("eye"))(),
							tip: "Show disclosure button"
						}),
					
						radioButton({
							group: "disclosureButtonVisibility",
							value: false,
							selected: false,
							icon: new (IconFactory.getInstance().getIconSkin("hidden_eye"))(),
							tip: "Hide disclosure button"
						})
						
					),
					
					iconConfiguration(),

					scrollBarConfiguration()

				)
			);
		}
		
		override protected function viewVisibilityChanged() : void {
			var connectorGroup : View = getView(CONNECTOR_GROUP);
			setViewVisibility(CONNECTOR_GROUP, connectorGroup.height > 10);
		}

		override protected function getIconName() : String {
			return "Directory icon";
		}

		override protected function iconVisible() : Boolean {
			return true;
		}

		/*
		 * Binding events
		 */
				
		private function setShowRoot(showRoot : Boolean) : void {
			_view.setStyle(TreeView.style.showRoot, showRoot);
			
			var radioGroup : RadioGroup = getRadioGroup("disclosureButtonVisibility");
			setViewVisibility(CONNECTOR_AT_ROOT_GROUP, !showRoot && radioGroup.selectedValue);
			
			dispatchChange(TreeView.style.showRoot, showRoot);
		}

		private function setShowConnectors(showConnectors : Boolean) : void {
			_view.setStyle(TreeNodeRenderer.style.connectors, showConnectors);
			
			setViewVisibility(CONNECTOR_GROUP, showConnectors);
		}

		private function setConnectorAtRoot(atRoot : Boolean) : void {
			_view.setStyle(ConnectorContainer.style_connectorAtRootLevel, atRoot);
		}

		private function setConnectorAtButton(atButton : Boolean) : void {
			_view.setStyle(ConnectorContainer.style_connectorAtButton, atButton);
		}

		private function setConnectorAtIcon(atIcon : Boolean) : void {
			_view.setStyle(ConnectorContainer.style_connectorAtIcon, atIcon);
		}

		private function setShowDisclosureButton(showDisclosureButton : Boolean) : void {
			_view.setStyle(TreeNodeRenderer.style.disclosureButton, showDisclosureButton);

			var radioGroup : RadioGroup = getRadioGroup("rootVisibility");
			setViewVisibility(CONNECTOR_AT_ROOT_GROUP, showDisclosureButton && !radioGroup.selectedValue);

			setViewVisibility(CONNECTOR_AT_BUTTON_GROUP, showDisclosureButton);
		}

		override protected function setShowIcons(showIcons : Boolean) : void {
 			_view.setStyle(ListItemRenderer.style.icon, showIcons);
 			
 			if (!showIcons) {
				_view.setStyle(ConnectorContainer.style_connectorAtIcon, false);
			} else {
				var checkBox : CheckBox = getView(CONNECTOR_AT_ICON_BOX) as CheckBox;
				_view.setStyle(ConnectorContainer.style_connectorAtIcon, checkBox.selected);
			}

			setViewVisibility(CONNECTOR_AT_ICON_GROUP, showIcons);
		}

	}
}

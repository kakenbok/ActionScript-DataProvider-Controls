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
package com.sibirjak.asdpc.listview.interfacedemo.windows.configuration {
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.common.interfacedemo.ControlPanelBase;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.constants.Visibility;
	import com.sibirjak.asdpc.listview.ListView;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;
	import com.sibirjak.asdpc.scrollbar.ScrollBar;
	import com.sibirjak.asdpcbeta.radiobutton.RadioGroup;

	/**
	 * @author jes 19.01.2010
	 */
	public class ConfigurationTab extends ControlPanelBase {

		/* internal */
		private const SCROLL_BUTTON_GROUP : String = "scrollButton";
		private const SCROLL_BUTTON_VISIBILITY_AUTO_GROUP : String = "scrollButtonVisibilityAuto";

		public function ConfigurationTab(view : IView) {
			super.view = view;
		}

		override protected function draw() : void {

			addChild(
				document(
				
					itemHeadline(),

					backgroundConfiguration(),

					iconConfiguration(),

					scrollBarConfiguration()

				)
			);
		}
		
		protected function itemHeadline() : View {
			return vLayout(
				headline("Item")
			);
		}

		protected function backgroundConfiguration() : View {
			return hLayout(
			
				label("Background"),

				radioGroup("backgroundVisibility", setShowBackground),

				radioButton({
					group: "backgroundVisibility",
					value: true,
					selected: true,
					icon: new (IconFactory.getInstance().getIconSkin("eye"))(),
					tip: "Show background"
				}),
			
				radioButton({
					group: "backgroundVisibility",
					value: false,
					selected: false,
					icon: new (IconFactory.getInstance().getIconSkin("hidden_eye"))(),
					tip: "Hide background"
				})
				
			);

		}

		protected function iconConfiguration() : View {
			
			return hLayout(

				label(getIconName()),
				
				radioGroup("iconVisibility", setShowIcons),

				radioButton({
					group: "iconVisibility",
					value: true,
					selected: iconVisible(),
					icon: new (IconFactory.getInstance().getIconSkin("eye"))(),
					tip: "Show icon"
				}),
			
				radioButton({
					group: "iconVisibility",
					value: false,
					selected: !iconVisible(),
					icon: new (IconFactory.getInstance().getIconSkin("hidden_eye"))(),
					tip: "Hide icon"
				})
				
			);

		}

		protected function scrollBarConfiguration() : View {
			return vLayout(

				vSpacer(),
					
				dottedSeparator(),

				headline("Scrollbar"),

				hLayout(
				
					label("Scrollbar"),
					
					radioGroup("scrollBarVisibility", setScrollBarVisibility),

					radioButton({
						group: "scrollBarVisibility",
						value: Visibility.VISIBLE,
						selected: false,
						icon: new (IconFactory.getInstance().getIconSkin("eye"))(),
						tip: "Always show scrollbar"
					}),
				
					radioButton({
						group: "scrollBarVisibility",
						value: Visibility.HIDDEN,
						selected: false,
						icon: new (IconFactory.getInstance().getIconSkin("hidden_eye"))(),
						tip: "Always hide scrollbar"
					}),
				
					radioButton({
						group: "scrollBarVisibility",
						value: Visibility.AUTO,
						selected: true,
						icon: new (IconFactory.getInstance().getIconSkin("server"))(),
						tip: "Show scrollbar if scrolling enabled"
					})
					
				),
				
				hLayout(
				
					SCROLL_BUTTON_GROUP,

					label("Scroll buttons"),
					
					radioGroup("scrollBarButtonVisibility", setScrollBarButtonVisibility),
					
					radioButton({
						group: "scrollBarButtonVisibility",
						value: Visibility.VISIBLE,
						selected: true,
						icon: new (IconFactory.getInstance().getIconSkin("eye"))(),
						tip: "Always show scroll buttons"
					}),
				
					radioButton({
						group: "scrollBarButtonVisibility",
						value: Visibility.HIDDEN,
						selected: false,
						icon: new (IconFactory.getInstance().getIconSkin("hidden_eye"))(),
						tip: "Always hide scroll buttons"
					}),
				
					hLayout(
						SCROLL_BUTTON_VISIBILITY_AUTO_GROUP,
						radioButton({
							group: "scrollBarButtonVisibility",
							value: Visibility.AUTO,
							selected: false,
							icon: new (IconFactory.getInstance().getIconSkin("server"))(),
							tip: "Show scroll buttons if scrolling enabled"
						})
					)
					
				)
				
			);
		}
		
		protected function getIconName() : String {
			return "Icon";
		}

		protected function iconVisible() : Boolean {
			return false;
		}

		/*
		 * Binding events
		 */
				
		public function setShowBackground(show : Boolean) : void {
			_view.setStyle(ListItemRenderer.style.background, show);
		}

		protected function setShowIcons(showIcons : Boolean) : void {
 			_view.setStyle(ListItemRenderer.style.icon, showIcons);
		}

		private function setScrollBarVisibility(visibility : String) : void {
			_view.setStyle(ListView.style.scrollBarVisibility, visibility);
			
			setViewVisibility(SCROLL_BUTTON_GROUP, visibility != Visibility.HIDDEN);

			if (visibility == Visibility.AUTO) {
				var radioGroup : RadioGroup = getRadioGroup("scrollBarButtonVisibility");
				if (radioGroup.selectedValue == Visibility.AUTO) {
					radioGroup.selectedValue = Visibility.VISIBLE;
				}
			}

			setViewVisibility(SCROLL_BUTTON_VISIBILITY_AUTO_GROUP, visibility != Visibility.AUTO, false);
		}

		private function setScrollBarButtonVisibility(visibility : String) : void {
			_view.setStyle(ScrollBar.style.scrollButtonVisibility, visibility);
		}

	}
}

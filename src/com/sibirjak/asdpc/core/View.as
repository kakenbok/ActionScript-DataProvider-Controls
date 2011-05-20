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
package com.sibirjak.asdpc.core {
	import com.sibirjak.asdpc.core.managers.IPopUpControl;
	import com.sibirjak.asdpc.core.managers.StageProxy;
	import com.sibirjak.asdpc.core.managers.ViewPropertyManager;

	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.ISet;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * Base class for all ASDPC components.
	 * 
	 * <p>The main task of the View is to provide a performant creation and invalidation
	 * life cycle to its subclasses. Such a life cycle has mainly two benefits:</p>
	 * 
	 * <ol>
	 * <li>The location of code and responsibilities in subclasses of View is predetermined
	 * by the View life cycle. Subclasses are easier to develop and to understand. E.g. there
	 * is an init() method in which a subclass should evaluate initial properties. The
	 * update() method is the place where the subclass should apply all previously collected
	 * property changes to its representation.</li>
	 * <li>Runtime performance is enhanced by both a strict (and thought) invocation order
	 * of all view life cycle methods as well as by the internal property change cache which
	 * decouples the change of properties from the actual update of the visual representation
	 * of the component.</li>
	 * </ol>
	 * 
	 * <p>Besides that life cycle the View owns styling capabilities and a generic property
	 * manager, which enables setting and getting of arbitrary properties at runtime.</p>
	 * 
	 * <strong>View Life cycle</strong>
	 * 
	 * <p>The view life cycle consists of both the initialisation and the invalidation process.
	 * The initialisation process is passed through only once for each component. The invalidation
	 * process is repeated always if view properties change.</p>
	 * 
	 * <strong>Initialisation</strong>
	 * 
 	 * <ol>
	 * <li>A View instance is created.</li>
	 * <li>The protected property _initialised is initially set to false. The _initialised
	 * property tells the component if it already has passed its init() and draw() methods
	 * and thus the visual representation of the component is already established.</li>
	 * <li>Properties and styles are set to the view.</li>
	 * <li>The view gets added to the stage.</li>
	 * <li>The protected method init() will be invoked. Within init() the view should
	 * evaluate all properties and styles set.</li>
	 * <li>The protected method draw() will be invoked. Within draw() the view should
	 * create its visual representation.</li>
	 * <li>The protected property _initialised is set to true.</li>
	 * <li>The protected method initialised() will be invoked. Within initialised() the
	 * component may apply finialising changes or dispatch state information events.
	 * E.g. If the view is bindable, all bindings are initially updated in the initialised()
	 * method.</li>
	 * </ol>
	 * 
	 * <listing>
		var view : MyView = new MyView();
		view.setSize(200, 200);
		view.setBackgroundColor(0x0000FF);
		view.setSize(50, 50);
		addChild(view);

		// in view

		override protected function init() : void {
			if (_width &lt; 100 || _height &lt; 100) {
				_backgroundColor = 0xFF0000; // warn size too small
			}
		}

		override protected function draw(color : uint) : void {
			drawBackground();
			drawLabel();
		}
	 * </listing>
	 * 
	 * <strong>Invalidation</strong>
	 * 
	 * <ul>
	 * <li>Properties and styles are set to the view.</li>
	 * <li>The view invokes its protected invalidate() or invalidateProperty() method. Internally,
	 * the view sets a listener for the Event.ENTER_FRAME to apply changes in the next frame.</li>
	 * <li>The view receives Event.ENTER_FRAME.</li>
	 * <li>The protected method update() will be invoked. Within update() the view should
	 * evaluate all properties and styles changed and collect a list of visual elements that
	 * need validation.</li>
	 * <li>The protected method commitUpdate() will be invoked. Within commitUpdate() the
	 * previously collected list of visual elements should be updated.</li>
	 * <li>Finally, all sub views added to the protected auto update list via updateAutomatically(subView)
	 * will be immediately validated.</li>
	 * </ul>
	 * 
	 * <listing>
		view.setSize(100, 200);
		view.setBackgroundColor(0xFF0000);
		view.setSize(200, 200);
		view.setBackgroundColor(0x0000FF);
		...
		
		// in view

		public function setSize(width : int, height : int) : void {
			_width = width;
			_height = height;
			invalidateProperty("size");
		}

		public function setBackgroundColor(color : uint) : void {
			_backgroundColor = color;
			invalidateProperty("background");
		}

		override protected function update() : void {
			if (isInvalid("geometry")) {
				updateProperty("label");
				updateProperty("background");
			}

			if (isInvalid("backgroundColor")) {
				updateProperty("background");
			}
		}

		override protected function commitUpdate() : void {
			if (shouldUpdate("background")) {
				drawBackground();
			}

			if (shouldUpdate("label")) {
				_label.setSize(_width, _height);
			}
		}
	 * </listing>
	 * 
	 * @author jes 09.07.2009
	 */
	public class View extends Container implements IView {
		
		/*
		 * Properties
		 */

		/* changeable properties or styles */

		/**
		 * Name constant for the size invalidation property.
		 */
		protected const UPDATE_PROPERTY_SIZE : String = "size";

		/**
		 * Name constant for the width invalidation property.
		 */
		protected const UPDATE_PROPERTY_WIDTH : String = "width";

		/**
		 * Name constant for the height invalidation property.
		 */
		protected const UPDATE_PROPERTY_HEIGHT : String = "height";

		/* internals */


		/* protected properties */

		/**
		 * View width.
		 */
		protected var _width : uint;

		/**
		 * View height.
		 */
		protected var _height : uint;

		/**
		 * Initialisation flag.
		 * 
		 * <p>This flag is set to true, if the view has finished its
		 * initialisation process. The flag is set after draw() and
		 * before initialised()</p> 
		 */
		protected var _initialised : Boolean = false;

		/* internals */

		/**
		 * List of all properties to validate whithin the next update().
		 */
		private var _invalidProperties : Object;

		/**
		 * List of properties to update within the next commitUpdate().
		 */
		private var _propertiesToUpdate : Object;

		/**
		 * ViewPropertyManager instance.
		 */
		private var _viewPropertyManager : ViewPropertyManager;

		/**
		 * Cleaned up flag.
		 * 
		 * <p>This flag is set to true, if cleanUp() has been called to a view.
		 * Subsequent calls to cleanUp will be ignored.</p> 
		 */
		private var _cleanUpCalled : Boolean = false;

		/**
		 * View default width.
		 */
		private var _defaultWidth : uint;

		/**
		 * View default height.
		 */
		private var _defaultHeight : uint;

		/**
		 * View default height.
		 */
		private var _subViewsToUpdate : ISet;

		/**
		 * View constructor.
		 */
		public function View() {
			_invalidProperties = new Object();
			_propertiesToUpdate = new Object();
			
			_viewPropertyManager = new ViewPropertyManager(this);
			
			_subViewsToUpdate = new LinkedSet();

			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * Overrides the stage property to use the StageProxy instead.
		 * 
		 * <p>The StageProxy gives more control over and access to the
		 * global stage events and properties.</p>
		 * 
		 * @return The Stage intance.
		 */
		override public final function get stage() : Stage {
			return StageProxy.stage;
		}
			
		/**
		 * @inheritDoc
		 */
		public final function get addedToStage() : Boolean {
			return super.stage != null;
		}
		
		/*
		 * IView
		 */

		/**
		 * @inheritDoc
		 */
		public final function setSize(width : int, height : int) : void {
			
			if (width < 0) width = 0;
			if (height < 0) height = 0;
			
			if (_width == width && _height == height) return;
			
			if (_width != width) {
				_width = width;
				invalidateProperty(UPDATE_PROPERTY_WIDTH);
			}

			if (_height != height) {
				_height = height;
				invalidateProperty(UPDATE_PROPERTY_HEIGHT);
			}
			
			invalidateProperty(UPDATE_PROPERTY_SIZE);
		}
		
		/**
		 * @inheritDoc
		 */
		public final function moveTo(x : int, y : int) : void {
			this.x = x;
			this.y = y;
		}

		/**
		 * @inheritDoc
		 */
		public final function validateNow() : void {
			if (_initialised) {
				renderHandler(null);
			}
		}

		/**
		 * @inheritDoc
		 */
		public final function cleanUp() : void {
			if (_cleanUpCalled) return;

			removeEventListener(Event.ENTER_FRAME, renderHandler);
				
			cleanUpCalled();
			
			_cleanUpCalled = true;

			// clean up children recursively
			
			cleanUpRecursively(this);

		}
		
		// Property management
		
		/**
		 * @copy com.sibirjak.asdpc.core.managers.PropertyManager#setViewProperty()
		 */
		public final function setViewProperty(property : String, value : *) : void {
			_viewPropertyManager.setViewProperty(property, value);
		}
		
		/**
		 * @copy com.sibirjak.asdpc.core.managers.PropertyManager#getViewProperty()
		 */
		public final function getViewProperty(property : String) : * {
			return _viewPropertyManager.getViewProperty(property);
		}

		// Style management

		/**
		 * @copy com.sibirjak.asdpc.core.managers.StyleManager#setDefaultStyles()
		 */
		public final function setDefaultStyles(defaultStyles : Array) : void {
			if (_initialised) return;
			
			_styleManager.setDefaultStyles(defaultStyles);
		}

		/**
		 * @copy com.sibirjak.asdpc.core.managers.StyleManager#getDefaultStyles()
		 */
		public final function getDefaultStyles() : Array {
			return _styleManager.getDefaultStyles();
		}

		/**
		 * @copy com.sibirjak.asdpc.core.managers.StyleManager#setStyle()
		 */
		public final function setStyle(property : String, value : *, selectorChain : Array = null, excludeChain : Array = null) : void {
			_styleManager.setStyle(property, value, selectorChain, excludeChain);
		}
		
		/**
		 * @copy com.sibirjak.asdpc.core.managers.StyleManager#setStyles()
		 */
		public final function setStyles(styles : Array, selectorChain : Array = null, excludeChain : Array = null) : void {
			_styleManager.setStyles(styles, selectorChain, excludeChain);
		}
		
		/**
		 * @copy com.sibirjak.asdpc.core.managers.StyleManager#getStyle()
		 */
		public final function getStyle(property : String) : * {
			return _styleManager.getStyle(property);
		}

		/**
		 * @inheritDoc
		 */
		override final public function styleManagerStyleChangeHandler(property : String, value : *) : void {
			if (_initialised) styleChanged(property, value);
		}
		
		/*
		 * IViewPropertyManagerClient
		 */

		/**
		 * @inheritDoc
		 */
		public final function get viewPropertyManager() : ViewPropertyManager {
			return _viewPropertyManager;
		}

		/*
		 * IDisplayObject
		 */

		/**
		 * @inheritDoc
		 */
		override public final function get width() : Number {
			return _width;
		}
		
		/**
		 * @inheritDoc
		 */
		override public final function get height() : Number {
			return _height;
		}
		
		/*
		 * View life cycle
		 */

		/**
		 * Initialises view styles and properties.
		 * 
		 * <p>This method is called once right after the view has been
		 * added to the display list.</p>
		 * 
		 * <p>Here is the first place to access parent style properties. You
		 * use this method to perform operations connected with view styles
		 * or properties, e.g. caching style values into a local properties
		 * or evaluating property consistencies.</p>
		 */
		protected function init() : void {
		}

		/**
		 * Creates, draws and layouts sub views initially.
		 * 
		 * <p>This method is called once right after the init() method
		 * has been invoked.</p>
		 * 
		 * <p>You use this method to create, draw and layout all children, who
		 * are necessary for the initial view state or should be created
		 * once for a later use (e.g. hidden elements).</p>
		 */
		protected function draw() : void {
		}

		/**
		 * Notifies a view after it has been fully initialised.
		 * 
		 * <p>This method is a hook to enable subclasses to perform further
		 * operations after the initialisation has been finished and the
		 * _initialised property is set to true.</p>
		 * 
		 * <p>You use this method to set or dispatch an initial view state,
		 * e.g. to select an item of a ListView instance.</p>
		 * 
		 * <p>The propetected property _initialised is set to true at this point.</p>
		 */
		protected function initialised() : void {
		}

		/**
		 * Notifies the view about a change of a style value for that it
		 * defines a default style.
		 * 
		 * <p>To generally get notifications from the style manager, you need to
		 * declare all particular styles via the StyleManager.setDefaultStyles()
		 * method. You do this at best in the constructor of the client.</p>
		 * 
		 * <p>If this method has been called, you should update your view to
		 * reflect the changes in its visualisation.</p>
		 * 
		 * @param property The style name.
		 * @param value The style value.
		 */
		protected function styleChanged(property : String, value : *) : void {
		}

		/**
		 * Updates, redraws and layouts sub views.
		 * 
		 * <p>draw() and update() have the same job to set the view in the right state.
		 * While the draw() method gets called only one, the update() method is invoked
		 * every time a validation cycle has been passed.</p>
		 * 
		 * <p>If you have started a validation cycle by calling invalidateProperty(property),
		 * isInvalid(property) will here return true.</p>
		 * 
		 * <p>After this method has finished, all invalidate properties are nullified.</p>
		 */
		protected function update() : void {
		}
		
		/**
		 * Finalises an update process.
		 * 
		 * <p>This method is called always after update() and provides a central
		 * exit point for updates in inheritance structures. You may collect all
		 * properties of your object that need an update within the update() block
		 * and execute all updates in commitUpdate() once rather than doing twice
		 * in the parent class update() as well as in the sub class update() method.</p>
		 * 
		 * <p>Example: The parent class needs to update a background. The sub class
		 * also needs to update a background for different reasons. Implemented in
		 * the update() method, the updateBackground() would be called twice.</p>
		 */
		protected function commitUpdate() : void {
		}

		/**
		 * Called after cleanup is invoked for the view.
		 * 
		 * <p>The view is supposed to clean up any event listeners,
		 * property bindings and all other references.</p>
		 * 
		 * <p>The view is also in charge to clean up its children.</p>
		 */
		protected function cleanUpCalled() : void {
		}
		
		/*
		 * Final protected methods
		 */

		/**
		 * Defines a default size if no size is set else.
		 * 
		 * <p>The default dimensions are used only once after the view is added
		 * to the stage the first time.</p>  
		 * 
		 * @param width The default width.
		 * @param height The default height.
		 */
		protected final function setDefaultSize(width : int, height : int) : void {
			_defaultWidth = width;
			_defaultHeight = height;
		}

		/**
		 * Starts a property dependent validation cycle.
		 * 
		 * <p>The given property will be set to the internal invalid properties
		 * list and can be examined in a subsequent update() call.</p>
		 * 
		 * @param property The property to invalidate.
		 */
		protected final function invalidateProperty(property : String) : void {
			if (_initialised) {
				_invalidProperties[property] = true;
				invalidate();
			}
		}

		/**
		 * Starts a property independent validation cycle.
		 * 
		 * <p>Since no property is invalidated, in a subsequent call of
		 * update() you cannot distinct the reason of update.</p>
		 * 
		 * <p>Use this method, if you have only one changeable property
		 * or if you want to fully update your view regardless of
		 * the specific update reason.</p>
		 */
		protected final function invalidate() : void {
			if (_initialised) {
				addEventListener(Event.ENTER_FRAME, renderHandler);
			}
		}
		
		/**
		 * Returns true if the given property has been marked
		 * to be invalid beforehand.
		 * 
		 * <p>After the size of a view has been reset, a call to
		 * isInvalid(UPDATE_PROPERTY_SIZE) will return true.</p>
		 * 
		 * @param property The property to test.
		 * @return True, if the property has been marked invalid.
		 */
		protected final function isInvalid(property : String) : Boolean {
			return _invalidProperties[property] != undefined;
		}
		
		/**
		 * Marks a property to be updated in commitProperties().
		 * 
		 * <p>The given property will be set to the internal update properties
		 * list and can be examined in a subsequent commitUpdate() call.</p>
		 * 
		 * @param property The property to update.
		 */
		protected final function updateProperty(property : String) : void {
			_propertiesToUpdate[property] = true;
		}

		/**
		 * Returns true if the given property has been marked
		 * to be updated beforehand.
		 * 
		 * @param property The property to test.
		 * @return True, if the property has been marked to be updated.
		 */
		protected final function shouldUpdate(property : String) : Boolean {
			return _propertiesToUpdate[property] != undefined;
		}
		
		/**
		 * Marks a sub view to be updated automatically after an
		 * update has been finished.
		 * 
		 * @param subView The sub view.
		 */
		protected final function updateAutomatically(subView : DisplayObject) : void {
			_subViewsToUpdate.add(subView);
		}

		/**
		 * Removes a sub view from the auto update list.
		 * 
		 * @param subView The sub view.
		 */
		protected final function removeFromAutoUpdate(subView : DisplayObject) : void {
			_subViewsToUpdate.remove(subView);
		}

		/*
		 * Private
		 */
		
		/**
		 * Handler for the ADDED_TO_STAGE event.
		 */
		private function addedToStageHandler(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			StageProxy.stage = super.stage;
			
			// set default size
			if (!_width && _defaultWidth) _width = _defaultWidth;
			if (!_height && _defaultHeight) _height = _defaultHeight;

			init();

			draw();

			_initialised = true;
			
			initialised();
		}
		
		/**
		 * Will be called when the render timer enters the first frame.
		 * The timer will be removed and the update() method is called. 
		 */
//		private var _renderCount : uint = 0; // TODO
		private function renderHandler(event : Event) : void {
//			_renderCount++;
//			if (_renderCount < 20 && event) return;
//			_renderCount = 0;

			removeEventListener(Event.ENTER_FRAME, renderHandler);
			
			update();
			
			_invalidProperties = new Object();

			commitUpdate();

			_propertiesToUpdate = new Object();

			// update all sub views immediately
			if (_subViewsToUpdate.size) {
				var iterator : IIterator = _subViewsToUpdate.iterator();
				while (iterator.hasNext()) {
					DisplayObjectAdapter.validateNow(iterator.next());
				}
			}
			
		}
		
		/*
		 * Cleans up the view and its children.
		 */
		private function cleanUpRecursively(container : DisplayObjectContainer) : void {
			var i : int = -1;
			var child : DisplayObject;
			while (++i < container.numChildren) {
				child = container.getChildAt(i);
				if (child is IView) IView(child).cleanUp();
				else if (child is DisplayObjectContainer) cleanUpRecursively(DisplayObjectContainer(child));
			}
			
			if (container is IPopUpControl) {
				child = IPopUpControl(this).popUp as DisplayObject;
				if (child is IView) IView(child).cleanUp();
			}
		}
		
	}
}


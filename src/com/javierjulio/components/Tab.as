package com.javierjulio.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.CloseEvent;
	
	import spark.components.Button;
	import spark.components.ButtonBarButton;
	
	public class Tab extends ButtonBarButton
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function Tab()
		{
			super();
			
			// enable mouseChildren so our closeButton can receive mouse events
			mouseChildren = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  contacts
		//----------------------------------
		
		[SkinPart(required="false", type="mx.core.IVisualElement")]
		
		/**
		 * A skin part that defines the button for closing this tab.
		 * 
		 * @default null
		 */
		public var closeButton:Button;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == closeButton)
			{
				closeButton.addEventListener(MouseEvent.MOUSE_UP, closeButton_clickHandler, false, 0, true);
				closeButton.addEventListener(MouseEvent.MOUSE_DOWN, cancelEvent, false, 0, true);
				closeButton.addEventListener(MouseEvent.CLICK, cancelEvent, false, 0, true);
			}
		}
		
		/**
		 * @private
		 */
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
			
			if (instance == closeButton)
			{
				closeButton.removeEventListener(MouseEvent.MOUSE_UP, closeButton_clickHandler);
				closeButton.removeEventListener(MouseEvent.MOUSE_DOWN, cancelEvent);
				closeButton.removeEventListener(MouseEvent.CLICK, cancelEvent);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function cancelEvent(event:Event):void 
		{
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		
		/**
		 * When the user clicks the close button an event CloseEvent.CLOSE will be 
		 * dispatched. This doesn't actually remove the tab. The parent component 
		 * (most likely the TabBar) will remove the item from its data provider 
		 * which will trigger the removal of the tab as well.
		 * 
		 * @param event The MouseEvent object.
		 */
		protected function closeButton_clickHandler(event:MouseEvent):void 
		{
			if (enabled) 
			{
				dispatchEvent(new CloseEvent(CloseEvent.CLOSE, false, false, itemIndex));
			}
			
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
	}
}
package com.javierjulio.components
{
	import mx.core.IVisualElement;
	import mx.events.CloseEvent;
	
	import spark.components.TabBar;
	import spark.events.RendererExistenceEvent;

	public class SuperTabBar extends TabBar
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function SuperTabBar()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Called when an item has been added to this component.
		 */
		override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void 
		{
			super.dataGroup_rendererAddHandler(event);
			
			var renderer:IVisualElement = event.renderer;
			
			if (renderer && renderer is Tab) 
			{
				Tab(renderer).addEventListener(CloseEvent.CLOSE, item_closeHandler);
			}
		}
		
		/**
		 * @private
		 * Called when an item has been added to this component.
		 */
		override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void 
		{
			super.dataGroup_rendererRemoveHandler(event);
			
			var renderer:IVisualElement = event.renderer;
			
			if (renderer && renderer is Tab) 
			{
				Tab(renderer).removeEventListener(CloseEvent.CLOSE, item_closeHandler);
			}
		}
		
		/**
		 * Handle the Tab's close button CloseEvent.CLOSE by retrieving the index 
		 * of the Tab within the data group and removing its associated item 
		 * from the data provider which will trigger the removal of the Tab from 
		 * the TabBar. That item can be a simple string or a view from a 
		 * ViewStack component.
		 * 
		 * @param event The CloseEvent object.
		 */
		protected function item_closeHandler(event:CloseEvent):void 
		{
			var index:Number = event.detail;
			
			if ((dataProvider != null) && (index >= 0) && (index < dataProvider.length)) 
				dataProvider.removeItemAt(index);
		}
	}
}
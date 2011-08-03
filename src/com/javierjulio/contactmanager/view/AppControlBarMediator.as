package com.javierjulio.contactmanager.view
{
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import com.javierjulio.contactmanager.ApplicationFacade;
	import com.javierjulio.contactmanager.model.ContactProxy;
	import com.javierjulio.contactmanager.view.components.AppControlBar;
	import com.javierjulio.contactmanager.view.events.ContactEvent;
	import com.javierjulio.contactmanager.view.events.SearchEvent;
	
	public class AppControlBarMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Storage for the logger instance.
		 */
		private static const LOGGER:ILogger = Log.getLogger("com.javierjulio.contactmanager.view.AppControlBarMediator");
		
		/**
		 * An easy hook to retrieving this mediator by name.
		 * 
		 * @default "AppControlBarMediator"
		 */
		public static const NAME:String = "AppControlBarMediator";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param viewComponent The viewComponent instance to mediate.
		 */
		public function AppControlBarMediator(viewComponent:AppControlBar) 
		{
			super(NAME, viewComponent);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  view
		//----------------------------------
		
		/**
		 * Cast the viewComponent to its actual type.
		 * 
		 * @return The viewComponent cast as AppControlBar
		 */
		protected function get view():AppControlBar 
		{
			return viewComponent as AppControlBar;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Handle the registration state by setting up mediators for all children 
		 * of this application and retrieving any dependencies such as proxies.
		 */
		override public function onRegister():void 
		{
			super.onRegister();
			
			view.addEventListener(ContactEvent.ADD, addContactHandler);
			view.addEventListener(SearchEvent.SEARCH, searchHandler);
		}
		
		/**
		 * Handle the removal state by cleaning up and removing any dependencies 
		 * and event handlers.
		 */
		override public function onRemove():void 
		{
			super.onRemove();
			
			view.removeEventListener(ContactEvent.ADD, addContactHandler);
			view.removeEventListener(SearchEvent.SEARCH, searchHandler);
			
			setViewComponent(null);
		}
		
		/**
		 * List all notifications this Mediator is interested in.
		 * 
		 * @return The list of nofitication names
		 */
		override public function listNotificationInterests():Array 
		{
			return [
				
			];
		}
		
		/**
		 * Handle all notifications this Mediator is interested in.
		 * 
		 * @param note The notification to be handled.
		 */
		override public function handleNotification(note:INotification):void 
		{
			/*
			switch (note.getName()) 
			{
				case "":
					
					break;
				
			}
			*/
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When the user wants to add a contact we send a notification named 
		 * OPEN_CONTACT_EDITOR.
		 * 
		 * @param event The ContactEvent object.
		 */
		protected function addContactHandler(event:ContactEvent):void 
		{
			sendNotification(ApplicationFacade.OPEN_CONTACT_EDITOR);
		}
		
		/**
		 * When the user completes a search entry we send a notification named 
		 * SEARCH_CONTACTS with a body being the entry they typed.
		 * 
		 * @param event The SearchEvent object.
		 */
		protected function searchHandler(event:SearchEvent):void 
		{
			sendNotification(ApplicationFacade.SEARCH_CONTACTS, event.entry);
		}
	}
}
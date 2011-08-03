package com.javierjulio.contactmanager.view
{
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import com.javierjulio.contactmanager.ApplicationFacade;
	import com.javierjulio.contactmanager.model.ContactProxy;
	import com.javierjulio.contactmanager.view.components.ContactList;
	import com.javierjulio.contactmanager.view.events.ContactEvent;
	
	public class ContactListMediator extends Mediator
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
		private static const LOGGER:ILogger = Log.getLogger("com.javierjulio.contactmanager.view.ContactListMediator");
		
		/**
		 * An easy hook to retrieving this mediator by name.
		 * 
		 * @default "ContactListMediator"
		 */
		public static const NAME:String = "ContactListMediator";
		
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
		public function ContactListMediator(viewComponent:ContactList) 
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
		 * @return The viewComponent cast as ContactList
		 */
		protected function get view():ContactList 
		{
			return viewComponent as ContactList;
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
			
			view.addEventListener(ContactEvent.EDIT, editContactHandler);
			view.addEventListener(ContactEvent.FILTER, filterContactsHandler);
		}
		
		/**
		 * Handle the removal state by cleaning up and removing any dependencies 
		 * and event handlers.
		 */
		override public function onRemove():void 
		{
			super.onRemove();
			
			view.removeEventListener(ContactEvent.EDIT, editContactHandler);
			view.removeEventListener(ContactEvent.FILTER, filterContactsHandler);
			
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
				ContactProxy.CONTACTS_LOADED
			];
		}
		
		/**
		 * Handle all notifications this Mediator is interested in.
		 * 
		 * @param note The notification to be handled.
		 */
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				case ContactProxy.CONTACTS_LOADED:
					view.contacts = ArrayCollection(note.getBody());
					break;
				
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When the user requests to edit a contact we send a notification named 
		 * OPEN_CONTACT_EDITOR with a body of the contact object to be edited.
		 * 
		 * @param event The ContactEvent object.
		 */
		protected function editContactHandler(event:ContactEvent):void 
		{
			sendNotification(ApplicationFacade.OPEN_CONTACT_EDITOR, event.contact);
		}
		
		/**
		 * When the user requests to filter the collection of contacts by department 
		 * we send a notification named FILTER_CONTACTS with a body of the filter 
		 * they selected.
		 * 
		 * @param event The ContactEvent object.
		 */
		protected function filterContactsHandler(event:ContactEvent):void 
		{
			sendNotification(ApplicationFacade.FILTER_CONTACTS, view.selectedFilter);
		}
	}
}
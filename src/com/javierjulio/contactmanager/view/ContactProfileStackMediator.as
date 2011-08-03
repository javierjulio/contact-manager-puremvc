package com.javierjulio.contactmanager.view
{
	import com.javierjulio.contactmanager.ApplicationFacade;
	import com.javierjulio.contactmanager.model.ContactProxy;
	import com.javierjulio.contactmanager.model.vo.ContactVO;
	import com.javierjulio.contactmanager.view.components.ContactProfile;
	import com.javierjulio.contactmanager.view.components.ContactProfileStack;
	import com.javierjulio.contactmanager.view.events.ContactEvent;
	
	import mx.core.INavigatorContent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ContactProfileStackMediator extends Mediator
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
		private static const LOGGER:ILogger = Log.getLogger("com.javierjulio.contactmanager.view.ContactProfileStackMediator");
		
		/**
		 * An easy hook to retrieving this mediator by name.
		 * 
		 * @default "ContactProfileStackMediator"
		 */
		public static const NAME:String = "ContactProfileStackMediator";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Storage for the ContactProxy instance.
		 * 
		 * @default null
		 */
		protected var contactProxy:ContactProxy;
		
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
		public function ContactProfileStackMediator(viewComponent:ContactProfileStack) 
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
		 * @return The viewComponent cast as ContactProfileStack
		 */
		protected function get view():ContactProfileStack 
		{
			return viewComponent as ContactProfileStack;
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
			
			contactProxy = facade.retrieveProxy(ContactProxy.NAME) as ContactProxy;
			
			view.addEventListener(ContactEvent.DELETE, deleteContactHandler);
			view.addEventListener(ContactEvent.SAVE, saveContactHandler);
		}
		
		/**
		 * Handle the removal state by cleaning up and removing any dependencies 
		 * and event handlers.
		 */
		override public function onRemove():void 
		{
			super.onRemove();
			
			view.removeEventListener(ContactEvent.DELETE, deleteContactHandler);
			view.removeEventListener(ContactEvent.SAVE, saveContactHandler);
			
			setViewComponent(null);
			
			contactProxy = null;
		}
		
		/**
		 * List all notifications this Mediator is interested in.
		 * 
		 * @return The list of nofitication names
		 */
		override public function listNotificationInterests():Array 
		{
			return [
				ApplicationFacade.OPEN_CONTACT_EDITOR, 
				ContactProxy.CONTACT_REMOVED, 
				ContactProxy.CONTACT_SAVED
			];
		}
		
		/**
		 * Handle all notifications this Mediator is interested in.
		 * 
		 * @param note A notification to be handled.
		 */
		override public function handleNotification(note:INotification):void 
		{
			var contact:ContactVO;
			var tab:ContactProfile;
			
			switch (note.getName()) 
			{
				case ApplicationFacade.OPEN_CONTACT_EDITOR:
					// if no body is provided then the user wishes to 
					// create a new contact, so we need a blank object
					contact = (note.getBody() != null) 
								? ContactVO(note.getBody()) 
								: new ContactVO();
					
					// retrieve tab by its associated contact object and if 
					// its defined user wants to edit that existing contact 
					// otherwise we just created a blank one earlier 
					// since the user wants to create a new contact
					tab = view.getContactProfile(contact);
					view.selectedChild = (tab == null) 
											? INavigatorContent(view.addContactProfile(contact)) 
											: INavigatorContent(tab);
					break;
				
				case ContactProxy.CONTACT_REMOVED:
					contact = ContactVO(note.getBody());
					
					view.removeContactProfile(contact);
					
					// since a contact has been deleted we need to update 
					// the list with a new set of results
					sendNotification(ApplicationFacade.SEARCH_CONTACTS);
					break;
				
				case ContactProxy.CONTACT_SAVED:
					contact = ContactVO(note.getBody());
					
					tab = view.getContactProfile(contact);
					
					if (tab) 
					{
						tab.saved();
					}
					
					// since a contact has been saved we need to update the list 
					// with a new set of results because for example a name 
					// could have been changed
					sendNotification(ApplicationFacade.SEARCH_CONTACTS);
					break;
				
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When the user requests to delete a contact we have the ContactProxy 
		 * remove the contact from the service.
		 * 
		 * @param event The ContactEvent object.
		 */
		protected function deleteContactHandler(event:ContactEvent):void 
		{
			contactProxy.remove(event.contact);
		}
		
		/**
		 * When the user requests to save a contact we have the ContactProxy save 
		 * it with the service.
		 * 
		 * @param event The ContactEvent object.
		 */
		protected function saveContactHandler(event:ContactEvent):void 
		{
			contactProxy.save(event.contact);
		}
	}
}
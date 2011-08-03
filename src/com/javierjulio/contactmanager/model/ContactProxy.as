package com.javierjulio.contactmanager.model
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import com.javierjulio.contactmanager.model.vo.ContactVO;
	import com.javierjulio.contactmanager.model.services.MockContactService;
	
	public class ContactProxy extends Proxy
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Notification name used when specified contact is deleted.
		 * 
		 * @default "contactRemoved"
		 */
		public static const CONTACT_REMOVED:String = "contactRemoved";
		
		/**
		 * Notification name used when specified contact is saved.
		 * 
		 * @default "contactSaved"
		 */
		public static const CONTACT_SAVED:String = "contactSaved";
		
		/**
		 * Notification name used when contacts are loaded by name.
		 * 
		 * @default "contactsLoaded"
		 */
		public static const CONTACTS_LOADED:String = "contactsLoaded";
		
		/**
		 * @private
		 * Storage for the logger instance.
		 */
		private static const LOGGER:ILogger = Log.getLogger("com.javierjulio.contactmanager.model.ContactProxy");
		
		/**
		 * An easy hook to retrieving this proxy by name.
		 * 
		 * @default "ContactProxy"
		 */
		public static const NAME:String = "ContactProxy";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Storage for the last name look up so the collection of contacts can be 
		 * reloaded from the service.
		 * 
		 * @default ""
		 */
		protected var lastNameLookUp:String = "";
		
		/**
		 * Storage for the MockFileService used to save, remove or load contacts.
		 * 
		 * @default null
		 */
		protected var service:MockContactService;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function ContactProxy()
		{
			super(NAME, new ArrayCollection());
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  contacts
		//----------------------------------
		
		/**
		 * The collection of contacts.
		 */
		public function get contacts():ArrayCollection 
		{
			return data as ArrayCollection;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Handle the registration state by retrieving any proxies we need.
		 */
		override public function onRegister():void 
		{
			super.onRegister();
			
			service = new MockContactService();
			service.addEventListener(FaultEvent.FAULT, faultHandler);
			service.addEventListener(ResultEvent.RESULT, resultHandler);
		}
		
		/**
		 * Handle the removal state by cleaning up.
		 */
		override public function onRemove():void 
		{
			super.onRemove();
			
			service.removeEventListener(FaultEvent.FAULT, faultHandler);
			service.removeEventListener(ResultEvent.RESULT, resultHandler);
			service = null;
			
			setData(null);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Loads a collection of contacts by name and when loaded successfully a 
		 * notification named CONTACTS_LOADED is sent containing the contacts 
		 * collection as the body.
		 * 
		 * @param name The name to search by.
		 */
		public function loadByName(name:String=""):void 
		{
			lastNameLookUp = name;
			
			var token:AsyncToken = service.getContactsByName(name);
			token.method = "getContactsByName";
		}
		
		/**
		 * Reloads a collection of contacts using the last name lookup stored 
		 * when previously doing a call to the <code>loadByName</code> method.
		 * When loaded successfully a notification named CONTACTS_LOADED is sent 
		 * containing the contacts collection as the body.
		 */
		public function refresh():void 
		{
			if (lastNameLookUp) 
			{
				var token:AsyncToken = service.getContactsByName(lastNameLookUp);
				token.method = "getContactsByName";
			}
		}
		
		/**
		 * Removes the specified contact and when removed successfully a 
		 * notification named CONTACT_REMOVED is sent containing the contact object 
		 * as the body.
		 * 
		 * @param contact The contact object to be removed.
		 */
		public function remove(contact:ContactVO):void 
		{
			LOGGER.info("Attempting to remove contact {0} named {1}.", 
				contact.id, contact.fullName);
			
			var token:AsyncToken = service.remove(contact);
			token.method = "remove";
			token.contact = contact;
		}
		
		/**
		 * Saves the specified contact and when saved successfully a notification 
		 * named CONTACT_SAVED is sent containing the contact object as the body.
		 * 
		 * @param contact The contact object to be saved.
		 */
		public function save(contact:ContactVO):void 
		{
			LOGGER.info("Attempting to save contact {0} named {1}.", 
				contact.id, contact.fullName);
			
			var token:AsyncToken = service.save(contact);
			token.method = "save";
			token.contact = contact;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When a service call has failed we alert the error message to the user. 
		 * Ideally here you would send a specific notification indicating failure.
		 * 
		 * @param event The FaultEvent object.
		 */
		protected function faultHandler(event:FaultEvent):void 
		{
			Alert.show("An error occurred processing contact request.", "ContactProxy Error");
		}
		
		/**
		 * When the service call was successful we handle the appropriate method 
		 * and take whatever necessary action for that method.
		 * 
		 * @param event The ResultEvent object.
		 */
		protected function resultHandler(event:ResultEvent):void 
		{
			var method:String = event.token.method;
			var contact:ContactVO;
			
			switch (method) 
			{
				case "getContactsByName":
					// proxy has a public data property with traditional 
					// setter and getter methods but we want to expose the 
					// contacts collection as read only so by setting data, 
					// the next time the contacts property is called it'll 
					// be retrieved
					setData(ArrayCollection(event.result));
					
					LOGGER.info("{0} contacts loaded successfully.", contacts.length);
					
					sendNotification(CONTACTS_LOADED, contacts);
					break;
				
				case "remove":
					contact = ContactVO(event.token.contact);
					
					LOGGER.info("The contact named {0} has been removed.", contact.fullName);
					
					// removal was successful, since we are given the contact 
					// object pass it along anyway if it needs to be used, 
					// for example, indicating through a message the name 
					// of the contact that was removed successfully
					sendNotification(CONTACT_REMOVED, contact);
					break;
				
				case "save":
					var originalContact:ContactVO = event.token.contact;
					
					contact = ContactVO(event.result);
					
					// when saving a new contact, the view will create its 
					// own contact object instance, but the service returns 
					// its own instance, so we need to make sure to keep 
					// ours updated with the new id
					originalContact.id = contact.id;
					
					LOGGER.info("The contact named {0} with an id of {1} has been saved.", 
						contact.fullName, contact.id);
					
					// save was successful, since we are given the contact 
					// object pass it along anyway if it needs to be used, 
					// for example, indicating through a message the name 
					// of the contact that was saved successfully
					sendNotification(CONTACT_SAVED, contact);
					break;
				
			}
		}
	}
}
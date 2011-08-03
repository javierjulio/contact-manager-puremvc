package com.javierjulio.contactmanager
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import com.javierjulio.contactmanager.controller.*;
	import com.javierjulio.contactmanager.model.ContactProxy;
	
	public class ApplicationFacade extends Facade
	{
		//--------------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //--------------------------------------------------------------------------
		
		// Here's where we add our application level notification name constants
		
		/**
		 * The notification name to filter the collection of contacts based on an 
		 * enum filter.
		 * 
		 * @default "filterContacts"
		 */
		public static const FILTER_CONTACTS:String = "filterContacts";
		
		/**
		 * The notification name to populate or refresh the ContactList view 
		 * component with data from the search entry specified.
		 * 
		 * @default "searchContacts"
		 */
		public static const SEARCH_CONTACTS:String = "searchContacts";
		
		/**
		 * The notification name to open a contact editor form.
		 * 
		 * @default "openContactEditor"
		 */
		public static const OPEN_CONTACT_EDITOR:String = "openContactEditor";
		
		/**
		 * The notification name used when starting up the application.
		 * 
		 * @default "startup"
		 */
		public static const STARTUP:String = "startup";
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns an instance of the ApplicationFacade by the key specified. If no 
		 * instance was found by that key one is created and maintained in a map so 
		 * its retrievable at a later point by that key. The key is typically a UID 
		 * or some other unique value such as a date/time string.
		 * 
		 * @param key The unique key for creating the multiton instance.
		 * 
		 * @return The multiton ApplicationFacade instance
		 */
		public static function getInstance(key:String):ApplicationFacade 
		{
			// in the Standard version of the framework you would just inerhit an 
			// "instance" variable (Singleton) whereas the MultiCore version 
			// has an "instanceMap" array (Multiton) so it can manage multiple 
			// instances of the Facade this way the application and the modules 
			// loaded, all each using PureMVC have their own "Core" without 
			// overwriting one another
			if (instanceMap[key] == null) 
				instanceMap[key] = new ApplicationFacade(key);
			
			return instanceMap[key] as ApplicationFacade;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param key The key for creating a unique core in PureMVC. The key is 
		 * typically a UID or some other unique value such as a date/time string.
		 */
		public function ApplicationFacade(key:String)
		{
			super(key);
		}
		
		/**
		 * The view hierarchy has been built, so start the application.
		 * 
		 * @param app The application view instance.
		 */
		public function startUp(app:ContactManager):void 
		{
			sendNotification(STARTUP, app);
		}
		
	    //--------------------------------------------------------------------------
	    //
	    //  Overridden methods
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * Register Commands with the Controller.
		 */
		override protected function initializeController():void 
		{
			super.initializeController();
			
			registerCommand(STARTUP, StartUpCommand);
			
			registerCommand(FILTER_CONTACTS, FilterContactsCommand);
			registerCommand(SEARCH_CONTACTS, SearchContactsCommand);
			
			registerCommand(ContactProxy.CONTACTS_LOADED, FilterContactsCommand);
		}
	}
}
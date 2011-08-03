package com.javierjulio.contactmanager.controller
{
	import com.javierjulio.contactmanager.model.ContactProxy;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class SearchContactsCommand extends SimpleCommand 
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
		private static const LOGGER:ILogger = Log.getLogger("com.javierjulio.contactmanager.controller.SearchContactsCommand");
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When executed this command will retrieve the ContactProxy and if a search 
		 * entry is provided it will load a collection of contacts by that search 
		 * entry otherwise the list is refreshed using the last search entry stored.
		 */
		override public function execute(notification:INotification):void 
		{
			var searchEntry:String = notification.getBody() as String;
			var contactProxy:ContactProxy = facade.retrieveProxy(ContactProxy.NAME) as ContactProxy;
			
			// retrieve contacts by the search entry that has been provided
			if (searchEntry) 
			{
				LOGGER.info("Loading contacts by the following search entry: {0}", searchEntry);
				
				contactProxy.loadByName(searchEntry);
			} 
			else // otherwise refresh using the last search entry that was made 
			{
				LOGGER.info("Refreshing the current contacts search resultset.");
				
				contactProxy.refresh();
			}
		}
	}
}
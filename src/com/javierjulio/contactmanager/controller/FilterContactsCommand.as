package com.javierjulio.contactmanager.controller
{
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import com.javierjulio.contactmanager.model.ContactFilterProxy;
	import com.javierjulio.contactmanager.model.enum.IEnum;
	
	public class FilterContactsCommand extends SimpleCommand 
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
		private static const LOGGER:ILogger = Log.getLogger("com.javierjulio.contactmanager.controller.FilterContactsCommand");
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When executed this command will retrieve the ContactFilterProxy and if a 
		 * filter is provided it will fillter a collection of contacts by that 
		 * provided enum otherwise the list is refreshed using the current selected 
		 * filter.
		 */
		override public function execute(notification:INotification):void 
		{
			var filter:IEnum = notification.getBody() as IEnum;
			var contactFilterProxy:ContactFilterProxy = facade.retrieveProxy(ContactFilterProxy.NAME) as ContactFilterProxy;
			
			if (filter) 
			{
				LOGGER.info("Filtering contacts by the following department filter: {0}", filter.label);
				
				contactFilterProxy.filterBy(filter);
			} 
			else 
			{
				filter = contactFilterProxy.selectedFilter;
				
				LOGGER.info("Running the last stored selected filter: {0}", filter.label);
				
				contactFilterProxy.filterBy(filter);
			}
		}
	}
}
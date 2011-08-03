package com.javierjulio.contactmanager.controller
{
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import com.javierjulio.contactmanager.model.ContactFilterProxy;
	import com.javierjulio.contactmanager.model.ContactProxy;
	import com.javierjulio.contactmanager.view.AppControlBarMediator;
	import com.javierjulio.contactmanager.view.ApplicationMediator;
	import com.javierjulio.contactmanager.view.ContactListMediator;
	import com.javierjulio.contactmanager.view.ContactProfileStackMediator;
	
	public class StartUpCommand extends SimpleCommand 
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
		private static const LOGGER:ILogger = Log.getLogger("com.javierjulio.contactmanager.controller.StartUpCommand");
		
		//--------------------------------------------------------------------------
	    //
	    //  Overridden methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * When executed this command will create and register all necessary 
		 * proxies and mediators and retrieve any dependency data if needed.
		 */
		override public function execute(notification:INotification):void 
		{
			var app:ContactManager = ContactManager(notification.getBody());
			
			LOGGER.info("Starting up application...");
			
			// register all proxies in order for dependencies
			facade.registerProxy(new ContactProxy());
			facade.registerProxy(new ContactFilterProxy());
			
			// register all mediators for view preparation
			facade.registerMediator(new ApplicationMediator(app));
			facade.registerMediator(new AppControlBarMediator(app.appControlBar));
			facade.registerMediator(new ContactProfileStackMediator(app.contactProfileStack));
			facade.registerMediator(new ContactListMediator(app.contactList));
		}
	}
}
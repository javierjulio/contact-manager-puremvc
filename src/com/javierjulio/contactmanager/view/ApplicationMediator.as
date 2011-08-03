package com.javierjulio.contactmanager.view
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import com.javierjulio.contactmanager.ApplicationFacade;
	import com.javierjulio.contactmanager.model.ContactProxy;
	
	public class ApplicationMediator extends Mediator
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
		private static const LOGGER:ILogger = Log.getLogger("com.javierjulio.contactmanager.view.ApplicationMediator");
		
		/**
		 * An easy hook to retrieving this mediator by name.
		 * 
		 * @default "ApplicationMediator"
		 */
		public static const NAME:String = "ApplicationMediator";
		
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
		public function ApplicationMediator(viewComponent:ContactManager) 
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
		 * @return The viewComponent cast as ContactManager
		 */
		protected function get view():ContactManager 
		{
			return viewComponent as ContactManager;
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
			
			view.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}
		
		/**
		 * Handle the removal state by cleaning up and removing any dependencies 
		 * and event handlers.
		 */
		override public function onRemove():void 
		{
			super.onRemove();
			
			view.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			
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
				ApplicationFacade.SEARCH_CONTACTS, 
				ContactProxy.CONTACTS_LOADED
			];
		}
		
		/**
		 * Handle all notifications this Mediator is interested in.
		 * 
		 * @param note A notification to be handled.
		 */
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				case ApplicationFacade.SEARCH_CONTACTS:
					view.indicateProgess();
					break;
				
				case ContactProxy.CONTACTS_LOADED:
					view.indicateProgess(false);
					break;
				
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When the hits the CMD + T keyboard shortcut (CTRL for Windows) we send 
		 * a notification named OPEN_CONTACT_EDITOR to add a new contact profile 
		 * tab so the user can create a new contact.
		 * 
		 * @param event The KeyboardEvent object.
		 */
		protected function stage_keyDownHandler(event:KeyboardEvent):void 
		{
			if (event.keyCode == Keyboard.T && event.ctrlKey) 
				sendNotification(ApplicationFacade.OPEN_CONTACT_EDITOR);
		}
	}
}
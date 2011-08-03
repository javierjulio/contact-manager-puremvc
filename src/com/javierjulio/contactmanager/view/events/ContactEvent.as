package com.javierjulio.contactmanager.view.events
{
	import flash.events.Event;
	
	import com.javierjulio.contactmanager.model.vo.ContactVO;
	
	public class ContactEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const ADD:String = "addContact";
		public static const DELETE:String = "deleteContact";
		public static const EDIT:String = "editContact";
		public static const FILTER:String = "filterContacts";
		public static const SAVE:String = "saveContact";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function ContactEvent(type:String, 
									contact:ContactVO=null, 
									bubbles:Boolean = true, 
									cancelable:Boolean = true) 
   		{
			super(type, bubbles, cancelable);
			
   			this.contact = contact;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  contact
		//----------------------------------
		
		/**
		 * The contact object.
		 * 
		 * @default null
		 */
		public var contact:ContactVO;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritdoc
		 */
		override public function clone():Event 
		{
			return new ContactEvent(type, contact, bubbles, cancelable);
		}
		
		/**
		 * @inheritdoc
		 */
		override public function toString():String 
		{
			return '[ContactEvent type="' + type + '" contact="' + contact 
				+ '" bubbles="' + bubbles + '" cancelable="' + cancelable + '"]';
		}
	}
}
package com.javierjulio.contactmanager.model.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class ContactVO extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function ContactVO()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  address
		//----------------------------------
		
		/**
		 * The contact's street address.
		 * 
		 * @default null
		 */
		public var address:String;
		
		//----------------------------------
		//  city
		//----------------------------------
		
		/**
		 * The city the contact is located in.
		 * 
		 * @default null
		 */
		public var city:String;
		
		//----------------------------------
		//  department
		//----------------------------------
		
		/**
		 * The contact's department
		 * 
		 * @default null
		 */
		public var department:String;
		
		//----------------------------------
		//  email
		//----------------------------------
		
		/**
		 * The contact's email address.
		 * 
		 * @default null
		 */
		public var email:String;
		
		//----------------------------------
		//  firstName
		//----------------------------------
		
		/**
		 * @private
		 * Storage for the firstName property.
		 */
		private var _firstName:String = "";
		
		/**
		 * The contact's first name.
		 * 
		 * @default ""
		 */
		public function get firstName():String 
		{
			return _firstName;
		}
		
		/**
		 * @private
		 */
		public function set firstName(value:String):void 
		{
			if (_firstName == value) 
				return;
			
			_firstName = value;
			
			dispatchEvent(new Event("fullNameChanged"));
		}
		
		//----------------------------------
		//  fullName
		//----------------------------------
		
		[Bindable(event="fullNameChanged")]
		
		/**
		 * The contact's full name.
		 */
		public function get fullName():String
		{
			return _firstName + " " + _lastName;
		}
		
		//----------------------------------
		//  id
		//----------------------------------
		
		/**
		 * The contact's unique id (auto incremented).
		 * 
		 * @default null
		 */
		public var id:int;
		
		//----------------------------------
		//  lastName
		//----------------------------------
		
		/**
		 * @private
		 * Storage for the lastName property.
		 */
		private var _lastName:String = "";
		
		/**
		 * The contact's last name.
		 * 
		 * @default ""
		 */
		public function get lastName():String 
		{
			return _lastName;
		}
		
		/**
		 * @private
		 */
		public function set lastName(value:String):void 
		{
			if (_lastName == value) 
				return;
			
			_lastName = value;
			
			dispatchEvent(new Event("fullNameChanged"));
		}
		
		//----------------------------------
		//  phone
		//----------------------------------
		
		/**
		 * The contact's phone number.
		 * 
		 * @default null
		 */
		public var phone:String;
		
		//----------------------------------
		//  state
		//----------------------------------
		
		/**
		 * The state the contact is located in.
		 * 
		 * @default null
		 */
		public var state:String;
		
		//----------------------------------
		//  title
		//----------------------------------
		
		/**
		 * The contact's job title.
		 * 
		 * @default null
		 */
		public var title:String;
		
		//----------------------------------
		//  zip
		//----------------------------------
		
		/**
		 * The zip code the contact is located in.
		 * 
		 * @default null
		 */
		public var zip:String;
	}
}
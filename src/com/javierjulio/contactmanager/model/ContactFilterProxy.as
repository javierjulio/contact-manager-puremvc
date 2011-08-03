package com.javierjulio.contactmanager.model
{
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import com.javierjulio.contactmanager.model.enum.DepartmentEnum;
	import com.javierjulio.contactmanager.model.enum.IEnum;
	import com.javierjulio.contactmanager.model.vo.ContactVO;
	
	public class ContactFilterProxy extends Proxy
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Notification name used when contacts are successfully filtered.
		 * 
		 * @default "contactsFiltered"
		 */
		public static const CONTACTS_FILTERED:String = "contactsFiltered";
		
		/**
		 * @private
		 * Storage for the logger instance.
		 */
		private static const LOGGER:ILogger = Log.getLogger("com.javierjulio.contactmanager.model.ContactFilterProxy");
		
		/**
		 * An easy hook to retrieving this proxy by name.
		 * 
		 * @default "ContactFilterProxy"
		 */
		public static const NAME:String = "ContactFilterProxy";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Storage for the ContactProxy instance retrieved on Proxy registration.
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
		 */
		public function ContactFilterProxy()
		{
			super(NAME, DepartmentEnum.defaultEnum());
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  selectedFilter
		//----------------------------------
		
		/**
		 * The current selected filter.
		 * 
		 * @default DepartmentEnum.defaultEnum()
		 */
		public function get selectedFilter():IEnum 
		{
			return data as DepartmentEnum;
		}
		
		/**
		 * @private
		 */
		public function set selectedFilter(value:IEnum):void 
		{
			// value can't be null, use default if data isn't already set
			if (!value && !data) 
				value = DepartmentEnum.defaultEnum();
			
			// if the values are the same cancel out, if the value provided is 
			// null we are happy keeping the current selection
			if (data == value || !value) 
				return;
			
			data = value;
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
			
			contactProxy = facade.retrieveProxy(ContactProxy.NAME) as ContactProxy;
		}
		
		/**
		 * Handle the removal state by cleaning up.
		 */
		override public function onRemove():void 
		{
			super.onRemove();
			
			contactProxy = null;
			setData(null);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Filters the contacts collection based on the DepartmentEnum given.
		 * 
		 * @param filter The DepartmentEnum instance to filter by.
		 */
		public function filterBy(filter:IEnum):void 
		{
			var contacts:ArrayCollection = contactProxy.contacts;
			
			// update our tracker with the new selected filter
			selectedFilter = filter;
			
			// INFO: this is a simple example but can easily be expanded on to 
			// include more filters and even custom sorts.
			
			contacts.filterFunction = departmentFilter;
			contacts.refresh();
			
			LOGGER.info("Filter completed and {0} contacts in collection.", contacts.length);
		}
		
		/**
		 * @private
		 */
		private function departmentFilter(contact:ContactVO):Boolean 
		{
			if (selectedFilter == DepartmentEnum.ALL) 
				return true;
			
			return (contact.department == selectedFilter.label);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
}
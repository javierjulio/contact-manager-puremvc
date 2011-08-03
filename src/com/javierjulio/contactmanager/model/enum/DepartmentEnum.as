package com.javierjulio.contactmanager.model.enum
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	public class DepartmentEnum implements IEnum
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const ALL:DepartmentEnum 					= new DepartmentEnum('All', -1);
		public static const DIRECTORS:DepartmentEnum 			= new DepartmentEnum('Directors', 0);
		public static const SALES:DepartmentEnum 				= new DepartmentEnum('Sales', 1);
		public static const DEVELOPMENT:DepartmentEnum 			= new DepartmentEnum('Development', 2);
		public static const SUPPORT:DepartmentEnum 				= new DepartmentEnum('Support', 3);
		public static const ACCOUNTING:DepartmentEnum 			= new DepartmentEnum('Accounting', 4);
		public static const HUMAN_RESOURCES:DepartmentEnum 		= new DepartmentEnum('Human Resources', 5);
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns the DepartmentEnum instance we should use as a default.
		 * 
		 * @return DepartmentEnum.ALL
		 */
		public static function defaultEnum():DepartmentEnum 
		{
			return ALL;
		}
		
		/**
		 * Creates a collection of all DepartmentEnum objects. Useful as a data 
		 * provider for components like a TabBar or DropDownList.
		 * 
		 * @return An ArrayCollection of DepartmentEnum objects.
		 */
		public static function filterList():IList 
		{
			return new ArrayCollection([ALL, DIRECTORS, SALES, DEVELOPMENT, SUPPORT, ACCOUNTING, HUMAN_RESOURCES]);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor. 
		 * 
		 * @param label The enumerated value label for easy selection.
		 * @param index The index (position) to be placed in.
		 * @param data The data value. Optional.
		 */
		public function DepartmentEnum(label:String, index:Number, data:String=null) 
		{
			super();
			
			this.label = label;
			this.index = index;
			this.data = data;
			
			// if no data value was provided default to the label given
			if (!data) 
				this.data = label;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  data
		//----------------------------------
		
		/**
		 * @private
		 * Storage for the data property.
		 */
		private var _data:String = "";
		
		/**
		 * The data value.
		 * 
		 * @default ""
		 */
		public function get data():String 
		{
			return _data;
		}
		
		/**
		 * @private
		 */
		public function set data(value:String):void 
		{
			if (_data == value) 
				return;
			
			_data = value;
		}
		
		//----------------------------------
		//  index
		//----------------------------------
		
		/**
		 * @private
		 * Storage for the index property.
		 */
		private var _index:Number = -1;
		
		/**
		 * The index (position) this enumerated value is in.
		 * 
		 * @default -1
		 */
		public function get index():Number 
		{
			return _index;
		}
		
		/**
		 * @private
		 */
		public function set index(value:Number):void 
		{
			if (_index == value) 
				return;
			
			_index = value;
		}
		
		//----------------------------------
		//  label
		//----------------------------------
		
		/**
		 * @private
		 * Storage for the label property.
		 */
		private var _label:String = "";
		
		/**
		 * The label used for display for easy selection.
		 */
		public function get label():String 
		{
			return _label;
		}
		
		/**
		 * @private
		 */
		public function set label(value:String):void 
		{
			if (_label == value) 
				return;
			
			_label = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns the string representation (label) of this enum.
		 */
		public function toString():String 
		{
			return label;
		}
	}
}
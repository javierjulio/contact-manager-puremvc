package com.javierjulio.contactmanager.model.enum
{
	public interface IEnum
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  data
		//----------------------------------
		
		/**
		 * The data value.
		 */
		function get data():String;
		
		/**
		 * @private
		 */
		function set data(value:String):void;
		
		//----------------------------------
		//  index
		//----------------------------------
		
		/**
		 * The index (position) this enumerated value is in.
		 */
		function get index():Number;
		
		/**
		 * @private
		 */
		function set index(value:Number):void;
		
		//----------------------------------
		//  label
		//----------------------------------
		
		/**
		 * The label used for display for easy selection.
		 */
		function get label():String;
		
		/**
		 * @private
		 */
		function set label(value:String):void;
	}
}
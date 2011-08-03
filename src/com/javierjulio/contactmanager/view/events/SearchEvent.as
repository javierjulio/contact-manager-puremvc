package com.javierjulio.contactmanager.view.events
{
	import flash.events.Event;
	
	public class SearchEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const SEARCH:String = "search";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function SearchEvent(type:String, 
									entry:String, 
									bubbles:Boolean = true, 
									cancelable:Boolean = true) 
   		{
			super(type, bubbles, cancelable);
			
   			this.entry = entry;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  entry
		//----------------------------------
		
		/**
		 * The search entry.
		 * 
		 * @default null
		 */
		public var entry:String;
		
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
			return new SearchEvent(type, entry, bubbles, cancelable);
		}
		
		/**
		 * @inheritdoc
		 */
		override public function toString():String 
		{
			return '[SearchEvent type="' + type + '" searchStr="' + entry 
				+ '" bubbles="' + bubbles + '" cancelable="' + cancelable + '"]';
		}
	}
}
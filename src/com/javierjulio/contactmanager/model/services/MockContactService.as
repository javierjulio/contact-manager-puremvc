package com.javierjulio.contactmanager.model.services
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.core.mx_internal;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import com.javierjulio.contactmanager.model.vo.ContactVO;
	
	import spark.components.WindowedApplication;
	
	use namespace mx_internal;
	
	public class MockContactService extends EventDispatcher
	{
		/**
		 * Storage for the fault handler function when listening for failed 
		 * service call attempts.
		 * 
		 * @default null
		 */
		protected var faultHandler:Function;
		
		/**
		 * Storage for the fault handler function when listening for failed 
		 * service call attempts.
		 * 
		 * @default null
		 */
		protected var resultHandler:Function;
		
		/**
		 * Storage for the contact XML template used when creating a new contact.
		 */
		protected var template:XML = <contact>
										<id></id>
										<firstName></firstName>
										<lastName></lastName>
										<title></title>
										<phone></phone>
										<email></email>
										<address1></address1>
										<address2></address2>
										<city></city>
										<state></state>
										<zip></zip>
										<department></department>
									</contact>;
		
		/**
		 * Storage for the XML that is read from the local document containing all 
		 * the contact data. When changes are made this instance is updated.
		 * 
		 * @default null
		 */
		protected var xmlDocument:XML;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function MockContactService()
		{
			super();
			
			// since its a mock service, lets load our local data on construction
			var originalDataFile:File = File.applicationDirectory.resolvePath("assets/data/contacts.xml");
			var dataFile:File = File.applicationStorageDirectory.resolvePath("assets/data/contacts.xml");
			
			// if both files exist and we attempt to copy without overwriting an 
			// error will be thrown.. below should only happen the first time
			if (!dataFile.exists) 
				originalDataFile.copyTo(dataFile, true);
			
			// read the file contents and store as an XML object
			var stream:FileStream = new FileStream();
			stream.open(dataFile, FileMode.READ);
			
			xmlDocument = XML(stream.readUTFBytes(stream.bytesAvailable));
			
			stream.close();
			
			// listen for when the app closes so we can save the changes made in 
			// memory to the actual XML file 
			WindowedApplication(FlexGlobals.topLevelApplication).addEventListener(Event.CLOSING, application_closingHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override public function addEventListener(type:String, 
												  listener:Function, 
												  useCapture:Boolean=false, 
												  priority:int=0, 
												  useWeakReference:Boolean=false):void 
		{
			// we just care about the listener since we will be using a Responder 
			// and adding it to our AsyncToken so we don't actually have to add this 
			// event handler since we will call it manually after a delay
			if (type == ResultEvent.RESULT) 
				resultHandler = listener;
			else if (type == FaultEvent.FAULT) 
				faultHandler = listener;
		}
		
		/**
		 * @private
		 */
		override public function removeEventListener(type:String, 
													 listener:Function, 
													 useCapture:Boolean=false):void 
		{
			// we just care about the listener since we will be using a Responder 
			// and adding it to our AsyncToken so we don't actually have to add this 
			// event handler since we will call it manually after a delay
			if (type == ResultEvent.RESULT) 
				resultHandler = null;
			else if (type == FaultEvent.FAULT) 
				faultHandler = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Retrieves all contacts by name by constructing a Contact object for each 
		 * contact XML element defined if its part of the name match.
		 */
		public function getContactsByName(name:String):AsyncToken 
		{
			var contact:ContactVO;
			var contacts:Array = [];
			
			// case insensitive search
			name = name.toLowerCase();
			
			for each (var data:XML in xmlDocument.contact) 
			{
				// continue to the next contact if this one does not contain 
				// a match in first name and last name
				if (data.firstName.text().toLowerCase().indexOf(name) == -1 
					&& data.lastName.text().toLowerCase().indexOf(name) == -1 ) 
				{
					continue;
				}
				
				contact = new ContactVO();
				
				// retrieve a list of the ContactVO property names
				var properties:Array = ObjectUtil.getClassInfo(contact).properties as Array;
				
				for (var i:int = 0; i < properties.length; i++) 
				{
					var property:String = properties[i];
					
					if (data.hasOwnProperty(property)) 
						contact[property] = data[property].text();
				}
				
				contacts.push(contact);
			}
			
			return send(new ArrayCollection(contacts));
		}
		
		/**
		 * Removes a contact from the XML document in memory.
		 */
		public function remove(contact:ContactVO):AsyncToken 
		{
			var elements:XMLList = xmlDocument.contact.(id.text() == contact.id);
			
			if (elements.length() >= 1) 
			{
				// verified: least 1 match found, safe to remove
				delete elements[0];
			}
			
			return send(contact);
		}
		
		/**
		 * Saves a contact by modifying the XML document in memory.
		 */
		public function save(contact:ContactVO):AsyncToken 
		{
			var elements:XMLList = xmlDocument.contact.(id.text() == contact.id);
			var element:XML;
			var createContact:Boolean = false;
			
			// we don't want to assume in our contact lookup to reference 
			// the first array element because its possible our lookup 
			// returns nothing and an error can occur
			if (elements.length() >= 1) 
			{
				element = elements[0];
			} 
			else 
			{
				// retrieve all ids, as we want to use the last id to generate our 
				// new one for this new contact
				var ids:XMLList = xmlDocument.contact.id.text();
				
				// add our new generated id
				contact.id = Number(ids[ids.length() - 1]) + 1;
				
				// otherwise, if no element found then we are attempting 
				// to add a new contact
				element = template.copy();
				
				createContact = true;
			}
			
			// retrieve a list of the ContactVO property names
			var properties:Array = ObjectUtil.getClassInfo(contact).properties as Array;
			
			// for all properties in our contact object, update the same elements 
			// within the contact XML document with the new values
			for (var i:int = 0; i < properties.length; i++) 
			{
				var property:String = properties[i];
				
				// test for a value because if there is none, then the element 
				// will have an explicit value of "null" when we don't want that 
				// if its null then use an empty value, so for example if firstName 
				// is null then when we create a new XML element with an empty value 
				// the XML output will be: <firstName/>
				var value:String = (contact[property]) 
					? contact[property] 
					: "";
				
				// make sure our contact element contains a child named the same 
				// as out contact object property that we want to modify
				if (element.hasOwnProperty(property)) 
				{
					element[property] = value;
				}
			}
			
			if (createContact) 
				xmlDocument = xmlDocument.appendChild(element);
			
			return send(contact);
		}
		
		/**
		 * Helper that creates an AsyncToken and sets a timeout to give the 
		 * feeling of working with a real service asynchronously.
		 * 
		 * @param result The result object for the ResultEvent once the timer 
		 * completes.
		 */
		protected function send(result:Object):AsyncToken
		{
			var token:AsyncToken = new AsyncToken(null);
			
			// using the result and fault handlers provided when adding event 
			// listeners we create a responder and add it on async token so 
			// this way we can handle multiple requests at the same time with 
			// each request being handled appropriately using a token
			token.addResponder(new Responder(resultHandler, faultHandler));
			
			// FORCED RANDOM DELAY
			token._timeoutId = setTimeout(timeoutHandler, 1200, token, result);
			
			return token;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When the application closes, cancel the event so we can safely save the 
		 * changes made to the contacts XML document in memory to disk. We'll 
		 * manually exit the application once its done.
		 * 
		 * @param event The event object.
		 */
		protected function application_closingHandler(event:Event):void 
		{
			event.preventDefault();
			
			var dataFile:File = File.applicationStorageDirectory.resolvePath("assets/data/contacts.xml");
			
			var newXml:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			newXml += xmlDocument.toXMLString();
			newXml = newXml.replace(/\n/g, File.lineEnding);
			
			var stream:FileStream = new FileStream();
			stream.open(dataFile, FileMode.WRITE);
			stream.writeUTFBytes(newXml);
			stream.close();
			
			NativeApplication.nativeApplication.exit();
		}
		
		/**
		 * Handles the completion of a forced delay timeout to mock a service 
		 * request that applies the result to the specified token. The token will 
		 * apply the ResultEvent.RESULT event object to the specified responder.
		 * 
		 * @param token The AsyncToken on which we apply the result.
		 * @param result The result object that could be a value object instance, 
		 * an ArrayCollection instance, etc.
		 */
		protected function timeoutHandler(token:AsyncToken, result:Object):void
		{
			clearTimeout(token._timeoutId);
			
			token.setResult(result);
			
			var event:ResultEvent = new ResultEvent(ResultEvent.RESULT, false, true, result, token);
			token.applyResult(event);
		}
	}
}
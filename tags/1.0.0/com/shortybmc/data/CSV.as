﻿/**
 *   This file is a part of csvlib, written by Marco Müller / http://short-bmc.com
 *
 *   The csvlib is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *	 
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

package com.shortybmc.data
{
	
	
	/**
	 *   TODO Package description ...
	 * 
	 *   @author Marco Müller / http://shorty-bmc.com
	 *   @see RFC 4180 / http://rfc.net/rfc4180.html
	 *   
	 *   @langversion ActionScript 3.0
	 *   @tiptext
	 */
	import flash.net.*
	import flash.events.*
	import com.shortybmc.utils.*;
	
	public class CSV extends URLLoader
	{
		
		
		/**
		 *   TODO Properties description ...
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		private var FieldSeperator		: String
		private var FieldEnclosureToken : String
		private var RecordsetDelimiter	: String
		
		
		/**
		 *   TODO Constructor description ...
		 * 
		 *   @param request URLRequest
		 *   @return no
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function CSV( request : URLRequest = null )
		{
			
			fieldSeperator 		= ','
			fieldEnclosureToken = '"'
			recordsetDelimiter 	= '\r'
			
			if( request )
				load( request )
			this.dataFormat = URLLoaderDataFormat.TEXT
			addEventListener( Event.COMPLETE, decode )
			
		}
		
		// -> getter
		
		/**
		 *   TODO Getter description ...
		 * 
		 *   @param no
		 *   @return String that contains the field seperator
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function get fieldSeperator() : String
		{
			return FieldSeperator
		}
		
		/**
		 *   TODO Getter description ...
		 * 
		 *   @param no
		 *   @return String that contains the field seperator
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function get fieldEnclosureToken() : String
		{
			return FieldEnclosureToken
		}
		
		/**
		 *   TODO Getter description ...
		 * 
		 *   @param no
		 *   @return String that contains the recordset delimiter
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function get recordsetDelimiter() : String
		{
			return RecordsetDelimiter
		}
		
		// -> setter
		
		/**
		 *   TODO Setter description ...
		 * 
		 *   @param value String
		 *   @return no
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function set fieldSeperator( value : String ) : void
		{
			FieldSeperator = value
		}
		
		/**
		 *   TODO Getter description ...
		 * 
		 *   @param no
		 *   @return String that contains the field seperator
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function set fieldEnclosureToken( value : String ) : void
		{
			FieldEnclosureToken = value
		}
		
		/**
		 *   TODO Setter description ...
		 * 
		 *   @param value String
		 *   @return no
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function set recordsetDelimiter( value : String ) : void
		{
			RecordsetDelimiter = value
		}
		
		// -> public methods
		
		/**
		 *   TODO Public method description ...
		 * 
		 *   @param no
		 *   @return no
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		private function decode( event : Event = null ) : void
		{
			var count  : uint = 0
			var result : Array = new Array ()
			data = data.toString().split( recordsetDelimiter );
			for(  var i : uint = 0; i < data.length; i++ )
			{
				if( !Boolean( count % 2 ) )
					 result.push( data[ i ] )
				else
					 result[ result.length - 1 ] += data[ i ]
				count += StringUtils.count( data[ i ] , fieldEnclosureToken )
			}
			data = result.filter( isNotEmptyRecord )
			data.forEach( fieldBuilder )
		}
		
		// -> private methods
		
		/**
		 *   TODO Private method description ...
		 * 
		 *   @param element *
		 *   @param index int
		 *   @param arr Array
		 *   @return Boolean true if recordset has values, false if not
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		private function isNotEmptyRecord( element : *, index : int, arr : Array ) : Boolean
		{
			return Boolean( StringUtils.trim( element ) );
		}
		
		/**
		 *   TODO Private method description ...
		 * 
		 *   @param element *
		 *   @param index int
		 *   @param arr Array
		 *   @return Boolean true if recordset has values, false if not
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		private function fieldBuilder( element : *, index : int, arr : Array ) : void
		{	
			var count  : uint  = 0;
			var result : Array = new Array ();
			var tmp    : Array = element.split( fieldSeperator );
			for( var i : uint = 0; i < tmp.length; i++ )
			{
				if( !Boolean( count % 2 ) )
					 result.push( StringUtils.trim( tmp[ i ] ) );
				else
					 result[ result.length - 1 ] += fieldSeperator + tmp[ i ];
				count += StringUtils.count( tmp[ i ] , fieldEnclosureToken );
			}
			arr[ index ] = result
		}
		
		/**
		 *   TODO Public method description ...
		 * 
		 *   @deprecated yes
		 *   @param no
		 *   @return String that contais the dumped array
		 *   
		 *   @langversion ActionScript 3.0
		 *   @tiptext
		 */
		public function dump() : String
		{
			var  result : String = 'data:Array -> [\r'
			for ( var i : int = 0; i < data.length; i++ )
			{
				result += '\t[' + i + ']:Array -> [\r'
				for (var j : uint = 0; j < data[i].length; j++ ) result += '\t\t[' + j + ']:String -> ' + data[ i ][ j ] + '\r'
				result += ( '\t]\r' )
			}
			result += ']\r'
			return result
		}
		
	}
	
}
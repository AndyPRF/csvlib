### Import rule: ###
The first line in all your applications is:
```
import com.shortybmc.data.parser.CSV;
```
### Decode: ###
  * External file by **constructor**  _([URLRequest-Object](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/URLRequest.html))_
```
var csv : CSV = new CSV( new URLRequest('example-1.csv') );
csv.addEventListener ( Event.COMPLETE, completeHandler );
function completeHandler ( event : Event )
{
	trace ( csv.data.join('\r') )
	// do something ...
}
```
  * External file by **load** _([URLRequest-Object](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/URLRequest.html))_
```
var csv : CSV = new CSV();
csv.addEventListener ( Event.COMPLETE, completeHandler );
csv.load ( new URLRequest('example-2.csv') );
function completeHandler ( event : Event )
{
	trace ( csv.data.join('\r') );
	// do something ...
}
```
  * Internal csv formated string
```
var csv : CSV = new CSV();
csv.data = 'Year,Make,Model\r1997,Ford,E350\r2000,Mercury,Cougar\r'
csv.decode()

trace ( 'Is array: ' + (csv.data is Array) + '\r' + csv.header + '\r' + csv.data.join('\n') );

// -> trace
// Is array: true
// Year,Make,Model
// 1997,Ford,E350
// 2000,Mercury,Cougar
```
### Encode ###
  * To CSV formated string
```
var csv : CSV = new CSV();
csv.embededHeader = false
csv.header = ['label 1', 'label 2', 'label 3', 'label 4' ]
csv.addRecordSet( ['1','b','c','k'] )
csv.addRecordSet( ['0','b','g','d'], -1 )

csv.encode()
trace ( 'Is string: ' + (csv.data is String) + '\r' + csv.data );

// -> trace
// Is string: true
// label 1,label 2,label 3,label 4
// 0,b,g,d
// 1,b,c,k
```
### Parse with individual filed seperator, recordset delimiter or quote tokens: ###
If you want to change these default parser values, you must load your file with the "load" method, after initialization, **before** the load call! All other will be ignored.
```
csv = new CSV();
csv.fieldSeperator = ';'
csv.fieldEnclosureToken= '\''
csv.recordsetDelimiter= '#'
csv.addEventListener( Event.COMPLETE, completeHandler );
csv.load( new URLRequest('example-6.csv') )
```
### Header functions and manipulations: ###
All headers after initialisation are **locked**! If you need to overwrite, use "overwriteHeader = true".

Default header settings are:
  * embededHeader = true
  * overwriteHeader = false

> Add your own header, if **no** embeded header exists
```
var csv : CSV = new CSV();
csv.embededHeader = false
csv.header = ['label 1', 'label 2', 'label 3', 'label 4']
csv.addEventListener( Event.COMPLETE, completeHandler );
csv.load ( new URLRequest('example-8.csv') );
```

> Delete a embeded header
```
var csv : CSV = new CSV();
csv.headerOverwrite = true
csv.addEventListener( Event.COMPLETE, completeHandler );
csv.load ( new URLRequest('example-7.csv') );
```

> Delete/overwrite a embeded header with your own
```
var csv : CSV = new CSV();
csv.headerOverwrite = true
csv.header = ['My Year', 'My Make', 'My Model']
csv.addEventListener( Event.COMPLETE, completeHandler );
csv.load ( new URLRequest('example-7.csv') );
```
### Data functions and manipulations: ###
  * **addRecordSet** ( <recordset : array>, <index : int = null> ) : void
    * the first argument is your recordset
    * the second argument is the index position to add recordset at. If index ist bigger than data array length, it will be pushed at the end of these. Negative values are supportet! Default is null eq. the recorsed will be pushed.
```
var csv : CSV = new CSV();
csv.embededHeader = false
csv.header = ['label 1', 'label 2', 'label 3', 'label 4' ]
csv.addRecordSet( ['1','b','c','k'] )
csv.addRecordSet( ['0','b','g','d'], -1 )
csv.addRecordSet( ['2','b','c','d'],  3 )
csv.addRecordSet( ['3','b','j','d'] )

trace ( csv.header );
trace ( csv.data.join('\n') );

// -> trace
// label 1,label 2,label 3,label 4
// 0,b,g,d
// 1,b,c,k
// 2,b,c,d
// 3,b,j,d
```

  * **getRecordSet** ( <index : int> ) : Array
    * first argument is the index position to give the recordset
    * return is a recordset array
```
csv.getRecordSet( 0 )

// -> trace
// 0,b,g,d
```

  * **deleteRecordSet** ( <index : int> ) : Boolean
    * first argument is the index position to delete
    * method returns true or false on operation complete
```
if ( csv.deleteRecordSet( 0 ) )
	 trace ( csv.data.join('\n') );

// -> trace
// 1,b,c,k
// 2,b,c,d
// 3,b,j,d
```

  * **search** ( <needle : (string|array) >, <removeDuplicates : Boolean = true> ) : void
    * first argument can be a string, or a 1D array that includes a list of needles
    * the second argument removes duplicates. Default is true.
```
// with duplicates
var filtered : Array = csv.search( ['1', 'k', 'k', '3'], false )
trace( filtered.join('\n') )

// -> trace
// 1,b,c,k
// 1,b,c,k
// 1,b,c,k
// 3,b,j,d

// without duplicates
var filtered : Array = csv.search( ['1', 'k', 'k', '3'] )
trace( filtered.join('\n') )

// -> trace
// 1,b,c,k
// 3,b,j,d
```

  * **sort** ( <needle : (string|array) >, <removeDuplicates : Boolean = true> ) : void
    * first argument can be a string, or a 1D array that includes a list of needles
    * the second argument removes duplicates. Default is true.
```
var csv : CSV = new CSV();
csv.embededHeader = false
csv.addEventListener( Event.COMPLETE, sortExample );
csv.load ( new URLRequest('example-8.csv') );

// ascending sort by index position
csv.sort( 0 );
trace ( csv.data.join('\n') )

// -> trace
// 1870,Chris,Andre,Collin
// 1996,Peter,Fritz,Anton
// 1997,Daniel,Olga,Sula
// 1999,John,Vanessa,Johanna
// 2007,Danny,Pierre,0815

// descending sort by index position
csv.sort( 0, 'DES' );
trace ( csv.data.join('\n') )

// -> trace
// 2007,Danny,Pierre,0815
// 1999,John,Vanessa,Johanna
// 1997,Daniel,Olga,Sula
// 1996,Peter,Fritz,Anton
// 1870,Chris,Andre,Collin

// ascending sort by filed name
csv.header = ['year', 'name', 'surname', 'friends' ]
csv.sort('friends' );
trace( csv.data.join('\n') );

// -> trace
// 2007,Danny,Pierre,0815
// 1996,Peter,Fritz,Anton
// 1870,Chris,Andre,Collin
// 1999,John,Vanessa,Johanna
// 1997,Daniel,Olga,Sula

// descending sort by field name
csv.sort('friends', 'DES' );
trace (csv.data.join('\n'));

// -> trace
// 1997,Daniel,Olga,Sula
// 1999,John,Vanessa,Johanna
// 1870,Chris,Andre,Collin
// 1996,Peter,Fritz,Anton
// 2007,Danny,Pierre,0815

```

.
**What is csvlib?**

It implements a few advanced features which help make your life easier when working with CSV data in Actionscript[?](http://de.wikipedia.org/wiki/ActionScript). [Here](http://code.google.com/p/csvlib/wiki/QuickStart) you can find a [QuickStart](http://code.google.com/p/csvlib/wiki/QuickStart) tutorial to use csvlib.


### Features of current version ###

  * Full [RFC 4180](http://tools.ietf.org/html/rfc4180) conform
    * Multiline recordsets/field values
    * Double and single quote enclosures
    * Enclosed field values and commas
    * Much more of RFC 4180 compatibility conditions
  * Working with individual
    * field seperator
    * recordset delimiter
    * quote tokens _(double/single)_
  * A data-model that differentiates between data & header
  * Simple header and data manipulation
  * Sort data by field name or index position
  * Searching for field values
  * Encoding of csv objects content _(header & data array)_ to a csv formated string _(ready for send)_
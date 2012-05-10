cftag2cfscript
==============

<h2>The cftag to cfscript converter for Coldfusion cfcs</h2>

With the arrival of Coldfusion 9 we can finally build our cfcs in cfscript. I've found that there is a significant speed increase when converting an existing tag based cfc to cfscript. 

Converting tag-based CF to script based CF is time consuming. This project aims to make it dead simple. Its not there yet, but maybe with your help we can reach that goal. 

The conversion is a two step process:
Step 1: convert existing tag code into a valid XML document. 
Step 2: parse the XML into cfscript
Step 3: Profit.


I am using the XML to tokenize the existing tags so that the data is easier to work with. Legacy CF can be difficult to massage into valid XML however. There exists some syntax that CF will happily compile, but just shouldn't be. A great example I found was:

<cfloop array=#myArray# index="i" >

Notice the missing quotes for #myArray#?  CF doesn't care, but the xmlParse function will. Some editing of existing code will be necessary. 
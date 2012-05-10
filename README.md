cftag2cfscript
==============

<h2>The cftag to cfscript converter for Coldfusion</h2>

With the arrival of Coldfusion 9 we can finally build our cfcs in cfscript. I've found that there is a significant speed increase when converting an existing tag based cfc to cfscript. 

Converting tag-based CF to script based CF is time consuming. This project aims to make it dead simple. Its not there yet, but maybe with your help we can reach that goal. 

<h3>The Process</h3>

Converting a cfc from tags to cfscript is as simple as:
<code>
// create the cftag2cfscript object
cftag2cfscript = new cftag2cfscript();
// load the string to be converted
str = fileRead(expandPath('test.cfc'));
// convert!
newStr = cftag2cfscript.toCFscript(str);
// print it!
writeOutput(newStr);
</code>

I am using XML to tokenize the existing tags so that the data is easier to work with. Internally the conversion from tags to script is a two step process:
Step 1: convert existing tag code into a valid XML document. 
Step 2: parse the XML into cfscript
Step 3: Profit. 

<h3>Issues</h3>
<ul>
<li>
Legacy CF can be difficult to massage into valid XML. There exists some syntax that CF will happily compile, but just shouldn't be. A great example I found was:
<code>
<cfloop array=#myArray# index="i" >
</code>
Notice the missing quotes for #myArray#?  CF doesn't care, but the xmlParse function will. Some editing of existing code will be necessary to allow for valid XML. 
</li>
<li>
cftag2cfscript aims to create valid cfscript that WORKS. Sometimes it does this gracefully. Sometimes it does this with ugly hacking. You will want to hand-optimize your converted code and of course regression test it. Make sure to search your converted code for "UNABLE TO PARSE" and "TODO". cftag2cfscript will insert these comments in problem areas. 
</li>
</ol>




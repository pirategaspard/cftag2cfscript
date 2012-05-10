cftag2cfscript
==============

<h2>The cftag to cfscript converter for Coldfusion</h2>

With the arrival of Coldfusion 9 we can finally build our cfcs in cfscript. I've found that there is a significant speed increase when converting an existing tag based cfc to cfscript. 

Converting tag-based CF to script based CF is time consuming. This project aims to make it dead simple. Its not there yet, but maybe with your help we can reach that goal. 

<h3>The Process</h3>

Converting a cfc from tags to cfscript is as simple as:
<pre>
// create the cftag2cfscript object
cftag2cfscript = new cftag2cfscript();
// load the string to be converted
str = fileRead(expandPath('test.cfc'));
// convert!
newStr = cftag2cfscript.toCFscript(str);
// print it!
writeOutput(newStr);
</pre>

I am using XML to tokenize the existing tags so that the data is easier to work with. Internally the conversion from tags to script is a two step process:
Step 1: convert existing tag code into a valid XML document. 
Step 2: parse the XML into cfscript
Step 3: Profit. 

<h3>Problems when Converting existing code</h3>
<h4>Step 1: create XML</h4>
<ul>
<li>
Legacy CF can be difficult to massage into valid XML. There exists some syntax that CF will happily compile, but just shouldn't be. A great example I found was:
<pre>
 &lt;cfloop array=#myArray# index="i" &gt;
</pre>
Notice the missing quotes around #myArray#?  CF doesn't care, but the xmlParse function will. Some editing of existing code will be necessary to allow for valid XML. 
</li>
<li>
 The parse can become confused when single and double quotes are mixed within properties and values. It attempts to sort this out on its own, but if a chunk of your old code is missing or you are getting invalid XML errors this could be an issue. To check, uncomment the line:
 <pre>
 //writeOutput(xml);
 </pre>
 in the toCFscript function of cftag2cfscript. If this is a problem try re-organizing the quotes. Alternately you could remove the codee, converting the rest of the file with cftag2cfscript, then paste that offending part back in and rewrite it by hand. 
</li>
</ul>
<h4>Step 2: create cfscript</h4>
<ul>
<li>
cftag2cfscript aims to create valid cfscript that WORKS. Sometimes it does this gracefully. Sometimes it does this with ugly hacking. You will want to hand-optimize your converted code and of course regression test it. 
</li>
<li>
Make sure to search your converted code for "UNABLE TO PARSE" and "TODO". cftag2cfscript will insert these comments in problem areas. 
</li>
</ul>




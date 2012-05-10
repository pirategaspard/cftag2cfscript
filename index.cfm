<cfscript>
// create the cftag2cfscript object
cftag2cfscript = new cftag2cfscript();
// load the string to be converted
str = fileRead(expandPath('test.cfc'));
// convert!
newStr = cftag2cfscript.toCFscript(str);
// print it!
writeOutput(newStr);
</cfscript>
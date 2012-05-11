component displayname="cftag2cfscript" hint="I turn cftag cfcs into cfscipt cfcs" output="false"
{
	public function init()
	{
		variables.cftag2cfxml = new cftag2cfxml();
		variables.cfxml2cfscript = new cfxml2cfscript();
	}
	
	public function toCFscript(str)
	{		
		var xml = cftag2cfxml.toXML(str); // convert cftag into "cfxml"
		//writeOutput(xml); 
		var newStr = variables.cfxml2cfscript.toCFscript(xml); // convert "cfxml" into cfscript
		return newStr;
	}
}
<!--- cftag2cfscript - Daniel Gaspar dan@danielgaspar.com --->
<cfif structkeyexists(FORM,'submit') >	

	<cfif structkeyexists(FORM,'edit_xml') >
		<cfif FORM.edit_xml eq 0 >
			<cfset step = 0 />
		<cfelse>
			<cfset step = 1 />
		</cfif>
	<cfelse>
		<cfset step = 2 />	
	</cfif>


	<cfif structkeyexists(FORM,'file') >	
		<cfset str = fileRead(FORM.file) />
	<cfelse>
		<cfset str = form.XML />
	</cfif>

	<cfif step eq 0 >
		<cfset cftag2cfscript = new cftag2cfscript() />
		<cfset newStr = cftag2cfscript.toCFscript(str) />
		<cfset writeOutput(newStr) />
	<cfelseif step eq 2 >
		<cfset cfxml2cfscript = new cfxml2cfscript() />
		<cfset newStr = cfxml2cfscript.toCFscript(str) />
		<cfset writeOutput(newStr) />
	<cfelseif step eq 1 >
		<cfset cftag2cfxml = new cftag2cfxml() />
		<cfset newStr = cftag2cfxml.toXML(str) />
		<form action="" method="post" enctype="multipart/form-data">
			XML to convert <br />
			<textarea name="XML" cols="150" rows="50"><cfoutput>#newStr#</cfoutput></textarea><br />
			<input type="submit" name="submit" value="convert" />
		</form>
	</cfif>

<cfelse>
	<form action="" method="post" enctype="multipart/form-data">
		File to convert <input type="file" name="file" />
		Edit XML before converting? 
		N <input type="radio" name="edit_xml" checked="checked" value="0" />
		Y <input type="radio" name="edit_xml" value="1" />
		<input type="submit" name="submit" value="convert" />
	</form>	
</cfif>
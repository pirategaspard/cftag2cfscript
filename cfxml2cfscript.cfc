/* cftag2cfscript - Daniel Gaspar dan@danielgaspar.com */
component displayname="cftag2cfxml" hint="PART 2" output="false"
{

	variables.variableCount = 0; // keeps track of the new variable names we create so we can choose from a list of names
	
	/* PART 2: XML to cfscript Functions */
	function toCFscript(xml)
	{
		var i=0;
		var s = '';
		var aKeys = [] ;
		//writeOutput(xml);
		var document = xmlParse(xml);
		//writeDump(document);
		aKeys = structkeyArray(document);
		s &= parseKey(aKeys[1],document[aKeys[1]]);
		return s;
	}
	
	function parseChildren(doc)
	{
		var s ='';
		var i = 1;
		for(i=1;i<=arrayLen(doc.XmlChildren);i++)
		{
			s &= parseKey(doc.XmlChildren[i].XmlName,doc.XmlChildren[i]);
		}
		return s;
	}
	
	// here's the big list of cftags that need to be transformed from xml into cfscript
	function parseKey(key,doc)
	{
		var s = '';
		var args = [];
		var i = 1;
		
		switch(key)
		{        
			case "cfabort":
			{
				s &= parse_cfabort(doc);
				break;
			}			
			case "cfargument":
			{
				// ignore
				break;
			}
			case "cfbreak":
			{
				s &= parse_cfbreak(doc);
				break;
			}
			case "cfcase":
			{
				// ignore
				break;
			}
			case "cfcatch":
			{
				s &= parse_cfcatch(doc);
				break;
			}
			case "cfcomponent":
			{
				s &= parse_cfcomponent(doc);
				break;
			}
			case "cfdefaultcase":
			{
				// ignore
				break;
			}
			case "cfdirectory":
			{
				s &= parse_cfdirectory(doc);
				break;
			}
			case "cfelse":
			{
				s &= parse_cfelse(doc);
				break;
			}
			case "cfelseif":
			{
				s &= parse_cfelseif(doc);
				break;
			}
			case "cffile":
			{
				s &= parse_cffile(doc);
				break;
			}
			case "cfftp":
			{
				s &= parse_cfftp(doc);
				break;
			}
			case "cffunction":
			{
				s &= parse_cffunction(doc);
				break;
			}
			case "cfhttp":
			{
				s &= parse_cfhttp(doc);
				break;
			}
			case "cfif":
			{
				s &= parse_cfif(doc);
				break;
			}
			case "cfimage":
			{
				s &= parse_cfimage(doc);
				break;
			}
			case "cfinvoke":
			{
				s &= parse_cfinvoke(doc);        
				break;
			}
			case "cflock":
			{
				s &= parse_cflock(doc);        
				break;
			}
			case "cflog":
			{
				s &= parse_cflog(doc);        
				break;
			}
			case "cfloop":
			{
				s &= parse_cfloop(doc);        
				break;
			}
			case "cfmail":
			{
				s &= parse_cfmail(doc);        
				break;
			}
			case "cfquery":
			{
				s &= parse_cfquery(doc);        
				break;
			}
			case "cfreturn":
			{
				s &= parse_cfreturn(doc);
				break;
			}
			case "cfsavecontent":
			{
				s &= parse_cfsavecontent(doc);
				break;
			}
			case "cfscript":
			{
				s &= parse_cfscript(doc);
				break;
			}
			case "cfset":
			{
				s &= parse_cfset(doc);
				break;
			}
			case "cfsetting":
			{
				s &= parse_cfsetting(doc);
				break;
			}
			case "cfswitch":
			{
				s &= parse_cfswitch(doc);
				break;
			}
			case "cfthrow":
			{
				s &= parse_cfthrow(doc);
				break;
			}
			case "cfthread":
			{
				s &= parse_cfthread(doc);
				break;
			}
			case "cftry":
			{
				s &= parse_cftry(doc);
				break;
			}
			case "cfwddx":
			{
				s &= parse_cfwddx(doc);
				break;
			}
			case "cfzip":
			{
				s &= parse_cfzip(doc);
				break;
			}
			case "comment":
			{
				s &= parse_comment(doc);
				break;
			}
			case "condition":
			{
				// ignore
				break;
			}
			default:
			{
				s &= '/* UNABLE TO PARSE: '&key&' - cftag2cfscript */';	
				s &= parse_default(key,doc);			
			}
		}
		return s;
	}
	
	
	/* default functions */
	
	// attempt a best guess at how this cftag should be processed 
	function parse_default(key,doc)
	{
		var s =' ';
		var func_name = arguments.key;
		if (comparenocase(left(k,2),'cf')==0)
		{
			// remove 'cf' from tag name
			func_name = right(func_name,len(func_name)-2); 
		}
		// do we have a function or a service?
		if (structKeyexists(doc.XmlAttributes,'action')||structKeyexists(doc.XmlAttributes,'result'))
		{
			s &= parse_default_ServiceWithAttributes(func_name,doc);
		}
		else
		{
			s &= parse_default_FunctionWithArguments(func_name,doc);
		}
		// do we have children?
		if (arrayLen(doc.XmlChildren))
		{
			s &= '{';
			s &= parseChildren(doc);
			s &= '}';
		}
		return s;
	}
	
	function parse_default_FunctionWithArguments(name,doc)
	{
		var keys = structKeyArray(doc.xmlAttributes);
		var i = 1;
		var s = ' '&arguments.name;
		if (arraylen(keys))
		{
			s &='(';
			s &= buildAttributes(doc);
			s &= ')';
		}		
		return s;
	}
	
	function parse_default_ServiceWithAttributes(name,doc)
	{
		var ignoreKeyList = 'result,action';
		var f = getNewVariable();	
		var s = ' var '&f&' = new '&name&'();';	
		var i = 0;	
		var keys = structkeyarray(doc.XmlAttributes);	
		for(i=1;i <= arraylen(keys); i++)
		{
			if (!listFindNoCase(ignoreKeyList,keys[i]))
			{
				s &= ' '&f&'.set'&keys[i]&'("'&doc.XmlAttributes[keys[i]]&'"); ';
			}			
		}
		if (structKeyexists(doc.XmlAttributes,'result'))
		{
			s &= ' '&doc.XmlAttributes['result']&' = ';
		}
		if (structKeyexists(doc.XmlAttributes,'action'))
		{
			s &= ' '&f&'.'&doc.XmlAttributes['action']&'(); ';
		}
		return s;
	}
	
	function default_FunctionWithOutsideAttributes(name,doc)
	{
		var s ='';
		s &= ' '&name&' ';
		akeys = structkeyarray(doc.XmlAttributes);
		for(i=1;i<=arrayLen(akeys);i++)
		{
			s &= akeys[i]&'="'&doc.XmlAttributes[akeys[i]]&'" ';
		}
		s &= ' {';
		s &= parseChildren(doc);
		s &= '}';
		return s;
	}
	
	/*
	// stub function. Copy this to write a new tag parser 
	function parse_cftagname(doc)
	{
		var s ='';
		return s;
	}
	
	*/
	
	
	/* specific cftag transformation functions */
	function parse_cfabort(doc)
	{
		var s = ' abort;'; 
		return s;
	}
	
	function parse_cfbreak(doc)
	{
		var s = ' break;'; 
		return s;
	}
	
	function parse_cfcatch(doc)
	{
		var s = ' } catch (any cfcatch) '&'{'; 
		s &= parseChildren(doc);
		return s;
	}
	
	function parse_cfcomponent(doc)
	{
		return default_FunctionWithOutsideAttributes('component',doc);
	}
	
	function parse_cfdirectory(doc)
	{
		var s ='';
		switch(doc.XmlAttributes.action)
		{
			case 'create':
			{
				s &= ' directoryCreate("'&doc.XmlAttributes.directory&'");';
				break;
			}
			case 'delete':
			{
				s &= ' directoryDelete("'&doc.XmlAttributes.directory&'");';
				break;
			}
			case 'list':
			{
				s &= ' '&doc.XmlAttributes.name&' = directoryList("'&doc.XmlAttributes.directory&'","no","query");';
				break;
			}
			case 'rename':
			{
				s &= ' directoryRename("'&doc.XmlAttributes.directory&'");';
				break;
			}
		}
		return s;
	}
	
	function parse_cfelse(doc)
	{
		var s ='';
		s &= '}'&'else';
		s &= '{';
		s &= parseChildren(doc);
		return s;
	}
	
	function parse_cfelseif(doc)
	{
		var s ='';
		s &= ' } else if(';
		args =  structFind(doc,"condition");
		for(i=1;i<=arrayLen(args);i++)
		{
			s &= trim(args[i].xmltext);
		}
		s &= ')'&'{';
		s &= parseChildren(doc);
		return s;
	}
	
	function parse_cffile(doc)
	{
		var s ='';
		if (structkeyexists(doc.XmlAttributes,'action'))
		{
			// action
			if (doc.XmlAttributes.action == 'read')
			{
				s &=' '&doc.XmlAttributes.variable&' = fileRead(';
			}
			else if (doc.XmlAttributes.action == 'write')
			{
				s &=' fileWrite(';
			}
			else if (doc.XmlAttributes.action == 'append')
			{				
				s &=' fileAppend(';
			}
			else if (doc.XmlAttributes.action == 'copy')
			{				
				s &=' fileCopy(';
			}
			/* TODO: file functions don't take named attributes. Thanks Adobe! */
			s &= buildAttributes(doc,'action');
			s &= ');';
		}    
		return s;
	}
	
	function parse_cfftp(doc)
	{
		return parse_default_ServiceWithAttributes('ftp',doc);
	}
	
	function parse_cffunction(doc)
	{
		var s =' ';
		var argCount = 0; // keeps track of how many arguments we have so we can decide to add a comma or not 
		if (structkeyexists(doc.XmlAttributes,'access'))
		{
			s &= doc.XmlAttributes.access;
		}
		if (structkeyexists(doc.XmlAttributes,'returntype'))
		{
			s &= ' '&doc.XmlAttributes.returntype;
		}
		s &= ' function '&doc.XmlAttributes.name&'(';
		try
		{
			args =  structFind(doc,"cfargument");                
		}
		catch (any e)
		{
			args = [];
		}
		for(i=1;i<=arrayLen(args);i++)
		{
			if ((structkeyexists(args[i].XmlAttributes,'required') && args[i].XmlAttributes.required)||structkeyexists(args[i].XmlAttributes,'default'))
			{				
				if (argCount > 0)
				{
					s &=',';
				}
				if (structkeyexists(args[i].XmlAttributes,'type'))
				{
					 s &= args[i].XmlAttributes.type&' ';
				}
				s &= args[i].XmlAttributes.name;
				if (structkeyexists(args[i].XmlAttributes,'default'))
				{
					 s &= '="'&args[i].XmlAttributes.default&'"';
				}
				argCount++;
			}						
		}
		s &= ')'&'{';
		s &= parseChildren(doc);
		s &= '}';
		return s;
	} 
	
	function parse_cfhttp(doc)
	{
		return parse_default_ServiceWithAttributes('http',doc);
	}   
	
	function parse_cfif(doc)
	{
		var s ='';
		s &= ' if(';
		args =  structFind(doc,"condition");
		for(i=1;i<=arrayLen(args);i++)
		{
			s &= args[i].xmltext;
		}
		s &= ')'&'{';
		s &= parseChildren(doc);
		s &= '}';
		return s;
	}
	
	function parse_cfimage(doc)
	{
		var s ='';	
		if (structkeyexists(doc.XmlAttributes,'action'))
		{
			// action
			if (doc.XmlAttributes.action == 'border')
			{
				s &=' '&doc.XmlAttributes.variable&' = imageAddBorder(';
			}
			else if (doc.XmlAttributes.action == 'captcha')
			{
				s &=' imageCaptcha(';
			}
			else if (doc.XmlAttributes.action == 'convert')
			{				
				s &=' imageConvert(';
			}
			else if (doc.XmlAttributes.action == 'info')
			{				
				s &=' '&doc.XmlAttributes.structName&' = imageInfo(';
			}
			else if (doc.XmlAttributes.action == 'read')
			{				
				s &=' '&doc.XmlAttributes.name&' = imageRead(';
			}
			else if (doc.XmlAttributes.action == 'resize')
			{				
				s &=' imageResize(';
			}
			else if (doc.XmlAttributes.action == 'rotate')
			{				
				s &=' imageRotate(';
			}
			else if (doc.XmlAttributes.action == 'write')
			{				
				s &=' imageWrite(';
			}
			else if (doc.XmlAttributes.action == 'writeToBrowser')
			{				
				s &=' fileCopy(';
			}
			/* TODO: image functions don't take named attributes. Thanks Adobe! */
			s &= buildAttributes(doc,'action');
			s &= ');';
		}    	
		return s;
	}
	
	function parse_cfinvoke(doc)
	{
		var s ='';
		var i = 0;
		var args = {};
		var keys = [];
		// currently only works with component method calls.
		if (structkeyexists(doc.xmlAttributes,'component'))
		{
			if (structkeyexists(doc.xmlAttributes,'returnvariable'))
			{
				s &= doc.xmlAttributes.returnvariable&'=';
			}
			s &= ' createObject("component","'&doc.xmlAttributes.component&'")';
			s &= '.'&doc.xmlAttributes.method&'(';
			if (structkeyexists(doc.xmlAttributes,'cfinvokeargument'))		
			{
				args = structfind(doc.xmlAttributes,cfinvokeargument);	
				for(i=1;i<=arraylen(args);i++)
				{
					s &= args[i].name&'="'&args[i].value&'"';
					if (i < arrayLen(args))
					{
						s &= ','; 
					}
				}
			}
			else if (structkeyexists(doc.xmlAttributes,'argumentCollection'))
			{
				args = doc.xmlAttributes.argumentCollection;
				keys = structkeyarray(args);
				for(i=1;i<=arraylen(keys);i++)
				{
					s &= keys[i]&'="'&args[keys[i]]&'"';
					if (i < arrayLen(keys))
					{
						s &= ','; 
					}
				}
			}				
			s &= ');'; 		
		}	
		return s;
	}
	
	function parse_cflock(doc)
	{
		var s ='';
		var i=0;
		var keys = structkeyarray(doc.XmlAttributes);
		s &= ' lock ';
		//s &= '(';
		for(i=1;i<=arrayLen(keys);i++)
		{
			s &= keys[i]&'="'&doc.XmlAttributes[keys[i]]&'" '; 
			if (i < arrayLen(keys))
			{
				//s &= ','; 
			}
		}
		//s &= ')'; 
		s &= '{';
		s &= parseChildren(doc);
		s &= '}';
		return s;
	}
	
	function parse_cflog(doc)
	{
		var s =' writeLog(';
		s &= buildAttributes(doc);
		s &=');';
		return s;
	}
	
	function parse_cfloop(doc)
	{
		var s ='';
		var i = '';
		var j = '';
		var k = '';
		var l = '';
		var m = '';
		var q = '';
		if (structkeyexists(doc.XmlAttributes,'list'))
		{
			i = getNewVariable();
			j = getNewVariable();
			s &= ' var '&i&' = 0;';
			s &= ' var '&j&' = listLen('&clean(doc.XmlAttributes.list)&');';
			s &= ' for('&i&'=1;'&i&'<='&j&';'&i&'++) { ';
			S &= doc.XmlAttributes.index&'=listGetAt('&clean(doc.XmlAttributes.list)&','&i&');';
			s &= parseChildren(doc);
			s &= '}';
		}
		else if (structkeyexists(doc.XmlAttributes,'array'))
		{
			i = getNewVariable();
			j = getNewVariable();
			s &= ' var '&i&' = 0;';
			s &= ' var '&j&' = arrayLen('&clean(doc.XmlAttributes.array)&');';
			s &= ' for('&i&'=1;'&i&'<='&j&';'&i&'++) { ';
			S &= doc.XmlAttributes.index&'='&clean(doc.XmlAttributes.array)&'['&i&'];';
			s &= parseChildren(doc);
			s &= '}';
		}
		else if (structkeyexists(doc.XmlAttributes,'collection'))
		{
			i = getNewVariable();
			j = getNewVariable();
			k = getNewVariable();
			s &= ' var '&i&' = 0;';
			s &= ' var '&j&' = structKeyArray('&clean(doc.XmlAttributes.collection)&');';
			s &= ' var '&k&' = arrayLen('&j&');';
			s &= ' for('&i&'=1;'&i&'<='&k&';'&i&'++) { ';
			S &= doc.XmlAttributes.item&'='&j&'['&i&'];';
			s &= parseChildren(doc);
			s &= '}';
		}
		else if (structkeyexists(doc.XmlAttributes,'query'))
		{
			// to make this compatible with the original cftag code is very very ugly
			q = getNewVariable(); // orig query
			i = getNewVariable(); // index for query
			k = getNewVariable(); // array of query keys
			l = getNewVariable(); // length of keys
			j = getNewVariable(); // index for keys
			s &= '/* TODO: PLEASE OPTIMIZE ME - cftag2cfscript */';
			s &= ' var '&q&'='&clean(doc.XmlAttributes.query)&'; /* put Q into temp variable */';
			s &= ' var '&i&'=0;';
			s &= ' var '&k&'= listToArray('&q&').columnlist);';
			s &= ' var '&l&'= arrayLen('&k&');';
			s &= ' for('&i&'=1;'&i&'<='&q&'.recordcount;'&i&'++) { '; // loop over query records			
			s &= ' /* build struct that will work like a Q in a loop */';
			s &= ' '&clean(doc.XmlAttributes.query)&'= {}';  // turn the original query name into a structure
			s &= ' '&clean(doc.XmlAttributes.query)&'.recordcount = '&q&'.recordcount;'; // put the record count in there just in case the code inside the loop asks for it
			s &= ' '&clean(doc.XmlAttributes.query)&'.currentrow = '&i&';'; // put the currentrow in there just in case the code inside the loop asks for it
			s &= ' for('&j&'=1;'&j&'<='&l&';'&j&'++) { '; // loop over query columns
			s &= ' '&clean(doc.XmlAttributes.query)&'['&k&'['&j&']] ='&q&'['&k&'['&j&']]['&i&'];'; // add the current key and value
			s &= '}';
			s &= parseChildren(doc);			
			s &= '}';
			s &= ' '&clean(doc.XmlAttributes.query)&'='&q&'; /* put Q back into original variable */'; // set query back to original variable name 
			//s &= '/* UNABLE TO PARSE: CFLOOP QUERY - cftag2cfscript */';
		}
		else if (structkeyexists(doc.XmlAttributes,'condition'))
		{
			s &= ' while('&doc.XmlAttributes.condition&'){ ';
			s &= parseChildren(doc);
			s &= '}';
		}
		else if (structkeyexists(doc.XmlAttributes,'from'))
		{
			i = getNewVariable();
			s &= ' var '&i&' = '&clean(doc.XmlAttributes.to)&';';
			s &= ' for('&doc.XmlAttributes.index&'='&clean(doc.XmlAttributes.from)&';'&doc.XmlAttributes.index&'<='&i&';'&doc.XmlAttributes.index&'++) { ';
			s &= parseChildren(doc);
			s &= '}';
		}
		return s;
	}
	
	function parse_cfmail(doc)
	{
		var m = getNewVariable(); // mail service
		var s =' /* TODO: CFMAIL - cftag2cfscript */';
		s =' var '&m&' = new mail();';
		if (structkeyExists(doc.XmlAttributes,'subject'))
		{
			s &= ' '&m&'.setSubject("'&doc.XmlAttributes.subject&'");';
		}
		if (structkeyExists(doc.XmlAttributes,'from'))
		{
			s &= ' '&m&'.setFrom("'&doc.XmlAttributes.from&'");';
		}
		if (structkeyExists(doc.XmlAttributes,'to'))
		{
			s &= ' '&m&'.setTo("'&doc.XmlAttributes.to&'");';
		}
		s &= ' '&m&'.addPart( type="html", charset="utf-8", body="'&doc.XmlText&'" ); /* The body content is probably incorrect - cftag2cfscript */';
		s &= ' '&m&'.send();';
		return s;
	}
	
	// TODO: make this more betterer
	function parse_cfquery(doc)
	{
		var s = '';
		var i = '';
		var sql = '';
		var attr = '';
		var q = getNewVariable();
		var result = getNewVariable();
		var sql = getNewVariable();
		s &= 'var '&q&' = new Query();'; 
		s &= 'var '&sql&' = "";';
		s &= 'var '&result&' = {};';
		if (structkeyExists(doc.XmlAttributes,'datasource'))
		{
			s &= q&'.setDataSource("'&doc.XmlAttributes.datasource&'");'; 
		}
		if (structkeyExists(doc.XmlAttributes,'dbtype'))
		{
			s &= q&'.setDBtype("'&doc.XmlAttributes.dbtype&'");'; 
			if (doc.XmlAttributes.dbtype == 'query')
			{
				/* TODO: this is not correct. we should instead grab the table name after "FROM" inside the SQL string instead. */
				s &= q&'.setAttributes('&doc.XmlAttributes.name&'='&doc.XmlAttributes.name&');'; 
			}
		}
		//set SQL	
		s &= sql&' = "'&doc.xmlText&'";';
		s &= q&'.setSQL('&sql&');'; 					
		// loop here to build cfqueryparam data
		if (arrayLen(doc.XmlChildren))
		{
			/* loop over children and find cfqueryparams (all children should be cfqueryparams, but just in case lets check) */
			for(i=1;i<=arrayLen(doc.XmlChildren);i++)
			{
				if (comparenocase(doc.XmlChildren[i].XmlName,'cfqueryparam') == 0)
				{
					/* remember that number we added to the cfqueryparam attributes in cftag2cfxml? we use it here to match up the params! */ 
					s &= q&'.addParam(name="CFPARAM'&doc.XmlChildren[i].XmlAttributes.num&'", value="'&doc.XmlChildren[i].XmlAttributes.value&'", cfsqltype="'&doc.XmlChildren[i].XmlAttributes.cfsqltype&'");';
				}
			}		
		}
		// do we need to get a results struct?	
		if (structkeyExists(doc.XmlAttributes,'result'))
		{
			s &= result&'='&q&'.Execute();'; 
			s &= doc.XmlAttributes.result&'='&result&'.getPrefix();'; 
			s &= doc.XmlAttributes.name&'='&result&'.getResult();'; 
		}
		else
		{	
			s &= doc.XmlAttributes.name&'='&q&'.Execute().getResult();'; 
		}
		return s;
	}
	
	function parse_cfreturn(doc)
	{
		var s = ' return ' & trim(doc.XmlText)&';';
		return s;
	}
	
	function parse_cfsavecontent(doc)
	{
		var s= ' /* TODO: CFSAVECONTENT - cftag2cfscript */ ';
		s &=' savecontent variable="'&doc.XmlAttributes.variable&'" {'&doc.XmlText&'}';
		return s;
	}
	
	function parse_cfscript(doc)
	{
		var s = ' '&doc.XmlText;
		return s;
	}
	
	function parse_cfset(doc)
	{
		var s = rtrim(doc.XmlText)&';'; 
		return s;
	}
	
	function parse_cfsetting(doc)
	{
		var s = '';
		if (structkeyExists(doc.XmlAttributes,'requesttimeout'))
		{
			s &= 'createObject( "java", "coldfusion.runtime.RequestMonitor" ).overrideRequestTimeout( javaCast( "long", '&doc.XmlAttributes.requesttimeout&' ) );';
		}
		return s;
	}
	
	function parse_cfswitch(doc)
	{
		var s = '';
		var cases = [];
		if (structkeyexists(doc.XmlAttributes,'expression'))
		{
			s &= ' switch ('&clean(doc.XmlAttributes.expression)&')';
			s &= '{';
			try
			{
				cases =  structFind(doc,"cfcase");                
			}
			catch (any e)
			{
				cases = [];
			}
			for(i=1;i<=arrayLen(cases);i++)
			{
				s &= ' case "'&clean(cases[i].XmlAttributes.value)&'":';
				s &= '{';
				s &= parseChildren(cases[i]);
				s &= 'break;';
				s &= '}';
			}
			try
			{
				cases =  structFind(doc,"cfdefaultcase");                
			}
			catch (any e)
			{
				cases = [];
			}
			for(i=1;i<=arrayLen(cases);i++)
			{
				s &= ' default:';
				s &= '{';
				s &= parseChildren(cases[i]);
				s &= 'break;';
				s &= '}';
			}
			s &= '}';
		}
		return s;
	}
	
	function parse_cfthread(doc)
	{
		return default_FunctionWithOutsideAttributes('thread',doc);
	}
	
	function parse_cfthrow(doc)
	{
		var s ='';
		var i=0;
		var keys = structkeyarray(doc.XmlAttributes);
		s &= 'throw(';
		for(i=1;i<=arrayLen(keys);i++)
		{
			s &= keys[i]&'="'&doc.XmlAttributes[keys[i]]&'" '; 
			if (i <= arrayLen(keys))
			{
				s &= ','; 
			}
		}
		s &= ')'; 
		return s;
	}
	
	function parse_cftry(doc)
	{
		var s = ' try '&'{'; 
		s &= parseChildren(doc);
		s &= '}';
		return s;
	}
	
	function parse_cfwddx(doc)
	{
		var s = ' wddx(';
		s &= buildAttributes(doc);
		s &= ');';	 
		return s;
	}
	
	function parse_cfzip(doc)
	{
		var i = 1;
		var s =' zip(';		
		s &= buildAttributes(doc);
		s &= ');';
		return s;
	}
	
	function parse_comment(doc)
	{
		var s ='';
		var comment = doc.xmlText;	
		if (len(comment)>0)
		{
			// chop off the third '-' from the CF comment at the begining
			if (mid(comment,1,1)=='-')
			{
				comment = mid(comment,2,(len(comment)-1));
			}
			// chop off the third '-' from the CF comment at the end
			if (mid(comment,(len(comment)),1)=='-')
			{
				comment = mid(comment,1,(len(comment)-1));
			}
		}
		s &= '/*'&comment&'*/'&chr(13);
		return s;
	}
	
	// removes num-sign from begining and end of CF variables.
	function clean(v)
	{
		return rereplace(v,'^##|##$','','all');
	}
	
	// returns a new name so we can create variables in the code 
	function getNewVariable()
	{
		var varNameList = 'aaa,bbb,ccc,ddd,eee,fff,ggg,hhh,iii,jjj,kkk,lll,mmm,nnn,ooo,ppp,qqq,rrr,sss,ttt,uuu,vvv,www,xxx,yyy,zzz,aaaa,bbbb,cccc,dddd,eeee,ffff,gggg,hhhh,iiii,jjjj,kkkk,llll,mmmm,nnnn,oooo,pppp,qqqq,rrrr,ssss,tttt,uuuu,vvvv,wwww,xxxx,yyyy,zzzz';	
		variables.variableCount++;
		if (variables.variableCount > listlen(varNameList))
		{
			variables.variableCount = 1;
		}	
		return listGetAt(varNameList,variables.variableCount);
	}
	
	// builds a comma seperated string from xmlattributes
	function buildAttributes(doc,ignoreList='')
	{
		var keys = structKeyArray(doc.xmlAttributes);
		var i = 1;
		var s ='';
		for(i=1;i<=arraylen(keys);i++)
		{
			if (!listFindNoCase(ignoreList,keys[i]))
			{
				if ((i > 1) && len(s) > 0)
				{
					s &= ',';
				}
				s &= keys[i]&'="'&doc.xmlAttributes[keys[i]]&'"';
			}
		}
		return s;
	}
}
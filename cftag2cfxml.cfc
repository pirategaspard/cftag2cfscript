/* cftag2cfscript - Daniel Gaspar dan@danielgaspar.com */
component displayname="cftag2cfxml" hint="PART I" output="false"
{

	// regEx helpers for creating valid XML during pre-parsing
	variables.regexVar1 = '[\w\d._[\]{}\(\)\*\##"'',&]+'; //for cf variables/cfexpressions inside double quotes
	variables.regexVar2 = '[\w\d\._\[\]{}\(\)\"\*\##'',&]+'; // a more permissive regex for cf variables/cfexpressions
	variables.regexVar3 = '[\w\d\._\[\]{}=\s\(\)\*\##'',&]+'; //an even more permissive regex for cf variables/cfexpressions
	variables.regexVar4 = '[\w\d\._\[\]{}=\s\(\)\*\##\":'',\-&]+'; //an much permissive regex for cf variables/cfexpressions
	//variables.regexVar5 = '[\w\d\._\[\]{}=\s\(\)\*\##\"'',\<\>\-/&]+'; //an even much more permissive regex for cf variables/cfexpressions

	
	/* PART I: cftag to XML function */
	public function toXML(str)
	{
		var xml = pre_parse_comments(str);
		xml = pre_parse_fixQuotes(xml);
		xml = pre_parse_cfif(xml);
		xml = pre_parse_cfreturn(xml);
		xml = pre_parse_cfbreak(xml);
		xml = pre_parse_cfset(xml);
		xml = pre_parse_cflog(xml);
		xml = pre_parse_cffile(xml);
		xml = pre_parse_cfdirectory(xml);
		xml = pre_parse_cfsavecontents(xml);
		xml = pre_parse_cfsetting(xml);
		xml = pre_parse_cfargument(xml);
		xml = pre_parse_cfwddx(xml);	
		xml = pre_parse_cfscript(xml);	
		xml = pre_parse_HTMLentities(xml); 
		//writeOutput(xml);
		return xml;	
	}
		
	
	/* PART I: Pre-Parseing Functions for turning cftags into properly formed XML */ 
	private function pre_parse_cfargument(str)
	{
		return pre_parse_CloseTagShort(str,'cfargument');
	}
	
	private function pre_parse_cflog(str)
	{
		return pre_parse_CloseTagShort(str,'cflog');
	}
	
	private function pre_parse_cffile(str)
	{
		return pre_parse_CloseTagShort(str,'cffile');
	}
	
	private function pre_parse_cfdirectory(str)
	{
		//str = rereplace(str,'<cfdirectory(.*?)>','<cfdirectory \1 />','all');
		return pre_parse_CloseTagShort(str,'cfdirectory');
	}	
	
	private function pre_parse_cfbreak(str)
	{
		//str = rereplace(str,'<cfbreak /*?>','<cfbreak />','all');
		return pre_parse_CloseTagShort(str,'cfbreak');
	}	
	
	private function pre_parse_HTMLentities(str)
	{
		// replaces any HTML entities that cause trouble in XML 
		str = rereplace(str,'&','&amp;','all'); // fix ampersand
		// probably should be more here. 
		return str;
	}
	
	private function pre_parse_comments(str)
	{
		//str = rereplace(str,'<!--.*?-->','','all'); // remove all comments
		str = rereplace(str,'<!--(.*?)-->','<comment><![CDATA[\1]]></comment>','all'); // put all comments into a commment tag
		return str;
	}
	
	private function pre_parse_cfsavecontents(str)
	{
		str = rereplace(str,'<cfsavecontent(.*?)>(.*?)</cfsavecontent>','<cfsavecontent \1 ><![CDATA[\2]]></cfsavecontent>','all'); // put all comments into a commment tag
		return str;
	}
	
	private function pre_parse_cfelse(str)
	{
		var i = 0;
		var name = 'cfelse';
		var posinfo = REFindAllNoCase('<'&name&'>',str,0);
		for (i=arrayLen(posinfo.pos);i>0;i--)
		{
			str = createEndTag(str,name,findMatchingTag(str,'cfif',posinfo.pos[i]));
		}
		return str;
	}
	
	private function pre_parse_cfelseif(str)
	{
		var i = 0;
		var name = 'cfelseif';
		var posinfo = REFindAllNoCase('<'&name,str,0);
		for (i=arrayLen(posinfo.pos);i>0;i--)
		{        
			str = createEndTag(str,name,findMatchingTag(str,'cfif',posinfo.pos[i]));
		}
		return str;
	}
	
	private function pre_parse_cfif(str)
	{
		str = rereplace(str,'<cfif\s*?('&variables.regexVar4&')\s*?>','<cfif><condition>\1</condition>','all');
		str = rereplace(str,'<cfelseif\s*?('&variables.regexVar4&')\s*?>','<cfelseif><condition>\1</condition>','all');
		str = pre_parse_cfelse(str);
		str = pre_parse_cfelseif(str);
		return str;
	}
	
	private function pre_parse_cfreturn(str)
	{
		//return rereplace(str,'<cfreturn\s*?('&variables.regexVar4&')?\s*?/*?>','<cfreturn>\1</cfreturn>','all');
		return pre_parse_CloseTagFull(str,'cfreturn');
	}
	
	private function pre_parse_cfscript(str)
	{
		str = rereplace(str,'<cfscript>(.*?)</cfscript>','<cfscript><![CDATA[\1]]></cfscript>','all');
		return str;
	}
	
	private function pre_parse_cfset(str)
	{
		//var name = 'cfset '; // leave space in the string: it keeps it from picking up "cfsetting"
		//return pre_parse_singlelineexpression(str,name);
		return pre_parse_CloseTagFull(str,'cfset');
	}
	
	private function pre_parse_cfsetting(str)
	{
		//str = rereplace(str,'<cfsetting\s*?('&variables.regexVar4&')?\s*?/*?>','<cfsetting \1 />','all');
		return pre_parse_CloseTagShort(str,'cfsetting');		
	}
	
	private function pre_parse_cfwddx(str)
	{
		//str = rereplace(str,'<cfwddx\s*?('&variables.regexVar4&')?\s*?/*?>','<cfwddx \1 />','all');
		return pre_parse_CloseTagShort(str,'cfwddx');
	}
	
	private function pre_parse_CloseTagShort(str,name)
	{
		str = rereplace(str,'<'&name&'(.*?)/*?>','<'&name&'\1 />','all');
		return str;
	}
	
	private function pre_parse_CloseTagFull(str,name)
	{
		str = rereplace(str,'<'&name&'(.*?)/*?>','<'&name&'> \1 </'&name&'>','all');
		return str;
	}
	
	private function pre_parse_singlelineexpression(str,name)
	{
		var i = 0;
		var pos = '';
		var posinfo = REFindAllNoCase('<'&name,str,0);
		var tname = trim(lcase(name));
		for (i=arrayLen(posinfo.pos);i>0;i--)
		{
			pos = findEndOfTag(str,posinfo.pos[i]);
			str = createEndTag(str,tname,findEndOfTag(str,posinfo.pos[i]));
			// remove preexisting '>'
			str = RemoveChars(str,pos,1);
			// remove the '/' from the pre-existing '/>'
			if (mid(str,pos-1,1) == '/')
			{
				str = RemoveChars(str,pos-1,1);
			}			
			// close start tag
			//str = insert('> ',str,posinfo.pos[i]+len('<'&tname)-1);
			str = RemoveChars(str,posinfo.pos[i]+1,len(tname));
			str = insert(tname&'> ',str,posinfo.pos[i]);
		}
		return str;
	}
	
	private function pre_parse_fixQuotes(str)
	{
		var i = '';
		var posinfo = '';
		var substr = '';
		str = rereplace(str,'('&variables.regexVar2&')\s*?=\s*?''('&variables.regexVar1&')''','\1="\2"','all');
		//writeOutput(str&'<br />');
		posinfo = REFindAllNoCase('=\s*?"'&variables.regexVar1&'"(\s|/|>)',str,0);
		//writeDump(posinfo);
		for (i=arrayLen(posinfo.pos);i>0;i--)
		{
			substr = mid(str,posinfo.pos[i],posinfo.len[i]);
			// pull the expression out of the str
			//writeOutput(HTMLCodeFormat(substr)&'<br />');
			pre = reFind('=\s*"',substr,0,1);
			//writeDump(pre);
			substr = mid(str,posinfo.pos[i]+pre.len[1],posinfo.len[i]-pre.len[1]-2);
			if (len(substr) > 0)
			{
				//writeOutput(HTMLCodeFormat(substr)&'<br />');
				substr = rereplace(substr,'"',"'",'all');
				//writeOutput(HTMLCodeFormat(substr)&'<br />');
				str = RemoveChars(str,posinfo.pos[i]+pre.len[1],posinfo.len[i]-pre.len[1]-2);
				//writeOutput(HTMLCodeFormat(str)&'<br />');
				str = insert(substr,str,posinfo.pos[i]+pre.len[1]-1);
				//writeOutput(HTMLCodeFormat(str)&'<br />');
			}
		}
		return str;
	}
	
	// from startPos to endPos replace any strOrig with startPos 
	private function replaceStrFromTo(str,strOrig,strRep,startPos,endPos)
	{
		var l = '';
		var r = '';
		var i = startPos;
		var found = 0;
		while(i<endPos)
		{
			found = findNoCase(strOrig,str,i); 
			if (found && found<endPos)
			{
				l = left(str,found-1);
				r = right(str,len(str)-len(l)-1);
				str = l & strRep & r;
				i = found++;
			}
			else
			{
				i = endPos;
			}
		}
		return str;
	}
	
	private function createEndTag(str,name,i)
	{
		// insert closing tag
		str = insert('</'&trim(lcase(name))&'>',str,i);
		return str;
	}
	
	private function findMatchingTag(str,starttag,start,endtag='')
	{    
		var tag = {};
		tag.start = '<'&starttag;    
		if (len(endtag) == 0)
		{
			tag.end = '</'&starttag;
		} 
		else
		{
			tag.end = '</'&endtag;
		}
		return findMatchingString(str,tag.start,start,tag.end);
	}
	
	private function findMatchingString(str,strStart='',start,strEnd='')
	{
		var i = start;    
		var found = 0;
		var char = '';
		var count = {};
		var buffer = {};
		count.strStart = 1;
		count.strEnd = 0;
		buffer.strStart = '';
		buffer.strEnd = '';
		if ((len(strStart)>0)&&(len(strEnd)>0))
		{
			while(i<len(str)&&!found)
			{
				char = mid(str,i,1);
				// update buffers
				buffer.strStart &= char;
				buffer.strEnd &= char;        
				// resize buffers
				if(len(buffer.strStart)>len(strStart))
				{            
					buffer.strStart = RemoveChars(buffer.strStart,1,len(buffer.strStart)-len(strStart));            
				}
				if(len(buffer.strEnd)>len(strEnd))
				{
					buffer.strEnd = RemoveChars(buffer.strEnd,1,len(buffer.strEnd)-len(strEnd));
				}
				// compare buffers to tags
				if(arrayLen(reMatchNoCase(strStart,buffer.strStart))>0)
				{
					count.strStart++;
				}
				if(arrayLen(reMatchNoCase(strEnd,buffer.strEnd))>0)
				{
					count.strEnd++;
				}        
				// have we found the correct endtag yet?
				if (count.strStart == count.strEnd)
				{
					found = 1; // we found it!
					i = i-len(strEnd); // start of end tag is back a few characters 
				}
				else
				{            
					i++;
				}
			}
		}
		if (!found)
		{
			i = 0;
		}
		return i;
	}
	
	private function findEndOfTag(str,start)
	{
		return FindOuterChar(str,'<','>',start);
	}
	
	private function FindOuterChar(str,startchar='',endchar='>',start)
	{
		var i = start; 
		var count = 0;
		var found = 0;
		var char = '';
		if ((len(startchar) > 0)&&(len(endchar) > 0))
		{
			while(i<len(str)&&!found)
			{
				char = mid(str,i,1);
				if (char == startchar)
				{
					count++;
				}
				else if (char == endchar)
				{
					count--;
				}
				if (count == 0)
				{
					found = 1;
				}
				else
				{
					i++;
				}
			}
		}
		if (!found)
		{
			i = 0;
		}
		return i;
	}

	private function REFindAllNoCase(regex,str='',start=0)
	{
		var i = start;
		var t = '';
		var r = {};
		var strlen = len(str);
		r.len = [];
		r.pos = [];
		while (i<strlen)
		{
			t = refindnocase(regex,str,i,1);
			if (t.pos[1] > 0)
			{
				arrayAppend(r.len,t.len[1]);
				arrayAppend(r.pos,t.pos[1]);
				i=t.pos[1]+1;
			}
			else
			{
				i=strlen;
			}
		}
		return r;
	}
}
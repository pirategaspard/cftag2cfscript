<cfcomponent displayname="testcfc" output="false" extends="some.other.cfc" hint="I am the test cfc for cftag2cfscript" >

	<!--- Here is a comment  --->

	<cfset variables.data = "" /> <!--- this is my data --->
	<cfset variables.otherdata = structNew() /> <!--- this is my other data --->
	
	<!--- public function with argument --->
	<cffunction name="init" access="public" output="false" returntype="any" hint="I init the obj" >
		<cfargument name="arg1" type="any" required="true" hint="I am argument 1. I am required." />	
		<cfset var str = '' />
		<cfset var variables.data = arg1 />
		<cfreturn this >
	</cffunction>
	
	<!--- public function with arguments --->
	<cffunction name="func1" access="public" output="false" returntype="any" >
		<cfargument name="arg1" type="numeric" required="true" hint="I am argument 1. I am required." />
		<cfargument name="arg2" type="string" required="true" default="FOO" hint="I am argument 2. I am required. My default is FOO" />
		<cfargument name="arg3" type="any" required="false" hint="I am argument 3. I am optional" />
		<cfsetting requesttimeout="10" >
		<cfreturn func2(argumentCollection=arguments) >
	</cffunction>
	
	<!--- private function with arguments --->
	<cffunction name="func2" access="private" output="false" returntype="any" hint="I init the obj" >
		<cfargument name="arg1" type="numeric" required="true" hint="I am argument 1. I am required." />
		<cfargument name="arg2" type="string" required="true" default="FOO" hint="I am argument 2. I am required. My default is FOO" />
		<cfargument name="arg3" type="any" required="false" hint="I am argument 3. I am optional" />		
		<cfset var str = '' />
		<cfset var i = '' />
		<cfset var MyArray = [1,2,3,4,5,6,7,8,9,0] >
		<cfset var MyStruct = {a=2,b=3,c=4,d=5,e=6,f=7,g=8,h=9,i=0} >
		<cfset var MyQuery = MyService().getQuery() />
		<!--- if --->
		<cfif arguments.arg2 NEQ "FOO">
			<cfset arg3 = 1 />
		</cfif>
		<!--- if else --->
		<cfif arguments.arg3 EQ 1 >
			<cfset arg1 = 1 />
		<cfelse>
			<cfset arg1 = 2 />
		</cfif>
		<!--- if elseif else --->
		<cfif arguments.arg3 EQ 1 >
			<cfset arg1 = 1 />
		<cfelseif arguments.arg3 LT 1 >
			<cfset arg1 = 2 />
		<cfelse>
			<cfset arg1 = 3 />
		</cfif>
		<!--- cfloop from to index --->
		<cfloop from="1" to="#listlen(arguments.arg1)#" index="i">
			<cfset str &= i />
		</cfloop>
		<!--- cfloop array index --->
		<cfloop array="#MyArray#" index="i">
			<cfset str &= i />
		</cfloop>
		<!--- cfloop collection index --->
		<cfloop collection="#MyStruct#" item="i">
			<cfset str &= i />
		</cfloop>
		<!--- cfloop list index --->
		<cfloop list="#MyStruct#" index="i">
			<cfset str &= i />
		</cfloop>
		<!--- cfloop query index --->
		<cfloop query="#MyQuery#">
			<cfset str &= MyQuery.i />
		</cfloop>
		<!--- cfloop condition cfbreak --->
		<cfloop condition="#len(arguments.arg1)# LT 10" >
			<cfset str &= 'ABCDEFG' />
			<cfbreak >
		</cfloop>
		<!--- cftry cfcatch cflog cfthrow --->
		<cftry>
			<cfset str = 1 />
			<cfcatch>
				<cflog text="#cfcatch.message#" />
				<cfthrow type="FOOBAR" message="FOOBAR!" />				
			</cfcatch>
		</cftry>
		<!--- cfabort --->
		<cfabort />
		<!--- cfwddx --->
		<cfwddx action="cfml2wddx" input="#arguments.arg2#" output="str">
		<cfreturn str >
	</cffunction>
	
	
	<!---need more tests -dg--->
	
	
</cfcomponent>
<cfcomponent displayname="cfcFlexplorerProxy">
	
	<cffunction name="getFlexplorer" output="false" access="remote" returntype="any" hint="gets the flexplorer from the application scope">
		<cfreturn application.cfcFlexplorer />
	</cffunction>
	
	<cffunction name="dump" output="false" access="remote" returntype="void" hint="i dump">
		<cfargument name="content" type="any">
		<cfset var theDir = getDirectoryFromPath(getBaseTemplatePath())>
		<cfset var theFile = theDir & createUUID() & ".xls">
		<cfset var theOutput = "">
		<cfsavecontent variable="theOutput"><cfdump var="#arguments#"></cfsavecontent>
		<cffile action="write" file="#theFile#" output="#theOutput#"/>
	</cffunction>
	
	<cffunction name="getMeta" output="false" access="remote" returntype="struct" hint="i call the getCfcMetaData function in cfcFlexplorer">
		<cfargument name="pathToCfc" required="true" type="string">
		<cfset var meta = getFlexplorer().getCfcMetaData(arguments.pathToCfc)>
		<cfreturn meta />
	</cffunction>
	
	<cffunction name="getTree" output="false" access="remote" returntype="xml" hint="i call the makeCfcTree function in cfcFlexplorer">
		<cfargument name="rootDir" hint="the root dir (ie c:\cfusionmx7\wwwroot)" type="string" required="true">
		<cfargument name="startDir" hint="the start dir (ie c:\cfusionmx7\wwwroot\foo)" type="string" required="true">
		<cfset var tree = getFlexplorer().makeCfcTree(arguments.rootDir, arguments.startDir)>
		<cfreturn tree />
	</cffunction>
	
	<cffunction name="setInvokeParams" output="false" access="remote" returntype="uuid" hint="i set the params for the invoke method cfc into the session scope and return the uuid that relates to that session">
		<cfargument name="pathToCfc" required="true" type="string"  >
		<cfargument name="initFirst" required="true" type="boolean" default="false">
		<cfargument name="initParams" required="false" type="array">
		<cfargument name="methodToInvoke" required="true" type="string">
		<cfargument name="parameters" required="true" type="array">
		<cfset var newKey = createUUID()>
		
		<cfset session.invokeParams[newkey] = structNew()>
		<cfset session.invokeParams[newkey].pathToCfc = arguments.pathToCfc>
		<cfset session.invokeParams[newkey].initFirst = arguments.initFirst>
		<cfset session.invokeParams[newkey].initParams = arguments.initParams>
		<cfset session.invokeParams[newkey].methodToInvoke = arguments.methodToInvoke>
		<cfset session.invokeParams[newkey].parameters = arguments.parameters>
		
		<cfreturn newKey/>
	</cffunction>
</cfcomponent>
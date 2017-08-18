<cfcomponent displayname="cfcFlexplorer">
	<!--- load utils --->
	<cfset variables.utils = createObject("component", "cfcFlexplorer.ColdFusion.com.utils")>
	
	<cffunction name="init" returntype="cfcFlexplorer" output="false" access="public">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getCfcMetaData" access="remote" output="false" returntype="struct">
		<cfargument name="pathToCfc" required="true" type="string">
		<cfset var theCfc = createObject("component", pathToCfc)>
		<cfreturn getMetaData(theCfc)/>
	</cffunction>

	<cffunction name="makeCfcTree" access="remote" hint="i make an xml tree containing all of the cfcs in the given dir" output="false" returntype="string">
		<cfargument name="rootDir" hint="the root dir (ie c:\cfusionmx7\wwwroot\)" type="string" required="true">
		<cfargument name="startDir" hint="the root dir (ie c:\cfusionmx7\wwwroot\)" type="string" required="false">
				
		<cfset var theXML = "">
		<cfset var dirQ = QueryNew("")>
		<cfset var qofDirQ = QueryNew("")>
		<cfif right(trim(arguments.rootDir), 1) is "\">
			<cfset arguments.rootDir = left(arguments.rootDir, len(arguments.rootDir)-1)>
		</cfif>
		
		<cfdirectory action="list" directory="#arguments.startDir#" filter="*.cfc" name="dirQ" recurse="true">
		<cfquery name="qofDirQ" dbtype="query">
		select directory,name
		from dirQ
		where lower(name) != 'application.cfc'
		and lower(directory) not like '%cfide%'
		order by directory,name
		</cfquery>
		<cfsavecontent variable="dirXML">
				<cfoutput query="qofDirQ" group="directory">
					<dir id="dir" label="#mid(replace(replace(qofDirQ.directory, arguments.rootDir, "", "all"), "\", ".", "all"),2, len(qofDirQ.directory)-1)#">
					<cfoutput group="name">
						<component id="component" componentPath="#mid(replace(replace(qofDirQ.directory, arguments.rootDir, "", "all"), "\", ".", "all"),2, len(qofDirQ.directory)-1)#<cfif len(mid(replace(replace(qofDirQ.directory, arguments.rootDir, "", "all"), "\", ".", "all"),2, len(qofDirQ.directory)-1))>.</cfif>#replace(qofDirQ.name, ".cfc", "", "all")#" label="#replace(qofDirQ.name, ".cfc", "", "all")#"></component>
					</cfoutput>
					</dir>
				</cfoutput>
		</cfsavecontent>

		<cfreturn dirXML/>
	</cffunction>
	
	<cffunction name="parseParam" access="remote" output="true" returntype="any" hint="i parse params and turn them into complex objects">
		<cfargument name="paramValue" type="string" required="true" hint="the param value">
		<cfargument name="paramType" type="string" required="true" hint="the param type">
		<cfset var returnParam = "">
		<cfswitch expression="#arguments.paramType#">
			<cfcase value="struct">
				<cfset returnParam = variables.utils.parseStruct(arguments.paramValue)>
			</cfcase>
			<!---  **FUTURE**	
			<cfcase value="query">
			</cfcase>
			<cfcase value="array">
			</cfcase> 
			--->
			<cfdefaultcase>
				<cfset returnParam = arguments.paramValue>
			</cfdefaultcase>
		</cfswitch>
		<cfreturn returnParam />
	</cffunction>
	
	<cffunction name="invokeMethod" access="remote" output="true" returntype="any">
		<cfargument name="pathToCfc" required="true" type="string">
		<cfargument name="initFirst" required="true" type="boolean" default="false">
		<cfargument name="initParams" required="false" type="array">
		<cfargument name="methodToInvoke" required="true" type="string">
		<cfargument name="parameters" required="true" type="array">
		<cfset var initCfc = "">
		<cfset var returnVar = "">
		<cfset var iniParams = ArrayNew(1)>
		<cfset var j = "">
		<cfset var params = ArrayNew(1)>
		
		<cfif arrayLen(arguments.parameters)>
			<cfset params = duplicate(arguments.parameters)>
		</cfif>
	
		<cfif structKeyExists(arguments, "initParams") and arrayLen(arguments.initParams)>
			<cfset iniParams = duplicate(arguments.initParams)>
		</cfif>
		
		<cfif initFirst>
			<cfset initCfc = initComponent(iniParams,arguments.pathToCfc)> 
		<cfelse>
			<cfset initCfc = arguments.pathToCfc>
		</cfif> 
		<cfinvoke component="#initCfc#" method="#arguments.methodToInvoke#" returnvariable="returnVar">
			<cfloop from="1" to="#arrayLen(params)#" index="j">
				<!--- param the value, it may not be passed in --->
				<cfparam name="params[j].value" default="">
				<cfif len(params[j].value)>
					<cfinvokeargument name="#params[j].name#" value="#parseParam(params[j].value,params[j].type)#"> 
				</cfif>
			</cfloop>
		</cfinvoke>
			
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="initComponent" access="remote" output="true" hint="i init components that need to be inited first">
		<cfargument name="params" type="array" hint="the ini params (if required)" required="false">
		<cfargument name="pathToCfc" required="true" type="string">
		<cfset var i = "">
		<cfset var iniParams = ArrayNew(1)>
		
		<cfif structKeyExists(arguments, "params")>
			<cfset iniParams = duplicate(arguments.params)>
		</cfif>

		<cfinvoke component="#arguments.pathToCfc#" method="init" returnvariable="initCfc">
			<cfif arrayLen(iniParams)>
				<cfloop from="1" to="#arrayLen(iniParams)#" index="i">
					<!--- param the value, it may not be passed in --->
					<cfparam name="iniParams[i].value" default="">
					<cfif len(iniParams[i].value)> 
						<cfinvokeargument name="#iniParams[i].name#" value="#parseParam(iniParams[i].value,iniParams[i].type)#">
					</cfif> 
				</cfloop>
			</cfif>
		</cfinvoke>
		<cfreturn initCfc />
	</cffunction>
	
	<cffunction name="saveCFCInfoToFile" access="remote" output="false" hint="Saves CFC location info to a file." returntype="xml">
		<cfset var xmlConfig = "">
		
		<cffile action="read" file="#ExpandPath("..\")#\XML\settings.xml" variable="XMLSettings">
		<cfset xmlConfig = XMLParse(trim(XMLSettings))>
		<cfoutput>
		<cfxml variable="xmlCFCDirData">
			<applications label="Coldfusion Applications" id="root">
				<cfloop from="1" to="#ArrayLen(xmlconfig.settings.roots.root)#" index="ndx">
					<cfif directoryExists(xmlConfig.settings.roots.root[ndx].XmlAttributes.dir)>
						<application label="#xmlConfig.settings.roots.root[ndx].XmlAttributes.appname#" rootdir="#xmlConfig.settings.roots.root[ndx].XmlAttributes.dir#">#makeCFCTree(xmlConfig.settings.roots.root[ndx].XmlAttributes.rootDir,xmlConfig.settings.roots.root[ndx].XmlAttributes.dir)#
						</application>
					</cfif>
				</cfloop>
			</applications>
		</cfxml>		
		</cfoutput>
		
		<cffile action="write" file="#ExpandPath("..\")#\XML\cfcdirinfo.xml" output="#toString(xmlCFCDirData)#">
		
		<cfreturn xmlCFCDirData/>		
	</cffunction>
</cfcomponent>
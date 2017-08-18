<cfcomponent>
	<cfset this.name = "cfcFlexplorer">
	<cfset this.sessionmanagement="yes">
	<cfset this.clientmanagement = "No">
	<cfset sessiontimeout= createTimeSpan(0,0,20,0)>
	<cfset applicationtimeout= createTimeSpan(1,0,0,0)>
	
	<cffunction name="onApplicationStart">
		<cfset application.cfcFlexplorer = createObject("component", "cfcFlexplorer.ColdFusion.com.cfcFlexplorer").init()>
		<cfset application.utils = createObject("component", "cfcFlexplorer.ColdFusion.com.utils")>
		<cfif not fileExists(expandPath("/cfcFlexplorer/XML/cfcdirinfo.xml"))>
			<cflocation url="/cfcFlexplorer/coldfusion/generateXMLDataFile.cfm?redir=true" addtoken="no">
		</cfif>
	</cffunction>
	
	<cffunction name="onSessionStart">
		<cfset session.invokeParams = structNew()>
	</cffunction>
	
	<cffunction name="onRequestStart">
		<cfif structKeyExists(url, "reinit")>
			<cfset onApplicationStart()>
		</cfif>
	</cffunction>
</cfcomponent>
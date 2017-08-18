<cfmodule template="tags/layout.cfm" title="Component Dump">
	<cfparam name="url.invokeKey" default="">
	<cfif structKeyExists(session.invokeParams, url.invokeKey)>
		<cftry>
			<cfset results = application.cfcFlexplorer.invokeMethod(argumentCollection=session.invokeParams[url.invokeKey])>
			<cfdump var="#results#">
			<cfcatch type="any">
				<span style="color:#FF0000; font-weight:bold;">An Error Has Occurred.</span>
				<br/>
				<br/>
				<cfdump var="#cfcatch#">
			</cfcatch>
		</cftry>
	<cfelse>
	<div>
		<span>Your component parameters cannot be found.  Your session may have expired.</span>
	</div>
	</cfif>
</cfmodule>
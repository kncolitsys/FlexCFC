<cfparam name="url.pathToCfc" default="">
<cfparam name="url.outputType" default="pdf">

<cfif url.outputType is "pdf">
	<cfset contentType = "application/pdf">
<cfelse>
	<cfset contentType = "application/x-shockwave-flash">
</cfif>
<cfcontent type="#contentType#" reset="yes" variable="#application.utils.cfcToPrinter(url.pathToCfc, url.outputType)#" />
<!---
DESCRIPTION: The purpose of this file is to generate an XML file containing a directory information of all the CFCs in all your applications. Run this whenever there's an update to your CFCs, or just run this as a scheduled task.
HISTORY: 11/10/06	Tariq Ahmed (tariq@dopejam.com)    Created
--->
<cfparam name="url.redir" default="false">
<span>Building XML Structure.  This may take several minutes.<cfif url.redir>  You will be redirected to cfcFlexplorer when the structure has been built.</cfif></span><br />

<cfset cfcDirInfo = application.cfcFlexplorer.saveCFCInfoToFile()>
<span>Structure built. If you are not redirected, use this link <cfoutput><a href="http://#cgi.HTTP_HOST#/cfcFlexplorerFlex/cfcFlexplorer.cfm">http://#cgi.HTTP_HOST#/cfcFlexplorer/Flex/cfcFlexplorer.cfm</a></cfoutput></span>
<cfif url.redir>
	<cflocation url="../Flex/cfcFlexplorer.cfm" addtoken="no">
</cfif>

<cfparam name="attributes.title" default="">
<cfsetting showdebugoutput="true">
<cfif thisTag.executionMode is "start">
<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>#attributes.title#</title>
</head>
<body>
</cfoutput>
<cfelse>
<cfoutput>
</div>
</body>
</html>
</cfoutput>
</cfif>

<cfcomponent displayname="utils">

	<!---
	 Given the fully-qualified path of a CFC, it renders the cfcexplorer.getcfcashtml() output to html, flahspaper, or PDF for printing as reference.
	 
	 @param cfcType 	 The CFC type. (Required)
	 @param outputType 	 Can be html, flashpaper, or pdf. Defaults to flashpaper. (Optional)
	 @return Returns either a string or binary data. 
	 @author Jared Rypka-Hauer (jared@web-relevant.com) 
	 @version 1, August 30, 2005 
	--->
	<cffunction name="cfcToPrinter" access="public" output="false"  returntype="any">
		<cfargument name="cfcType" type="string" required="true" />
		<cfargument name="outputType" type="string" required="false" default="flashPaper" />
		<cfset var myCfc = structNew()>
		<cfset var myExplorer =  createObject("component","CFIDE.componentutils.cfcexplorer")>
		<cfset var cfcDocument = "">
		<cfset var cfceData = "">
	
		<cfset myCfc.name = arguments.cfcType>
		<cfset myCfc.path = "/" & replace(myCfc.name,".","/","all") & ".cfc">
	
		<!--- Trap CFCExplorer's output --->
		<cfsavecontent  variable="cfceData">
			<cfoutput>#myExplorer.getcfcinhtml(myCfc.name,myCfc.path)#</cfoutput>
		</cfsavecontent>
	
		<!--- Clean up the HTML a bit... there's a lotta crap in that output  stream... --->
		<cfset cfceData = reReplace(cfceData,"\t*?\n","","all")>
		<cfset cfceData = reReplace(cfceData,"\s{2,}",chr(10),"all")>
	
		<!--- Switch up the output stream based on outputType argument --->
		<cfswitch expression="#arguments.outputType#">
			<cfcase value="html">
				<!--- Return tidied HTML for cfoutputting --->
				<cfreturn cfceData />
			</cfcase>
			<cfcase value="flashpaper,pdf">
				<!--- Return !! object !! (use cfcontent to set the right mime  type!!) --->
				<cfdocument fontembed="true" name="cfcDocument"  format="#arguments.outputType#">
					<cfoutput>#cfceData#</cfoutput>
				</cfdocument>
				<cfreturn cfcDocument />
			</cfcase>
		<cfdefaultcase>
			<cfthrow message="Invalid data for argument outputType:  #arguments.outputType#"
				detail="Your choices for outputType are pdf, flashpaper, or html." />
		</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="parseStruct" access="remote" output="false" returntype="struct" hint="i convert a key value list to a struct">
		<cfargument name="keyValueList" type="string" required="true" hint="a comma seperated key value list (ie key=value, keyfoo=valuefoo">
		<cfset var returnStruct = StructNew()>
		<cfset var tempStruct = StructNew()>
		<cfset var thisKey = "">
		<cfset var thisValue = "">
		<cfset var i = "">
		
		<cfloop from="1" to="#listLen(arguments.keyValueList)#"index="i">
			<cfset thisKey = listFirst(listGetAt(arguments.keyValueList, i), "=")>
			<cfset thisValue = listLast(listGetAt(arguments.keyValueList, i), "=")>
			<cfset tempStruct[thisKey] = thisValue>
			<cfset structAppend(returnStruct, tempStruct, "true")>
		</cfloop>
		
		<cfreturn returnStruct />
	</cffunction>

</cfcomponent>
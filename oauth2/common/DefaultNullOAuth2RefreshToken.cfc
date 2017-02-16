<cfcomponent
	displayname="Class DefaultNullOAuth2RefreshToken"
	implements="app.security.oauth2.common.OAuth2RefreshToken"
	output="false">

	<cffunction name="init" access="public" returntype="app.security.oauth2.common.DefaultNullOAuth2RefreshToken" output="false">
		<cfreturn this />
	</cffunction>

	<cffunction name="getValue" access="public" returntype="string" output="false">
		<cfreturn "" />
	</cffunction>

</cfcomponent>
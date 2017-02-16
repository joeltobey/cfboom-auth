<cfinterface displayname="Interface OAuth2AccessToken">

	<cffunction name="getRefreshToken" access="public" returntype="app.security.auth.common.AuthRefreshToken" output="false" />

	<cffunction name="getValue" access="public" returntype="string" output="false" />

</cfinterface>
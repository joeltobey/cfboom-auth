<cfinterface displayname="Interface ClientAuthenticationHandler">

	<cffunction name="authenticateTokenRequest" access="public" returntype="void" output="false">
		<cfargument name="resource" type="app.security.oauth2.client.resource.OAuth2ProtectedResourceDetails" required="true" />
		<cfargument name="form" type="struct" required="true" />
		<cfargument name="headers" type="struct" required="true" />
	</cffunction>

</cfinterface>
<cfinterface displayname="Interface AccessTokenProvider">

	<!---
	/**
	 * Obtain a new access token for the specified protected resource.
	 * 
	 * @param details The protected resource for which this provider is to obtain an access token.
	 * @param parameters The parameters of the request giving context for the token details if any.
	 * @return The access token for the specified protected resource. The return value may NOT be null.
	 * @throws UserRedirectRequiredException If the provider requires the current user to be redirected for
	 * authorization.
	 * @throws UserApprovalRequiredException If the provider is ready to issue a token but only if the user approves
	 * @throws AccessDeniedException If the user denies access to the protected resource.
	 */
	--->
	<cffunction name="obtainAccessToken" access="public" returntype="app.security.oauth2.common.OAuth2AccessToken" output="false">
		<cfargument name="details" type="app.security.oauth2.client.resource.OAuth2ProtectedResourceDetails" required="true" />
		<cfargument name="parameters" type="app.security.oauth2.client.token.AccessTokenRequest" required="true" />
	</cffunction>

	<!---
	/**
	 * Whether this provider supports the specified resource.
	 * 
	 * @param resource The resource.
	 * @return Whether this provider supports the specified resource.
	 */
	--->
	<cffunction name="supportsResource" access="public" returntype="boolean" output="false">
		<cfargument name="resource" type="app.security.oauth2.client.resource.OAuth2ProtectedResourceDetails" required="true" />
	</cffunction>

	<!---
	/**
	 * @param resource the resource for which a token refresh is required
	 * @param refreshToken the refresh token to send
	 * @return an access token
	 */
	--->
	<cffunction name="refreshAccessToken" access="public" returntype="app.security.oauth2.common.OAuth2AccessToken" output="false">
		<cfargument name="resource" type="app.security.oauth2.client.resource.OAuth2ProtectedResourceDetails" required="true" />
		<cfargument name="refreshToken" type="app.security.oauth2.common.OAuth2RefreshToken" required="true" />
		<cfargument name="request" type="app.security.oauth2.client.token.AccessTokenRequest" required="true" />
	</cffunction>

	<!---
	/**
	 * @param resource The resource to check
	 * @return true if this provider can refresh an access token
	 */
	--->
	<cffunction name="supportsRefresh" access="public" returntype="boolean" output="false">
		<cfargument name="resource" type="app.security.oauth2.client.resource.OAuth2ProtectedResourceDetails" required="true" />
	</cffunction>

</cfinterface>
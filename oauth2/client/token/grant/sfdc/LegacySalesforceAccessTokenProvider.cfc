<cfcomponent
	displayname="Class LegacySalesforceAccessTokenProvider"
	extends="app.security.oauth2.client.token.OAuth2AccessTokenSupport"
	implements="app.security.oauth2.client.token.AccessTokenProvider"
	output="false">

	<cffunction name="init" access="public" returntype="app.security.oauth2.client.token.grant.sfdc.LegacySalesforceAccessTokenProvider" output="false">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="supportsRefresh" access="public" returntype="boolean" output="false">
		<cfargument name="resource" type="app.security.oauth2.client.resource.OAuth2ProtectedResourceDetails" required="true" />
		<cfreturn true />
	</cffunction>

	<cffunction name="obtainAccessToken" access="public" returntype="app.security.oauth2.common.OAuth2AccessToken" output="false">
		<cfargument name="details" type="app.security.oauth2.client.resource.OAuth2ProtectedResourceDetails" required="true" />
		<cfargument name="parameters" type="app.security.oauth2.client.token.AccessTokenRequest" required="true" />
		<cfscript>
			local['credentials'] = getCredentials(arguments.parameters);
			return createAccessTokenFromCredentials(arguments.parameters, local.credentials);
		</cfscript>
	</cffunction>

	<cffunction name="getCredentials" access="private" returntype="any" output="false">
		<cfargument name="parameters" type="app.security.oauth2.client.token.AccessTokenRequest" required="true" />
		<cfscript>
			var CredentialObject = arguments.parameters.get("credentialObject");
			if (!isInstanceOf(CredentialObject, "app.model.dojo.object.Credential"))
				throw("CredentialObject is not instance of 'app.model.dojo.object.Credential'","IllegalStateException");
			local['args'] = {};
			local.args['loggedInUserId'] = arguments.parameters.get("loggedInUserId");
			local.args['AccountId'] = arguments.parameters.get("accountId");
			local.args['Vendor'] = "LegacySalesforce";
			local.args['fields'] = "Id,AccountId,Vendor,IssuedAt,AccessToken,RefreshToken,AuthenticatedUserId,InstanceUrl";
			return CredentialObject.get(argumentCollection:local.args);
		</cfscript>
	</cffunction>

	<cffunction name="createAccessTokenFromCredentials" access="private" returntype="app.security.oauth2.sfdc.SalesforceOAuth2AccessToken" output="false">
		<cfargument name="parameters" type="app.security.oauth2.client.token.AccessTokenRequest" required="true" />
		<cfargument name="credentials" type="any" required="true" />
		<cfscript>
			if (arguments.credentials.result.recordCount == 1) {
				local['accessToken'] = createAccessTokenFromLegacyQuery(arguments.parameters, arguments.credentials.query);
				if (local.accessToken.isExpired()) {
					arguments.parameters.put("credentialId", arguments.credentials.query.Id);
					return refreshAccessToken(new app.security.oauth2.client.resource.BaseOAuth2ProtectedResourceDetails(), local.accessToken.getRefreshToken(), arguments.parameters);
				} else {
					return local.accessToken;
				}
			} else {
				throw("There are no credentials for accountId '#arguments.parameters.get('accountId')#'","IllegalStateException");
			}
		</cfscript>
	</cffunction>

	<cffunction name="createAccessTokenFromLegacyQuery" access="private" returntype="app.security.oauth2.sfdc.SalesforceOAuth2AccessToken" output="false">
		<cfargument name="parameters" type="app.security.oauth2.client.token.AccessTokenRequest" required="true" />
		<cfargument name="credentialQuery" type="query" required="true" />
		<cfscript>
			local['accessToken'] = new app.security.oauth2.sfdc.DefaultSalesforceOAuth2AccessToken(arguments.credentialQuery.AccessToken);
			local.accessToken.setVendor(arguments.credentialQuery.Vendor);
			local.accessToken.setExpiration(dateAdd(arguments.parameters.get("offsetDatepart"), arguments.parameters.get("offsetNumber"), dateConvert( "utc2Local", arguments.credentialQuery.IssuedAt )));
			local.accessToken.setRefreshToken(new app.security.oauth2.common.DefaultOAuth2RefreshToken(arguments.credentialQuery.RefreshToken));
			local.accessToken.setId(arguments.credentialQuery.AuthenticatedUserId);
			local.accessToken.setInstanceUrl(arguments.credentialQuery.InstanceUrl);
			return local.accessToken;
		</cfscript>
	</cffunction>

	<cffunction name="supportsResource" access="public" returntype="boolean" output="false">
		<cfargument name="resource" type="app.security.oauth2.client.resource.OAuth2ProtectedResourceDetails" required="true" />
		<cfreturn true />
	</cffunction>

	<cffunction name="refreshAccessToken" access="public" returntype="app.security.oauth2.common.OAuth2AccessToken" output="false">
		<cfargument name="resource" type="app.security.oauth2.client.resource.OAuth2ProtectedResourceDetails" required="true" />
		<cfargument name="refreshToken" type="app.security.oauth2.common.OAuth2RefreshToken" required="true" />
		<cfargument name="request" type="app.security.oauth2.client.token.AccessTokenRequest" required="true" />
		<cfscript>
			var attempts = 1;
			local['httpResponse'] = obtainAccessTokenFromLegacyService(arguments.request, arguments.refreshToken);

			if (local.httpResponse.hasFailed()) {
				while (attempts <= 3) {
					local['httpResponse'] = obtainAccessTokenFromLegacyService(arguments.request, arguments.refreshToken);
					if (local.httpResponse.hasFailed()) {
						attempts++;
					} else {
						break;
					}
				}
			}
			if (local.httpResponse.hasFailed()) {
				throw(message=local.httpResponse.getErrorMessage(),type="LegacyOAuthException",extendedInfo=local.httpResponse.getContent());
			}

			updateCredentials(arguments.request, local.httpResponse);

			local['credentials'] = getCredentials(arguments.request);

			if (local.credentials.result.recordCount == 1) {
				local['accessToken'] = createAccessTokenFromLegacyQuery(arguments.request, local.credentials.query);
				if (local.accessToken.isExpired()) {
					throw("access_token is expired even after refreshing.","IllegalStateException");
				} else {
					return local.accessToken;
				}
			} else {
				throw("There are no credentials for accountId '#arguments.parameters.get('accountId')#'","IllegalStateException");
			}
		</cfscript>
	</cffunction>

	<cffunction name="obtainAccessTokenFromLegacyService" access="public" returntype="app.http.client.LegacySfdcOauthResponse" output="false">
		<cfargument name="request" type="app.security.oauth2.client.token.AccessTokenRequest" required="true" />
		<cfargument name="refreshToken" type="app.security.oauth2.common.OAuth2RefreshToken" required="true" />
		<cfscript>
			local['httpRequest'] = new app.http.client.DefaultClientHttpRequest("GET",arguments.request.getCurrentUri());
			local.httpRequest.addQueryParam("userid", arguments.request.get("userid"));
			local.httpRequest.addQueryParam("password", arguments.request.get("password"));
			local.httpRequest.addQueryParam("id", arguments.refreshToken.getValue());
			return new app.http.client.LegacySfdcOauthResponse(local.httpRequest.execute());
		</cfscript>
	</cffunction>

	<cffunction name="updateCredentials" access="private" returntype="void" output="false">
		<cfargument name="parameters" type="app.security.oauth2.client.token.AccessTokenRequest" required="true" />
		<cfargument name="httpResponse" type="app.http.client.LegacySfdcOauthResponse" required="true" />
		<cfscript>
			var CredentialObject = arguments.parameters.get("credentialObject");
			if (!isInstanceOf(CredentialObject, "app.model.dojo.object.Credential"))
				throw("CredentialObject is not instance of 'app.model.dojo.object.Credential'","IllegalStateException");

			local['args'] = {};
			local.args['loggedInUserId'] = arguments.parameters.get("loggedInUserId");
			local.args['LastModifiedById'] = arguments.parameters.get("loggedInUserId");
			local.args['Id'] = arguments.parameters.get("credentialId");
			local.args['AccountId'] = arguments.parameters.get("accountId");
			local['issuedAtArray'] = listToArray(arguments.httpResponse.getIssued_at(),"/");
			local['issuedAtLocal'] = createDateTime(local.issuedAtArray[1], local.issuedAtArray[2], local.issuedAtArray[3], local.issuedAtArray[4], local.issuedAtArray[5], local.issuedAtArray[6]);
			local['issuedAt'] = dateConvert( "local2utc", local.issuedAtLocal);
			local.args['IssuedAt'] = local.issuedAt;
			local.args['AccessToken'] = arguments.httpResponse.getAccess_token();
			local.args['InstanceUrl'] = arguments.httpResponse.getInstance_url();
			CredentialObject.update(argumentCollection:local.args);
		</cfscript>
	</cffunction>

</cfcomponent>
<cfcomponent
	displayname="Class SalesforceAccessTokenProvider"
	extends="app.security.oauth2.client.token.OAuth2AccessTokenSupport"
	implements="app.security.oauth2.client.token.AccessTokenProvider"
	output="false">

	<cffunction name="init" access="public" returntype="app.security.oauth2.client.token.grant.sfdc.SalesforceAccessTokenProvider" output="false">
		<cfargument name="emailService" type="app.service.EmailService" required="true" />
		<cfscript>
			_EmailService = arguments.emailService;
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
			return createAccessTokenFromCredentials(arguments.details, arguments.parameters, local.credentials);
		</cfscript>
	</cffunction>

	<cffunction name="getCredentials" access="public" returntype="any" output="false">
		<cfargument name="parameters" type="app.security.oauth2.client.token.AccessTokenRequest" required="true" />
		<cfscript>
			var CredentialObject = arguments.parameters.get("credentialObject");
			if (!isInstanceOf(CredentialObject, "app.model.dojo.object.Credential"))
				throw("CredentialObject is not instance of 'app.model.dojo.object.Credential'","IllegalStateException");
			var environment = arguments.parameters.get("environment");
			local['args'] = {};
			local.args['loggedInUserId'] = arguments.parameters.get("loggedInUserId");
			local.args['UserId'] = arguments.parameters.get("userId");
			local.args['Status'] = "Active";
			if (environment == "Production") {
				local.args['Vendor'] = "Salesforce";
			} else {
				local.args['Vendor'] = "Salesforce_Sandbox";
			}
			local.args['fields'] = "Id,AccountId,UserId,Username,Vendor,Status,AuthorizationCode,IssuedAt,AccessToken,RefreshToken,AuthenticatedUserId,InstanceUrl,Signature,Scope,TokenType,IdToken";
			return CredentialObject.get(argumentCollection:local.args);
		</cfscript>
	</cffunction>

	<cffunction name="createAccessTokenFromCredentials" access="private" returntype="app.security.oauth2.sfdc.SalesforceOAuth2AccessToken" output="false">
		<cfargument name="details" type="app.security.oauth2.client.resource.OAuth2ProtectedResourceDetails" required="true" />
		<cfargument name="parameters" type="app.security.oauth2.client.token.AccessTokenRequest" required="true" />
		<cfargument name="credentials" type="any" required="true" />
		<cfscript>
			if (arguments.credentials.result.recordCount == 1) {
				local['accessToken'] = createAccessTokenFromCredentialsQuery(arguments.parameters, arguments.credentials.query);
				if (local.accessToken.isExpired()) {
					arguments.parameters.put("credentialId", arguments.credentials.query.Id);
					return refreshAccessToken(arguments.details, local.accessToken.getRefreshToken(), arguments.parameters);
				} else {
					return local.accessToken;
				}
			} else {
				throw("There are no credentials for userId '#arguments.parameters.get('userId')#'","IllegalStateException");
			}
		</cfscript>
	</cffunction>

	<cffunction name="createAccessTokenFromCredentialsQuery" access="private" returntype="app.security.oauth2.sfdc.SalesforceOAuth2AccessToken" output="false">
		<cfargument name="parameters" type="app.security.oauth2.client.token.AccessTokenRequest" required="true" />
		<cfargument name="credentialQuery" type="query" required="true" />
		<cfscript>
			local['accessToken'] = new app.security.oauth2.sfdc.DefaultSalesforceOAuth2AccessToken(arguments.credentialQuery.AccessToken);
			local.accessToken.setVendor(arguments.credentialQuery.Vendor);
			local.accessToken.setExpiration(dateAdd(arguments.parameters.get("offsetDatepart"), arguments.parameters.get("offsetNumber"), dateConvert( "utc2Local", arguments.credentialQuery.IssuedAt )));
			local.accessToken.setRefreshToken(new app.security.oauth2.common.DefaultOAuth2RefreshToken(arguments.credentialQuery.RefreshToken));
			local.accessToken.setId(arguments.credentialQuery.AuthenticatedUserId);
			local.accessToken.setInstanceUrl(arguments.credentialQuery.InstanceUrl);
			local.accessToken.setSignature(arguments.credentialQuery.Signature);
			local.accessToken.setScope(listToArray(arguments.credentialQuery.Scope, " "));
			local.accessToken.setTokenType(arguments.credentialQuery.TokenType);
			local.accessToken.setIdToken(arguments.credentialQuery.IdToken);
			local.accessToken.setUserId(arguments.parameters.get("userId"));
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
			local['httpResponse'] = obtainAccessTokenFromRefreshToken(arguments.resource, arguments.refreshToken);

			if (local.httpResponse.hasError()) {
				var debugStruct = {};
				debugStruct['resource'] = arguments.resource.getInstance();
				debugStruct['refreshToken'] = arguments.refreshToken.getValue();
				_EmailService.sendDebugEmail(debugStruct, "OAuthException Debug");
				throw(message=local.httpResponse.getError() & " " & local.httpResponse.getErrorDescription(),type="OAuthException",extendedInfo=local.httpResponse.getContent());
			}

			updateCredentials(arguments.request, local.httpResponse);

			local['credentials'] = getCredentials(arguments.request);

			if (local.credentials.result.recordCount == 1) {
				local['accessToken'] = createAccessTokenFromCredentialsQuery(arguments.request, local.credentials.query);
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

	<cffunction name="obtainAccessTokenFromRefreshToken" access="public" returntype="app.http.client.SfdcOauthResponse" output="false">
		<cfargument name="resource" type="app.security.oauth2.client.resource.OAuth2ProtectedResourceDetails" required="true" />
		<cfargument name="refreshToken" type="app.security.oauth2.common.OAuth2RefreshToken" required="true" />
		<cfscript>
			local['httpRequest'] = new app.http.client.DefaultClientHttpRequest("POST",arguments.resource.getAccessTokenUri());
			local.httpRequest.addFormField("grant_type", arguments.resource.getGrantType());
			local.httpRequest.addFormField("client_id", arguments.resource.getClientId());
			local.httpRequest.addFormField("client_secret", arguments.resource.getClientSecret());
			local.httpRequest.addFormField("refresh_token", arguments.refreshToken.getValue());
			return new app.http.client.SfdcOauthResponse(local.httpRequest.execute());
		</cfscript>
	</cffunction>

	<cffunction name="updateCredentials" access="private" returntype="void" output="false">
		<cfargument name="parameters" type="app.security.oauth2.client.token.AccessTokenRequest" required="true" />
		<cfargument name="httpResponse" type="app.http.client.SfdcOauthResponse" required="true" />
		<cfscript>
			var CredentialObject = arguments.parameters.get("credentialObject");
			if (!isInstanceOf(CredentialObject, "app.model.dojo.object.Credential"))
				throw("CredentialObject is not instance of 'app.model.dojo.object.Credential'","IllegalStateException");

			local['args'] = {};
			local.args['loggedInUserId'] = arguments.parameters.get("loggedInUserId");
			local.args['LastModifiedById'] = arguments.parameters.get("loggedInUserId");
			local.args['Id'] = arguments.parameters.get("credentialId");
			local.args['IssuedAt'] = arguments.httpResponse.getIssued_at();
			local.args['AccessToken'] = arguments.httpResponse.getAccess_token();
			local.args['InstanceUrl'] = arguments.httpResponse.getInstance_url();
			local.args['AuthenticatedUserId'] = arguments.httpResponse.getId();
			local.args['Scope'] = arguments.httpResponse.get_scope();
			local.args['Signature'] = arguments.httpResponse.getSignature();
			local.args['TokenType'] = arguments.httpResponse.getToken_type();
			CredentialObject.update(argumentCollection:local.args);
		</cfscript>
	</cffunction>

</cfcomponent>

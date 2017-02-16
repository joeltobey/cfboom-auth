<cfcomponent
	displayname="Class DefaultExpiringOAuth2RefreshToken"
	implements="app.security.oauth2.common.ExpiringOAuth2RefreshToken"
	extends="app.security.oauth2.common.DefaultOAuth2RefreshToken"
	output="false">

	<cffunction name="init" access="public" returntype="app.security.oauth2.common.DefaultExpiringOAuth2RefreshToken" output="false">
		<cfargument name="value" type="string" required="true" />
		<cfargument name="expiration" type="date" required="true" />
		<cfscript>
			super.init(arguments.value);
			variables['_expiration'] = arguments.expiration;
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getExpiration" access="public" returntype="date" output="false">
		<cfreturn variables._expiration />
	</cffunction>

	<cffunction name="toString" access="public" returntype="string" output="false">
		<cfreturn getValue() />
	</cffunction>

</cfcomponent>
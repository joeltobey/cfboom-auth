<cfcomponent
	displayname="Class DefaultOAuth2RefreshToken"
	implements="app.security.auth.common.AuthRefreshToken"
	output="false">

	<cffunction name="init" access="public" returntype="app.security.auth.common.DefaultAuthRefreshToken" output="false">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="value" type="string" required="true" />
		<cfscript>
			variables['_id'] = arguments.id;
			variables['_value'] = arguments.value;
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getId" access="public" returntype="numeric" output="false">
		<cfreturn variables._id />
	</cffunction>

	<cffunction name="getValue" access="public" returntype="string" output="false">
		<cfreturn variables._value />
	</cffunction>

	<cffunction name="toString" access="public" returntype="string" output="false">
		<cfreturn getValue() />
	</cffunction>

</cfcomponent>
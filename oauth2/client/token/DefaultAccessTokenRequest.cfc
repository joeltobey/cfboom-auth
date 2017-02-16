<cfcomponent
	implements="app.security.oauth2.client.token.AccessTokenRequest"
	displayname="Class DefaultAccessTokenRequest"
	output="false">

	<cfscript>
		this['isEmpty'] = $isEmpty;

		variables['_parameters'] = {};

		variables['_state'] = "";

		variables['_existingToken'] = new app.security.oauth2.common.DefaultOAuth2AccessToken("none");

		variables['_currentUri'] = "";

		variables['_cookie'] = "";

		variables['_headers'] = {};
	</cfscript>

	<cffunction name="init" access="public" returntype="app.security.oauth2.client.token.DefaultAccessTokenRequest" output="false">
		<cfargument name="parameters" type="struct" required="false" />
		<cfscript>
			if (structKeyExists(arguments,"parameters")) {
				for (var param in arguments.parameters) {
					variables._parameters[param] = arguments.parameters[param];
				}
			}
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="isError" access="public" returntype="boolean" output="false">
		<cfreturn structKeyExists(variables._parameters, "error") />
	</cffunction>

	<cffunction name="getPreservedState" access="public" returntype="any" output="false">
		<cfreturn variables._state />
	</cffunction>

	<cffunction name="setPreservedState" access="public" returntype="void" output="false">
		<cfargument name="state" type="any" required="true" />
		<cfset variables['_state'] = arguments.state />
	</cffunction>

	<cffunction name="getStateKey" access="public" returntype="string" output="false">
		<cfscript>
			if (structKeyExists(variables._parameters,"state")) {
				return variables._parameters.state;
			} else {
				return "";
			}
		</cfscript>
	</cffunction>

	<cffunction name="setStateKey" access="public" returntype="void" output="false">
		<cfargument name="state" type="string" required="true" />
		<cfset variables._parameters['state'] = arguments.state />
	</cffunction>

	<cffunction name="getCurrentUri" access="public" returntype="string" output="false">
		<cfreturn variables._currentUri />
	</cffunction>

	<cffunction name="setCurrentUri" access="public" returntype="void" output="false">
		<cfargument name="uri" type="string" required="true" />
		<cfset variables['_currentUri'] = arguments.uri />
	</cffunction>

	<cffunction name="getAuthorizationCode" access="public" returntype="string" output="false">
		<cfscript>
			if (structKeyExists(variables._parameters,"code")) {
				return variables._parameters.code;
			} else {
				return "";
			}
		</cfscript>
	</cffunction>

	<cffunction name="setAuthorizationCode" access="public" returntype="void" output="false">
		<cfargument name="code" type="string" required="true" />
		<cfset variables._parameters['code'] = arguments.code />
	</cffunction>

	<cffunction name="setCookie" access="public" returntype="void" output="false">
		<cfargument name="cookie" type="string" required="true" />
		<cfset variables['_cookie'] = arguments.cookie />
	</cffunction>

	<cffunction name="getCookie" access="public" returntype="string" output="false">
		<cfreturn variables._cookie />
	</cffunction>

	<cffunction name="setHeaders" access="public" returntype="void" output="false">
		<cfargument name="headers" type="struct" required="true" />
		<cfset variables['_headers'] = arguments.headers />
	</cffunction>

	<cffunction name="getHeaders" access="public" returntype="struct" output="false">
		<cfreturn variables._headers />
	</cffunction>

	<cffunction name="setExistingToken" access="public" returntype="void" output="false">
		<cfargument name="existingToken" type="app.security.oauth2.common.OAuth2AccessToken" required="true" />
		<cfset variables['_existingToken'] = arguments.existingToken />
	</cffunction>

	<cffunction name="getExistingToken" access="public" returntype="app.security.oauth2.common.OAuth2AccessToken" output="false">
		<cfreturn variables._existingToken />
	</cffunction>

	<cffunction name="add" access="public" returntype="void" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfset variables._parameters[arguments.key] = arguments.value />
	</cffunction>

	<cffunction name="set" access="public" returntype="void" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfset variables._parameters[arguments.key] = arguments.value />
	</cffunction>

	<cffunction name="put" access="public" returntype="void" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfset variables._parameters[arguments.key] = arguments.value />
	</cffunction>

	<cffunction name="toSingleValueMap" access="public" returntype="struct" output="false">
		<cfreturn variables._parameters />
	</cffunction>

	<cffunction name="size" access="public" returntype="numeric" output="false">
		<cfreturn structCount(variables._parameters) />
	</cffunction>

	<cffunction name="$isEmpty" access="public" returntype="boolean" output="false">
		<cfreturn structIsEmpty(variables._parameters) />
	</cffunction>

	<cffunction name="containsKey" access="public" returntype="boolean" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfreturn structKeyExists(variables._parameters, arguments.key) />
	</cffunction>

	<cffunction name="containsValue" access="public" returntype="boolean" output="false">
		<cfargument name="value" type="any" required="true" />
		<cfreturn structFindValue(variables._parameters, arguments.value) />
	</cffunction>

	<cffunction name="get" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfscript>
			if (structKeyExists(variables._parameters,arguments.key)) {
				return variables._parameters[arguments.key];
			} else {
				return "";
			}
		</cfscript>
	</cffunction>

	<cffunction name="remove" access="public" returntype="void" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfset structDelete(variables._parameters, arguments.key) />
	</cffunction>

	<cffunction name="clear" access="public" returntype="void" output="false">
		<cfset structClear(variables._parameters) />
	</cffunction>

	<cffunction name="values" access="public" returntype="struct" output="false">
		<cfreturn variables._parameters />
	</cffunction>

</cfcomponent>
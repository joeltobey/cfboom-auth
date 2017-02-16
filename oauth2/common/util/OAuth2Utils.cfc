<cfcomponent displayname="Abstract Class OAuth2Utils" output="false">

	<cfscript>
		/**
		 * Constant to use while parsing and formatting parameter maps for OAuth2 requests
		 */
		CLIENT_ID = "client_id";
		this['CLIENT_ID'] = CLIENT_ID;
	
		/**
		 * Constant to use while parsing and formatting parameter maps for OAuth2 requests
		 */
		STATE = "state";
		this['STATE'] = STATE;
	
		/**
		 * Constant to use while parsing and formatting parameter maps for OAuth2 requests
		 */
		SCOPE = "scope";
		this['SCOPE'] = SCOPE;
	
		/**
		 * Constant to use while parsing and formatting parameter maps for OAuth2 requests
		 */
		REDIRECT_URI = "redirect_uri";
		this['REDIRECT_URI'] = REDIRECT_URI;
	
		/**
		 * Constant to use while parsing and formatting parameter maps for OAuth2 requests
		 */
		RESPONSE_TYPE = "response_type";
		this['RESPONSE_TYPE'] = RESPONSE_TYPE;
	
		/**
		 * Constant to use while parsing and formatting parameter maps for OAuth2 requests
		 */
		USER_OAUTH_APPROVAL = "user_oauth_approval";
		this['USER_OAUTH_APPROVAL'] = USER_OAUTH_APPROVAL;
	
		/**
		 * Constant to use as a prefix for scope approval
		 */
		SCOPE_PREFIX = "scope.";
		this['SCOPE_PREFIX'] = SCOPE_PREFIX;
	
		/**
		 * Constant to use while parsing and formatting parameter maps for OAuth2 requests
		 */
		GRANT_TYPE = "grant_type";
		this['GRANT_TYPE'] = GRANT_TYPE;
	</cfscript>

</cfcomponent>
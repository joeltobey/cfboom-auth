component
	extends="cfboom.lang.Object"
	implements="cfboom.security.oauth2.common.OAuth2AccessToken" 
	displayname="Class DefaultOAuth2AccessToken"
	output="false"
{
	import cfboom.security.oauth2.common.DefaultOAuth2AccessToken;
	import cfboom.security.oauth2.common.DefaultOAuth2RefreshToken;

	this['equals'] = $equals;

	variables['BEARER_TYPE'] = "Bearer";
	this['BEARER_TYPE'] = BEARER_TYPE;

	variables['OAUTH2_TYPE'] = "OAuth2";
	this['OAUTH2_TYPE'] = OAUTH2_TYPE;

	variables['ACCESS_TOKEN'] = "access_token";
	this['ACCESS_TOKEN'] = ACCESS_TOKEN;

	variables['TOKEN_TYPE'] = "token_type";
	this['TOKEN_TYPE'] = TOKEN_TYPE;

	variables['EXPIRES_IN'] = "expires_in";
	this['EXPIRES_IN'] = EXPIRES_IN;

	variables['REFRESH_TOKEN'] = "refresh_token";
	this['REFRESH_TOKEN'] = REFRESH_TOKEN;

	variables['SCOPE'] = "scope";
	this['SCOPE'] = SCOPE;

	_instance['tokenType'] = BEARER_TYPE.toLowerCase();

	_instance['additionalInformation'] = {};

	public cfboom.security.oauth2.common.DefaultOAuth2AccessToken function init(string value, cfboom.security.oauth2.common.OAuth2AccessToken accessToken) {
		if (structKeyExists(arguments, "value")) {
			setValue( arguments.value );
		} else if (structKeyExists(arguments, "accessToken")) {
			setValue( arguments.accessToken.getValue() );
			setAdditionalInformation( arguments.accessToken.getAdditionalInformation() );
			setRefreshToken( arguments.accessToken.getRefreshToken() );
			setExpiration( arguments.accessToken.getExpiration() );
			setScope( arguments.accessToken.getScope() );
			setTokenType( arguments.accessToken.getTokenType() );
		}
		return this;
	}

	public void function setValue(required string value) {
		_instance['value'] = arguments.value;
	}

	/**
	 * The token value.
	 * 
	 * @return The token value.
	 */
	public string function getValue() {
		return _instance.value;
	}

	public numeric function getExpiresIn() {
		if (!structKeyExists(_instance, "expiration")) {
			return javaCast("int", 0);
		}
		var expires = (_instance.expiration.getTime() - createObject("java", "java.lang.System").currentTimeMillis()) / 1000;
		expires = createObject("java", "java.lang.Long").valueOf( javaCast("long", expires) );
		return expires.intValue();
		
	}

	public void function setExpiresIn(numeric delta = 0) {
		setExpiration(createObject("java", "java.util.Date").init(createObject("java", "java.lang.System").currentTimeMillis() + javaCast("int", arguments.delta)));
	}

	/**
	 * The instant the token expires.
	 * 
	 * @return The instant the token expires.
	 */
	public any function getExpiration() {
		if (structKeyExists(_instance, "expiration"))
			return _instance.expiration;
	}

	/**
	 * The instant the token expires.
	 * 
	 * @param expiration The instant the token expires.
	 */
	public void function setExpiration(date expiration) {
		if (structKeyExists(arguments, "expiration"))
			_instance['expiration'] = arguments.expiration;
	}

	/**
	 * Convenience method for checking expiration
	 * 
	 * @return true if the expiration is befor ethe current time
	 */
	public boolean function isExpired() {
		return structKeyExists(_instance, "expiration") && _instance.expiration.before( createObject("java", "java.util.Date").init() );
	}

	/**
	 * The token type, as introduced in draft 11 of the OAuth 2 spec. The spec doesn't define (yet) that the valid token
	 * types are, but says it's required so the default will just be "undefined".
	 * 
	 * @return The token type, as introduced in draft 11 of the OAuth 2 spec.
	 */
	public string function getTokenType() {
		if (structKeyExists(_instance, "tokenType")) {
			return _instance.tokenType;
		} else {
			return "undefined";
		}
	}

	/**
	 * The token type, as introduced in draft 11 of the OAuth 2 spec.
	 * 
	 * @param tokenType The token type, as introduced in draft 11 of the OAuth 2 spec.
	 */
	public void function setTokenType(string tokenType = "undefined") {
		_instance['tokenType'] = arguments.tokenType;
	}

	/**
	 * The refresh token associated with the access token, if any.
	 * 
	 * @return The refresh token associated with the access token, if any.
	 */
	public any function getRefreshToken() {
		if (structKeyExists(_instance, "refreshToken"))
			return _instance.refreshToken;
	}

	/**
	 * The refresh token associated with the access token, if any.
	 * 
	 * @param refreshToken The refresh token associated with the access token, if any.
	 */
	public void function setRefreshToken(cfboom.security.oauth2.common.OAuth2RefreshToken refreshToken) {
		if (structKeyExists(arguments, "refreshToken"))
			_instance['refreshToken'] = arguments.refreshToken;
	}

	/**
	 * The scope of the token.
	 * 
	 * @return The scope of the token.
	 */
	public string function getScope() {
		if (structKeyExists(_instance, "scope"))
			return _instance.scope;
	}

	/**
	 * The scope of the token.
	 * 
	 * @param scope The scope of the token.
	 */
	public void function setScope(string scope) {
		if (structKeyExists(arguments, "scope"))
			_instance['scope'] = arguments.scope;
	}

	private boolean function $equals(any obj) {
		if (!structKeyExists(arguments, "obj"))
			return false;
		var expected = this.toString();
		return expected.equals( arguments.obj.toString() );
	}

	public numeric function hashCode() {
		return toString().hashCode();
	}

	public string function toString() {
		return createObject("java", "java.lang.String").valueOf( getValue() );
	}

	public cfboom.security.oauth2.common.OAuth2AccessToken function valueOf(required struct tokenParams) {
		var token = new DefaultOAuth2AccessToken(arguments.tokenParams[ACCESS_TOKEN]);

		if (structKeyExists(arguments.tokenParams, EXPIRES_IN)) {
			var expiration = javaCast("long", 0);
			try {
				expiration = createObject("java", "java.lang.Long").parseLong(createObject("java", "java.lang.String").valueOf(arguments.tokenParams[EXPIRES_IN]));
			}
			catch (java.lang.NumberFormatException e) {
				// fall through...
			}
			token.setExpiration(createObject("java", "java.util.Date").init(createObject("java", "java.lang.System").currentTimeMillis() + (expiration * javaCast("long", 1000))));
		}

		if (structKeyExists(arguments.tokenParams, REFRESH_TOKEN)) {
			var refresh = arguments.tokenParams[REFRESH_TOKEN];
			var refreshToken = new DefaultOAuth2RefreshToken(refresh);
			token.setRefreshToken(refreshToken);
		}

		if (structKeyExists(arguments.tokenParams, SCOPE)) {
			var scopeList = "";
			var scopeArray = [];
			if (isJson(arguments.tokenParams[SCOPE])) {
				scopeArray = deserializeJson( arguments.tokenParams[SCOPE] );
			} else {
				scopeArray = listToArray(arguments.tokenParams[SCOPE], ", ");
			}
			for (var ele in scopeArray) {
				scopeList = listAppend(scopeList, trim(ele));
			}
			token.setScope(scopeList);
		}

		if (structKeyExists(arguments.tokenParams, TOKEN_TYPE)) {
			token.setTokenType(arguments.tokenParams[TOKEN_TYPE]);
		}

		return token;
	}

	/**
	 * Additional information that token granters would like to add to the token, e.g. to support new token types.
	 * 
	 * @return the additional information (default empty)
	 */
	public struct function getAdditionalInformation() {
		return _instance.additionalInformation;
	}

	/**
	 * Additional information that token granters would like to add to the token, e.g. to support new token types. If
	 * the values in the map are primitive then remote communication is going to always work. It should also be safe to
	 * use maps (nested if desired), or something that is explicitly serializable by Jackson.
	 * 
	 * @param additionalInformation the additional information to set
	 */
	public void function setAdditionalInformation(struct additionalInformation) {
		if (structKeyExists(arguments, "additionalInformation"))
			_instance['additionalInformation'] = arguments.additionalInformation;
	}
}
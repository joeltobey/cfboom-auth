component
	extends="cfboom.security.oauth2.client.resource.BaseOAuth2ProtectedResourceDetails"
	displayname="Abstract Class AbstractRedirectResourceDetails"
	output="false"
{
	_instance['useCurrentUri'] = true;

	public cfboom.security.oauth2.client.token.grant.redirect.AbstractRedirectResourceDetails function init() {
		return this;
	}

	/**
	 * Flag to signal that the current URI (if set) in the request should be used in preference to the pre-established
	 * redirect URI.
	 * 
	 * @param useCurrentUri the flag value to set (default true)
	 */
	public void function setUseCurrentUri(boolean useCurrentUri = true) {
		_instance['useCurrentUri'] = arguments.useCurrentUri;
	}
	
	/**
	 * Flag to signal that the current URI (if set) in the request should be used in preference to the pre-established
	 * redirect URI.
	 * 
	 * @return the flag value
	 */
	public boolean function isUseCurrentUri() {
		return _instance.useCurrentUri;
	}

	/**
	 * The URI to which the user is to be redirected to authorize an access token.
	 * 
	 * @return The URI to which the user is to be redirected to authorize an access token.
	 */
	public string function getUserAuthorizationUri() {
		if (structKeyExists(_instance, "userAuthorizationUri"))
			return _instance.userAuthorizationUri;
	}

	/**
	 * The URI to which the user is to be redirected to authorize an access token.
	 * 
	 * @param userAuthorizationUri The URI to which the user is to be redirected to authorize an access token.
	 */
	public void function setUserAuthorizationUri(string userAuthorizationUri) {
		if (structKeyExists(arguments, "userAuthorizationUri"))
			_instance['userAuthorizationUri'] = arguments.userAuthorizationUri;
	}

	/**
	 * The redirect URI that has been pre-established with the server. If present, the redirect URI will be omitted from
	 * the user authorization request because the server doesn't need to know it.
	 * 
	 * @return The redirect URI that has been pre-established with the server.
	 */
	public string function getPreEstablishedRedirectUri() {
		if (structKeyExists(_instance, "preEstablishedRedirectUri"))
			return _instance.preEstablishedRedirectUri;
	}

	/**
	 * The redirect URI that has been pre-established with the server. If present, the redirect URI will be omitted from
	 * the user authorization request because the server doesn't need to know it.
	 * 
	 * @param preEstablishedRedirectUri The redirect URI that has been pre-established with the server.
	 */
	public void function setPreEstablishedRedirectUri(string preEstablishedRedirectUri) {
		if (structKeyExists(arguments, "preEstablishedRedirectUri"))
			_instance['preEstablishedRedirectUri'] = arguments.preEstablishedRedirectUri;
	}

	/**
	 * Extract a redirect uri from the resource and/or the current request.
	 * 
	 * @param request the current {@link DefaultAccessTokenRequest}
	 * @return a redirect uri if one can be established
	 */
	public string function getRedirectUri(required cfboom.security.oauth2.client.token.AccessTokenRequest req) {

		var redirectUri = arguments.req.getFirst("redirect_uri");

		if (isNull(redirectUri) && !isNull(arguments.req.getCurrentUri()) && _instance.useCurrentUri) {
			redirectUri = arguments.req.getCurrentUri();
		}

		if (isNull(redirectUri) && !isNull(getPreEstablishedRedirectUri())) {
			// Override the redirect_uri if it is pre-registered
			redirectUri = getPreEstablishedRedirectUri();
		}

		return redirectUri;

	}
}
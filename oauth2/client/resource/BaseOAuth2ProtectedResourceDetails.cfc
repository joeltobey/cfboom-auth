component
	extends="cfboom.lang.Object"
	implements="cfboom.security.oauth2.client.resource.OAuth2ProtectedResourceDetails" 
	displayname="Class BaseOAuth2ProtectedResourceDetails"
	output="false"
{
	variables['OAuth2AccessToken'] = getComponentMetadata("cfboom.security.oauth2.common.OAuth2AccessToken");

	this['equals'] = $equals;

	_instance['grantType'] = "unsupported";

	_instance['clientAuthenticationScheme'] = "header";

	_instance['authorizationScheme'] = "header";

	_instance['tokenName'] = OAuth2AccessToken.ACCESS_TOKEN;

	public cfboom.security.oauth2.client.resource.BaseOAuth2ProtectedResourceDetails function init() {
		return this;
	}

	public string function getId() {
		if (structKeyExists(_instance, "id"))
			return _instance.id;
	}

	public void function setId(string id) {
		if (structKeyExists(arguments, "id"))
			_instance['id'] = arguments.id;
	}

	public string function getClientId() {
		if (structKeyExists(_instance, "clientId"))
			return _instance.clientId;
	}

	public void function setClientId(string clientId) {
		if (structKeyExists(arguments, "clientId"))
			_instance['clientId'] = arguments.clientId;
	}

	public string function getAccessTokenUri() {
		if (structKeyExists(_instance, "accessTokenUri"))
			return _instance.accessTokenUri;
	}

	public void function setAccessTokenUri(string accessTokenUri) {
		if (structKeyExists(arguments, "accessTokenUri"))
			_instance['accessTokenUri'] = arguments.accessTokenUri;
	}

	public boolean function isScoped() {
		return structKeyExists(_instance, "scope") && len(_instance.scope);
	}

	public string function getScope() {
		if (structKeyExists(_instance, "scope"))
			return _instance.scope;
	}

	public void function setScope(string scope) {
		if (structKeyExists(arguments, "scope"))
			_instance['scope'] = arguments.scope;
	}

	public boolean function isAuthenticationRequired() {
		return structKeyExists(_instance, "clientId") && len(_instance.clientId) && clientAuthenticationScheme != "none";
	}

	public string function getClientSecret() {
		if (structKeyExists(_instance, "clientSecret"))
			return _instance.clientSecret;
	}

	public void function setClientSecret(string clientSecret) {
		if (structKeyExists(arguments, "clientSecret"))
			_instance['clientSecret'] = arguments.clientSecret;
	}

	public string function getClientAuthenticationScheme() {
		if (structKeyExists(_instance, "clientAuthenticationScheme"))
			return _instance.clientAuthenticationScheme;
	}

	public void function setClientAuthenticationScheme(string clientAuthenticationScheme) {
		if (structKeyExists(arguments, "clientAuthenticationScheme"))
			_instance['clientAuthenticationScheme'] = arguments.clientAuthenticationScheme;
	}

	public boolean function isClientOnly() {
		return false;
	}

	public string function getAuthenticationScheme() {
		if (structKeyExists(_instance, "authorizationScheme"))
			return _instance.authorizationScheme;
	}

	public void function setAuthenticationScheme(string authorizationScheme) {
		if (structKeyExists(arguments, "authorizationScheme"))
			_instance['authorizationScheme'] = arguments.authorizationScheme;
	}

	public string function getTokenName() {
		if (structKeyExists(_instance, "tokenName"))
			return _instance.tokenName;
	}

	public void function setTokenName(string tokenName) {
		if (structKeyExists(arguments, "tokenName"))
			_instance['tokenName'] = arguments.tokenName;
	}

	public string function getGrantType() {
		if (structKeyExists(_instance, "grantType"))
			return _instance.grantType;
	}

	public void function setGrantType(string grantType) {
		if (structKeyExists(arguments, "grantType"))
			_instance['grantType'] = arguments.grantType;
	}

	private boolean function $equals(any o) {
		if (super.$equals(arguments.o)) {
			return true;
		}
		if (!isInstanceOf(arguments.o, "cfboom.security.oauth2.client.resource.BaseOAuth2ProtectedResourceDetails")) {
			return false;
		}

		var that = arguments.o;
		return !(structKeyExists(_instance, "id") ? !_instance.id.equals(that.getId()) : !isNull(that.getId()));

	}

	public numeric function hashCode() {
		return structKeyExists(_instance, "id") ? _instance.id.hashCode() : javaCast("int", 0);
	}
}
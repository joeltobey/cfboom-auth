component
	extends="cfboom.lang.Object"
	implements="cfboom.security.oauth2.common.OAuth2RefreshToken" 
	displayname="Class DefaultOAuth2RefreshToken"
	output="false"
{
	/**
	 * Create a new refresh token.
	 */
	public cfboom.security.oauth2.common.DefaultOAuth2RefreshToken function init(required string value) {
		_instance['value'] = arguments.value;
		return this;
	}

	public string function getValue() {
		return _instance.value;
	}

	public string function toString() {
		return _instance.value;
	}
}
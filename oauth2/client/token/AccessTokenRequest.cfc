interface
	displayname="Interface AccessTokenRequest"
{
	public cfboom.security.oauth2.common.OAuth2AccessToken function getExistingToken();

	public void function setExistingToken(cfboom.security.oauth2.common.OAuth2AccessToken existingToken);

	public void function setAuthorizationCode(string code);

	public string function getAuthorizationCode();

	public void function setCurrentUri(string uri);

	public string function getCurrentUri();

	public void function setStateKey(string state);

	public string function getStateKey();

	public void function setPreservedState(any state);

	public any function getPreservedState();

	public boolean function isError();

	public void function setCookie(string cookie);

	public string function getCookie();
	
	public void function setHeaders(struct headers);

	public struct function getHeaders();
}
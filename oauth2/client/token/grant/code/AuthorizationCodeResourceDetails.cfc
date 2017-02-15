component
	extends="cfboom.security.oauth2.client.token.grant.redirect.AbstractRedirectResourceDetails"
	displayname="Class AuthorizationCodeResourceDetails"
	output="false"
{
	public cfboom.security.oauth2.client.token.grant.code.AuthorizationCodeResourceDetails function init() {
		setGrantType("authorization_code");
		return this;
	}
}
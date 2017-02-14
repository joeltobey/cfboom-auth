interface
	extends="cfboom.security.oauth2.common.OAuth2RefreshToken" 
	displayname="Interface ExpiringOAuth2RefreshToken"
{
	public date function getExpiration();
}
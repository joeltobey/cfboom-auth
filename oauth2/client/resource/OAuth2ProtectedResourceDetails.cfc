interface
	displayname="Interface OAuth2ProtectedResourceDetails"
{
	/**
	 * Get a unique identifier for these protected resource details.
	 * 
	 * @return A unique identifier for these protected resource details.
	 */
	public string function getId();

	/**
	 * The client identifier to use for this protected resource.
	 * 
	 * @return The client identifier to use for this protected resource.
	 */
	public string function getClientId();

	/**
	 * The URL to use to obtain an OAuth2 access token.
	 * 
	 * @return The URL to use to obtain an OAuth2 access token.
	 */
	public string function getAccessTokenUri();

	/**
	 * Whether this resource is limited to a specific scope. If false, the scope of the authentication request will be
	 * ignored.
	 * 
	 * @return Whether this resource is limited to a specific scope.
	 */
	public boolean function isScoped();

	/**
	 * The scope of this resource. Ignored if the {@link #isScoped() resource isn't scoped}.
	 * 
	 * @return The scope of this resource.
	 */
	public string function getScope();

	/**
	 * Whether a secret is required to obtain an access token to this resource.
	 * 
	 * @return Whether a secret is required to obtain an access token to this resource.
	 */
	public boolean function isAuthenticationRequired();

	/**
	 * The client secret. Ignored if the {@link #isAuthenticationRequired() secret isn't required}.
	 * 
	 * @return The client secret.
	 */
	public string function getClientSecret();

	/**
	 * The scheme to use to authenticate the client. E.g. "header" or "query".
	 * 
	 * @return The scheme used to authenticate the client.
	 */
	public string function getClientAuthenticationScheme();

	/**
	 * The grant type for obtaining an acces token for this resource.
	 * 
	 * @return The grant type for obtaining an acces token for this resource.
	 */
	public string function getGrantType();

	/**
	 * Get the bearer token method for this resource.
	 * 
	 * @return The bearer token method for this resource.
	 */
	public string function getAuthenticationScheme();

	/**
	 * The name of the bearer token. The default is "access_token", which is according to the spec, but some providers
	 * (e.g. Facebook) don't conform to the spec.)
	 * 
	 * @return The name of the bearer token.
	 */
	public string function getTokenName();

	/**
	 * A flag to indicate that this resource is only to be used with client credentials, thus allowing access tokens to
	 * be cached independent of a user's session.
	 * 
	 * @return true if this resource is only used with client credentials grant
	 */
	public boolean function isClientOnly();
}
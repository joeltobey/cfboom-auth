/**
 * An {@link org.springframework.security.core.Authentication} implementation that is designed for use whilst unit testing.
 * <p>
 * The corresponding authentication provider is  {@link TestingAuthenticationProvider}.
 *
 * @author Ben Alex
 */
component
	extends="jetsecurity.authentication.AbstractAuthenticationToken"
	displayname="Class TestingAuthenticationToken"
	output="false"
{
	/**
	 * Constructor.
	 *
	 * @param key to identify if this object made by an authorised client
	 * @param principal the principal (typically a <code>UserDetails</code>)
	 * @param authorities the authorities granted to the principal
	 *
	 * @throws IllegalArgumentException if a <code>null</code> was passed
	 */
	public jetsecurity.authentication.TestingAuthenticationToken function init(any principal, any credentials, array authorities = []) {
		super.init(arguments.authorities);

		_instance['principal'] = arguments.principal;
		if (structKeyExists(arguments, "credentials"))
			_instance['credentials'] = arguments.credentials;
		setAuthenticated(true);
		return this;
	}

	public any function getCredentials() {
		if (structKeyExists(_instance, "credentials"))
			return _instance.credentials;
	}

	public any function getPrincipal() {
		if (structKeyExists(_instance, "credentials"))
			return _instance.credentials;
	}
}
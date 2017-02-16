/**
 * An {@link AuthenticationProvider} implementation that validates {@link RememberMeAuthenticationToken}s.
 * <p>
 * To be successfully validated, the {@link RememberMeAuthenticationToken#getKeyHash()} must match this class'
 * {@link #getKey()}.
 */
component
	implements="jetsecurity.authentication.AuthenticationProvider"
	displayname="Class TestingAuthenticationProvider"
	output="false"
{
	public jetsecurity.authentication.TestingAuthenticationProvider function init() {
		return this;
	}

	public any function authenticate(jetsecurity.core.Authentication authentication) {
		return arguments.authentication;
	}

	public boolean function supports(any authentication) {
		return isInstanceOf(arguments.authentication, "jetsecurity.authentication.TestingAuthenticationToken");
	}
}
/**
 * An {@link AuthenticationProvider} implementation that validates {@link RememberMeAuthenticationToken}s.
 * <p>
 * To be successfully validated, the {@link RememberMeAuthenticationToken#getKeyHash()} must match this class'
 * {@link #getKey()}.
 */
component
	implements="jetsecurity.authentication.AuthenticationProvider"
	displayname="Class RememberMeAuthenticationProvider"
	output="false"
{
	variables['_instance'] = {};

	public jetsecurity.authentication.RememberMeAuthenticationProvider function init(string key) {
		if (!structKeyExists(arguments, "key") || !len( trim(arguments.key) ))
			throw(object=createObject("java", "java.lang.IllegalArgumentException").init("A Key is required"));
		_instance['key'] = arguments.key;
		return this;
	}

	public any function authenticate(jetsecurity.core.Authentication authentication) {
		if (!supports(arguments.authentication))
			return;

		if (_instance.key.hashCode() != arguments.authentication.getKeyHash()) {
			throw(type="Authentication.BadCredentials", message="The presented RememberMeAuthenticationToken does not contain the expected key");
		}

		return arguments.authentication;
	}

	public string function getKey() {
		return _instance.key;
	}

	public boolean function supports(any authentication) {
		return isInstanceOf(arguments.authentication, "jetsecurity.authentication.RememberMeAuthenticationToken");
	}
}
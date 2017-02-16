/**
 * An {@link org.springframework.security.core.Authentication} implementation that is designed for simple presentation
 * of a username and password.
 * <p>
 * The <code>principal</code> and <code>credentials</code> should be set with an <code>Object</code> that provides
 * the respective property via its <code>Object.toString()</code> method. The simplest such <code>Object</code> to use
 * is <code>String</code>.
 *
 * @author Ben Alex
 * @author Joel Tobey
 */
component
	extends="jetsecurity.authentication.AbstractAuthenticationToken"
	displayname="Class UsernamePasswordAuthenticationToken"
	output="false"
{
	this['equals'] = $equals;

	/**
	 * This constructor should only be used by <code>AuthenticationManager</code> or <code>AuthenticationProvider</code>
	 * implementations that are satisfied with producing a trusted (i.e. {@link #isAuthenticated()} = <code>true</code>)
	 * authentication token.
	 *
	 * @param principal
	 * @param credentials
	 * @param authorities
	 */
	public jetsecurity.authentication.UsernamePasswordAuthenticationToken function init(any principal, any credentials, array authorities = []) {
		super.init(arguments.authorities);
		_instance['principal'] = arguments.principal;
		_instance['credentials'] = arguments.credentials;
		super.setAuthenticated(true); // must use super, as we override
	}

	public any function getCredentials() {
		if (structKeyExists(_instance, "credentials"))
			return _instance.credentials;
	}

	public any function getPrincipal() {
		return _instance.principal;
	}

	public void function setAuthenticated(boolean isAuthenticated) {
		if (arguments.isAuthenticated) {
			throw(object=createObject("java", "java.lang.IllegalArgumentException").init("Cannot set this token to trusted - use constructor which takes a GrantedAuthority list instead"));
		}

		super.setAuthenticated(false);
	}

	public void function eraseCredentials() {
		super.eraseCredentials();
		structDelete(_instance, "credentials");
	}
}
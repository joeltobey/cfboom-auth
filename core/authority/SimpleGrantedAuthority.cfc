/**
 * Basic concrete implementation of a {@link GrantedAuthority}.
 *
 * <p>
 * Stores a {@code String} representation of an authority granted to the
 * {@link org.springframework.security.core.Authentication Authentication} object.
 *
 * @author Luke Taylor
 * @author Joel Tobey
 */
component
	implements="jetsecurity.core.GrantedAuthority"
	displayname="Class SimpleGrantedAuthority"
	output="false"
{
	this['equals'] = $equals;

	public jetsecurity.core.authority.SimpleGrantedAuthority function init(required string role) {
		if ( !len( trim(arguments.role) ) )
			throw(object=createObject("java", "java.lang.IllegalArgumentException")
				.init("A granted authority textual representation is required"));
		variables['_role'] = arguments.role;
		return this;
	}

	public string function getAuthority() {
		return _role;
	}

	private boolean function $equals(any other) {
		if (!structKeyExists(arguments, "other"))
			return false;
		if (isInstanceOf(arguments.other, "jetsecurity.core.authority.SimpleGrantedAuthority"))
			return _role.equals(arguments.other.getAuthority());
		return false;
	}

	public numeric function hashCode() {
		return _role.hashCode();
	}

	public string function toString() {
		return _role;
	}
}
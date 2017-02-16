/**
 * Represents a remembered <code>Authentication</code>.
 * <p>
 * A remembered <code>Authentication</code> must provide a fully valid <code>Authentication</code>, including the
 * <code>GrantedAuthority</code>s that apply.
 *
 * @author Ben Alex
 * @author Luke Taylor
 * @author Joel Tobey
 */
component
	extends="jetsecurity.authentication.AbstractAuthenticationToken"
	displayname="Class RememberMeAuthenticationToken"
	output="false"
{
	this['equals'] = $equals;

	/**
	 * Constructor.
	 *
	 * @param key to identify if this object made by an authorised client
	 * @param principal the principal (typically a <code>UserDetails</code>)
	 * @param authorities the authorities granted to the principal
	 *
	 * @throws IllegalArgumentException if a <code>null</code> was passed
	 */
	public jetsecurity.authentication.RememberMeAuthenticationToken function init(string key, any principal, array authorities = []) {
		super.init(arguments.authorities);

		if (!structKeyExists(arguments, "key") || !len(arguments.key)
			|| !structKeyExists(arguments, "principal") || !len(arguments.principal)
			|| (arrayIsEmpty(arguments.authorities))) {
				throw(object=createObject("java", "java.lang.IllegalArgumentException").init("Cannot pass null or empty values to constructor"));
		}

        _instance['keyHash'] = arguments.key.hashCode();
        _instance['principal'] = arguments.principal;
        setAuthenticated(true);
	}

	/**
	 * Always returns an empty <code>String</code>
	 *
	 * @return an empty String
	 */
	public any function getCredentials() {
		return "";
	}

	public numeric function getKeyHash() {
		return _instance.keyHash;
	}

	public any function getPrincipal() {
		return _instance.principal;
	}

	private boolean function $equals(any other) {
		if (!structKeyExists(arguments, "other"))
			return false;
		if (!super.$equals(arguments.other))
			return false;

		if (isInstanceOf(arguments.other, "jetsecurity.authentication.RememberMeAuthenticationToken")) {

			if (getKeyHash() != arguments.other.getKeyHash()) {
				return false;
			}

			return true;
		}

		return false;
	}
}
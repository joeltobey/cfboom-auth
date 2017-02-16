/**
 * Base class for <code>Authentication</code> objects.
 * <p>
 * Implementations which use this class should be immutable.
 *
 * @author Ben Alex
 * @author Luke Taylor
 * @author Joel Tobey
 */
component implements="jetsecurity.core.Authentication, jetsecurity.core.CredentialsContainer"
	displayname="Abstract Class AbstractAuthenticationToken"
	output="false"
{
	this['equals'] = $equals;

	variables['_instance'] = {};
	_instance['authenticated'] = false;

	/**
     * Creates a token with the supplied array of authorities.
     *
     * @param authorities the collection of <tt>GrantedAuthority</tt>s for the
     *                    principal represented by this authentication object.
     */
	public jetsecurity.authentication.AbstractAuthenticationToken function init(array authorities = []) {
		for (var i = 1; i <= arrayLen(arguments.authorities); i++) {
			if (!arrayIsDefined(arguments.authorities, i) || isNull(arguments.authorities[i]))
				throw(object=createObject("java", "java.lang.IllegalArgumentException").init("Authorities collection cannot contain any null elements"));
		}
		_instance['authorities'] = arguments.authorities;
		return this;
	}

	public array function getAuthorities() {
		return _instance.authorities;
	}

	public string function getName() {
		if (!isNull(getPrincipal()) && isInstanceOf(getPrincipal(), "jetsecurity.core.userdetails.UserDetails")) {
			return getPrincipal().getUsername();
		}

		if (!isNull(getPrincipal()) && isInstanceOf(getPrincipal(), "java.security.Principal")) {
			return getPrincipal().getName();
		}

		return isNull(getPrincipal()) ? "" : getPrincipal().toString();
	}

	public boolean function isAuthenticated() {
		return _instance.authenticated;
	}

	public void function setAuthenticated(boolean isAuthenticated) {
		_instance['authenticated'] = isAuthenticated;
	}

	public any function getDetails() {
		if (structKeyExists(_instance, "details"))
			return _instance.details;
	}

	public void function setDetails(any details) {
		if (structKeyExists(arguments, "details"))
			_instance['details'] = arguments.details;
	}

	/**
	 * Checks the {@code credentials}, {@code principal} and {@code details} objects, invoking the
	 * {@code eraseCredentials} method on any which implement {@link CredentialsContainer}.
	 */
	public void function eraseCredentials() {
		eraseSecret(getCredentials());
		eraseSecret(getPrincipal());
		eraseSecret(getDetails());
	}

	private void function eraseSecret(any secret) {
		if (structKeyExists(arguments, "secret") && isInstanceOf(arguments.secret, "jetsecurity.core.CredentialsContainer"))
			arguments.secret.eraseCredentials();
	}

	public any function getPrincipal() {
		throw(object=createObject("java", "java.lang.AbstractMethodError").init("Subcass must implement 'getPrincipal()'"));
	}

	public any function getCredentials() {
		throw(object=createObject("java", "java.lang.AbstractMethodError").init("Subcass must implement 'getCredentials()'"));
	}

	private boolean function $equals(any other) {
		if (!structKeyExists(arguments, "other"))
			return false;
		if (!isInstanceOf(arguments.other, "jetsecurity.authentication.AbstractAuthenticationToken"))
			return false;

		if (!authorities.equals(arguments.other.authorities))
			return false;

		if (!structKeyExists(_instance, "details") && !isNull(arguments.other.getDetails()))
			return false;

		if (structKeyExists(_instance, "details") && isNull(arguments.other.getDetails()))
			return false;

		if (structKeyExists(_instance, "details") && !_instance.details.equals(arguments.other.getDetails()))
			return false;

		if (isNull(getCredentials()) && !isNull(arguments.other.getCredentials()))
			return false;

		if (!isNull(getCredentials()) && isNull(arguments.other.getCredentials()))
			return false;

		if (!isNull(getCredentials())) {
			var credentials = getCredentials();
			if (!credentials.equals(arguments.other.getCredentials()))
				return false;
		}

		if (isNull(getPrincipal()) && !isNull(arguments.other.getPrincipal()))
			return false;

		if (!isNull(getPrincipal()) && isNull(arguments.other.getPrincipal()))
			return false;

		if (!isNull(getPrincipal())) {
			var principal = getPrincipal();
			if (!principal.equals(arguments.other.getPrincipal()))
				return false;
		}

		return isAuthenticated() == arguments.other.isAuthenticated();
	}

	public numeric function hashCode() {
		var code = javaCast("int", 31);

		for ( var authority in _instance.authorities ) {
			code = bitXor(code, authority.hashCode());
		}

		if ( !isNull(getPrincipal()) ) {
			code = bitXor(code, getPrincipal().hashCode());
		}

		if ( !isNull(getCredentials()) ) {
			code = bitXor(code, getCredentials().hashCode());
		}

		if ( !isNull(getDetails()) ) {
			code = bitXor(code, getDetails().hashCode());
		}

		if (isAuthenticated()) {
			code = bitXor(code, javaCast("int", -37));
		}

		return code;
	}

	public string function toString() {
		var Integer = createObject('java','java.lang.Integer');
		var System = createObject('java','java.lang.System');
		var sb = createObject("java", "java.lang.StringBuilder").init();
		var meta = getMetadata();
		if (structKeyExists(meta, "fullname")) {
			sb.append(meta.fullname);
		} else {
			sb.append(meta.name);
		}
		sb.append("@");
		sb.append(Integer.toHexString(System.identityHashCode(this))).append(": ");
		sb.append("Principal: ").append(getPrincipal().toString()).append("; ");
		sb.append("Credentials: [PROTECTED]; ");
		sb.append("Authenticated: ").append(isAuthenticated()).append("; ");
		sb.append("Details: ").append(getDetails().toString()).append("; ");

		if (!arrayIsEmpty(_instance.authorities)) {
			sb.append("Granted Authorities: ");

			var i = 0;
			for ( var authority in _instance.authorities ) {
				if (i++ > 0) {
					sb.append(", ");
				}

				sb.append(authority.toString());
			}
		} else {
			sb.append("Not granted any authorities");
		}

		return sb.toString();
	}
}
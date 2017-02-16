/**
 * Models core user information retrieved by a {@link UserDetailsService}.
 * <p>
 * Developers may use this class directly, subclass it, or write their own {@link UserDetails} implementation from
 * scratch.
 * <p>
 * {@code equals} and {@code hashcode} implementations are based on the {@code username} property only, as the
 * intention is that lookups of the same user principal object (in a user registry, for example) will match
 * where the objects represent the same user, not just when all the properties (authorities, password for
 * example) are the same.
 * <p>
 * Note that this implementation is not immutable. It implements the {@code CredentialsContainer} interface, in order
 * to allow the password to be erased after authentication. This may cause side-effects if you are storing instances
 * in-memory and reusing them. If so, make sure you return a copy from your {@code UserDetailsService} each time it is
 * invoked.
 *
 * @author Ben Alex
 * @author Luke Taylor
 * @author Joel Tobey
 */
component
	implements="jetsecurity.core.userdetails.UserDetails, jetsecurity.core.CredentialsContainer"
	displayname="Class User"
	output="false"
{
	this['equals'] = $equals;

	variables['_instance'] = {};

    /**
     * Construct the <code>User</code> with the details required by
     * {@link org.springframework.security.authentication.dao.DaoAuthenticationProvider}.
     *
     * @param username the username presented to the
     *        <code>DaoAuthenticationProvider</code>
     * @param password the password that should be presented to the
     *        <code>DaoAuthenticationProvider</code>
     * @param enabled set to <code>true</code> if the user is enabled
     * @param accountNonExpired set to <code>true</code> if the account has not
     *        expired
     * @param credentialsNonExpired set to <code>true</code> if the credentials
     *        have not expired
     * @param accountNonLocked set to <code>true</code> if the account is not
     *        locked
     * @param authorities the authorities that should be granted to the caller
     *        if they presented the correct username and password and the user
     *        is enabled. Not null.
     *
     * @throws IllegalArgumentException if a <code>null</code> value was passed
     *         either as a parameter or as an element in the
     *         <code>GrantedAuthority</code> collection
     */
    public jetsecurity.core.userdetails.User function init(string username, string password, boolean enabled = true, boolean accountNonExpired = true,
            boolean credentialsNonExpired = true, boolean accountNonLocked = true, array authorities = []) {

		if ( !structKeyExists(arguments, "username") || !len( trim( arguments.username ) ) || !structKeyExists(arguments, "password") )
			throw(object=createObject("java", "java.lang.IllegalArgumentException").init("Cannot pass null or empty values to constructor"));

		_instance['username'] = arguments.username;
		_instance['password'] = arguments.password;
		_instance['enabled'] = arguments.enabled;
		_instance['accountNonExpired'] = arguments.accountNonExpired;
		_instance['credentialsNonExpired'] = arguments.credentialsNonExpired;
		_instance['accountNonLocked'] = arguments.accountNonLocked;
		_instance['authorities'] = sortAuthorities(arguments.authorities);

		return this;
	}

	public array function getAuthorities() {
		return _instance.authorities;
	}

	public string function getPassword() {
		if (structKeyExists(_instance, "password"))
			return _instance.password;
	}

	public string function getUsername() {
		return _instance.username;
	}

	public boolean function isEnabled() {
		return _instance.enabled;
	}

	public boolean function isAccountNonExpired() {
		return _instance.accountNonExpired;
	}

	public boolean function isAccountNonLocked() {
		return _instance.accountNonLocked;
	}

	public boolean function isCredentialsNonExpired() {
		return _instance.credentialsNonExpired;
	}

	public void function eraseCredentials() {
		structDelete(_instance, "password");
	}

	private array function sortAuthorities(required array authorities) {
		for (var i = 1; i <= arrayLen(arguments.authorities); i++) {
			if (!arrayIsDefined(arguments.authorities, i) || isNull(arguments.authorities[i]))
				throw(object=createObject("java", "java.lang.IllegalArgumentException").init("GrantedAuthority list cannot contain any null elements"));
		}
		// Ensure array iteration order is predictable (as per UserDetails.getAuthorities() contract and SEC-717)
		var arrayIsSorted = arraySort(
			arguments.authorities,
			function (jetsecurity.core.GrantedAuthority g1, jetsecurity.core.GrantedAuthority g2) {
				// Neither should ever be null as each entry is checked before adding it to the set.
				// If the authority is null, it is a custom authority and should precede others.
				if (isNull(arguments.g2.getAuthority())) {
					return javaCast("int", -1);
				}
		
				if (isNull(arguments.g1.getAuthority())) {
					return javaCast("int", 1);
				}
		
				return arguments.g1.getAuthority().compareTo(arguments.g2.getAuthority());
			}
		);

		if ( !arrayIsSorted )
			throw(object=creatObject("java", "java.lang.IllegalStateException").init("arraySort() failed to sort GrantedAuthority list"));

		return arguments.authorities;
	}

	/**
	 * Returns {@code true} if the supplied object is a {@code User} instance with the
	 * same {@code username} value.
	 * <p>
	 * In other words, the objects are equal if they have the same username, representing the
	 * same principal.
	 */
	private boolean function $equals(any other) {
		if (!structKeyExists(arguments, "other") || !isInstanceOf(arguments.other, "jetsecurity.core.userdetails.User"))
			return false;
		return _instance.username.equals(arguments.other.getUsername());
	}

	/**
	 * Returns the hashcode of the {@code username}.
	 */
	public numeric function hashCode() {
		return _instance.username.hashCode();
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
		sb.append("Username: ").append(_instance.username).append("; ");
		sb.append("Password: [PROTECTED]; ");
		sb.append("Enabled: ").append(_instance.enabled).append("; ");
		sb.append("AccountNonExpired: ").append(_instance.accountNonExpired).append("; ");
		sb.append("credentialsNonExpired: ").append(_instance.credentialsNonExpired).append("; ");
		sb.append("AccountNonLocked: ").append(_instance.accountNonLocked).append("; ");

		if (!arrayIsEmpty(_instance.authorities)) {
			sb.append("Granted Authorities: ");

			var first = true;
			for (var auth in _instance.authorities) {
				if (!first) {
					sb.append(",");
				}
				first = false;

				sb.append(auth);
			}
		} else {
			sb.append("Not granted any authorities");
		}

		return sb.toString();
    }
}
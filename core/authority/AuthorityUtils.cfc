/**
 * Utility method for manipulating <tt>GrantedAuthority</tt> collections etc.
 * <p>
 * Mainly intended for internal use.
 *
 * @author Luke Taylor
 */
component
	displayname="Abstract Class AuthorityUtils"
	output="false"
{
	import jetsecurity.core.authority.SimpleGrantedAuthority;

	public jetsecurity.core.authority.AuthorityUtils function init() {
		return this;
	}

	/**
	 * Creates a array of GrantedAuthority objects from a comma-separated string
	 * representation (e.g. "ROLE_A, ROLE_B, ROLE_C").
	 *
	 * @param authorityString the comma-separated string
	 * @return the authorities created by tokenizing the string
	 */
	public array function commaSeparatedStringToAuthorityList(string authorityString) {
		return createAuthorityList( listToArray(arguments.authorityString) );
	}

	/**
	 * Converts an array of GrantedAuthority objects to a Set.
	 * @return a Set of the Strings obtained from each call to GrantedAuthority.getAuthority()
	 */
	public string function authorityListToSet(array userAuthorities) {
		var set = "";

		for (var authority in arguments.userAuthorities) {
			set = listAppend(set, authority.getAuthority());
		}

		return set;
	}

	public array function createAuthorityList(required any roles) {
		if (!isArray(arguments.roles))
			arguments.roles = [arguments.roles];

		var authorities = [];

		for (var role in arguments.roles) {
			arrayAppend(authorities, new SimpleGrantedAuthority(role));
		}

		return authorities;
	}
}
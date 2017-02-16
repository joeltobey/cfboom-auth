/**
 * Custom {@code GrantedAuthority} used by
 * {@link org.springframework.security.web.authentication.switchuser.SwitchUserFilter}
 * <p>
 * Stores the {@code Authentication} object of the original user to be used later when 'exiting' from a user switch.
 *
 * @author Mark St.Godard
 *
 * @see org.springframework.security.web.authentication.switchuser.SwitchUserFilter
 */
component
	implements="jetsecurity.core.GrantedAuthority"
	displayname="Class SwitchUserGrantedAuthority"
	output="false"
{
	public jetsecurity.web.authentication.switchuserSwitchUserGrantedAuthority function init(required string role, required jetsecurity.core.Authentication source) {
		variables['_role'] = arguments.role;
		variables['_source'] = arguments.source;
		return this;
	}

	/**
	 * Returns the original user associated with a successful user switch.
	 *
	 * @return The original <code>Authentication</code> object of the switched user.
	 */
	public jetsecurity.core.Authentication function getSource() {
		return _source;
	}

	public string function getAuthority() {
		return _role;
	}
}
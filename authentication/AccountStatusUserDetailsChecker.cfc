/**
 * @author Luke Taylor
 */
component implements="jetsecurity.core.userdetails.UserDetailsChecker" 
	displayname="Class AccountStatusUserDetailsChecker"
	output="false"
{
	public void function check(jetsecurity.core.userdetails.UserDetails toCheck) {
		var user = arguments.toCheck;
		if (!user.isAccountNonLocked()) {
			throw(type="Authentication.AccountStatus.Locked", message="User account is locked");
		}

		if (!user.isEnabled()) {
			throw(type="Authentication.AccountStatus.Disabled", message="User is disabled");
		}

		if (!user.isAccountNonExpired()) {
			throw(type="Authentication.AccountStatus.AccountExpired", message="User account has expired");
		}

		if (!user.isCredentialsNonExpired()) {
			throw(type="Authentication.AccountStatus.CredentialsExpired", message="User credentials have expired");
		}
	}
}
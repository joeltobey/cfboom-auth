/**
 * Basic implementation of {@link AuthenticationTrustResolver}.
 * <p>
 * Makes trust decisions based on whether the passed <code>Authentication</code> is an instance of a defined class.
 * <p>
 * If {@link #anonymousClass} or {@link #rememberMeClass} is <code>null</code>, the corresponding method will
 * always return <code>false</code>.
 *
 * @author Ben Alex
 * @author Joel Tobey
 */
component
	implements="jetsecurity.authentication.AuthenticationTrustResolver"
	displayname="Class AuthenticationTrustResolverImpl"
	output="false"
{
	variables['_instance'] = {};

	_instance['anonymousClass'] = "jetsecurity.authentication.AnonymousAuthenticationToken";
	_instance['rememberMeClass'] = "jetsecurity.authentication.RememberMeAuthenticationToken";

	public jetsecurity.authentication.AuthenticationTrustResolverImpl function init() {
		return this;
	}

	public string function getAnonymousClass() {
		if (structKeyExists(_instance, "anonymousClass"))
			return _instance.anonymousClass;
	}

	public string function getRememberMeClass() {
		if (structKeyExists(_instance, "rememberMeClass"))
			return _instance.rememberMeClass;
	}

	public boolean function isAnonymous(jetsecurity.core.Authentication authentication) {
		if (!structKeyExists(_instance, "anonymousClass") || !structKeyExists(arguments, "authentication")) {
			return false;
		}

		return isInstanceOf(arguments.authentication, _instance.anonymousClass);
	}

	public boolean function isRememberMe(jetsecurity.core.Authentication authentication) {
		if (!structKeyExists(_instance, "rememberMeClass") || !structKeyExists(arguments, "authentication")) {
			return false;
		}

		return isInstanceOf(arguments.authentication, _instance.rememberMeClass);
	}

	public void function setAnonymousClass(string anonymousClass) {
		if (structKeyExists(arguments, "anonymousClass")) {
			_instance['anonymousClass'] = arguments.anonymousClass;
		} else {
			structDelete(_instance, "anonymousClass");
		}
	}

	public void function setRememberMeClass(string rememberMeClass) {
		if (structKeyExists(arguments, "rememberMeClass")) {
			_instance['rememberMeClass'] = arguments.rememberMeClass;
		} else {
			structDelete(_instance, "rememberMeClass");
		}
	}
}
/**
 * Base implementation of {@link SecurityContext}.
 * <p>
 * Used by default by {@link SecurityContextHolder} strategies.
 *
 * @author Ben Alex
 * @author Joel Tobey
 */
component
	implements="jetsecurity.core.context.SecurityContext" 
	displayname="Class SecurityContextImpl"
	output="false"
{
	this['equals'] = $equals;
	variables['_instance'] = {};

	public jetsecurity.core.context.SecurityContextImpl function init() {
		return this;
	}

	public any function getAuthentication() {
		if (structKeyExists(_instance, "authentication"))
			return _instance.authentication;
	}
  
	public void function setAuthentication(jetsecurity.core.Authentication authentication) {
		_instance['authentication'] = arguments.authentication;
	}

	private boolean function $equals(any other) {
		if (!structKeyExists(arguments, "other"))
			return false;
		if (isInstanceOf(arguments.other, "jetsecurity.core.context.SecurityContextImpl")) {

			if (!structKeyExists(_instance, "authentication") && isNull(arguments.other.getAuthentication()))
				return true;

			if (structKeyExists(_instance, "authentication") && !isNull(arguments.other.getAuthentication())
				&& _instance.authentication.equals(arguments.other.getAuthentication()))
				return true;
		}
		return false;
	}

	public numeric function hashCode() {
		if (!structKeyExists(_instance, "authentication")) {
			return javaCast("int", -1);
		} else {
			return _instance.authentication.hashCode();
		}
	}

	public string function toString() {
		var Integer = createObject('java','java.lang.Integer');
		var System = createObject('java','java.lang.System');
		var sb = createObject("java", "java.lang.StringBuilder").init();
		sb.append("jetsecurity.core.context.SecurityContextImpl@");
		sb.append(Integer.toHexString(System.identityHashCode(this))).append(": ");

		if (!structKeyExists(_instance, "authentication")) {
			sb.append("Null authentication");
		} else {
			sb.append("Authentication: ").append(_instance.authentication.toString());
		}

		return sb.toString();
	}
}
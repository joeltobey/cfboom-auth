/**
 * An authority that contains at least a DN and a role name for an LDAP entry but can also contain other desired
 * attributes to be fetched during an LDAP authority search.
 *
 * @author Filip Hanik
 */
component
	implements="jetsecurity.core.GrantedAuthority"
	displayname="Class LdapAuthority"
	output="false"
{
	/**
	 * Constructs an LdapAuthority with the given role, DN and other LDAP attributes
	 *
	 * @param role
	 * @param dn
	 * @param attributes
	 */
	public jetsecurity.ldap.userdetails.LdapAuthority function init(required string role, required string dn, struct attributes = {}) {
		variables['_role'] = arguments.role;
		variables['_dn'] = arguments.dn;
		variables['_attributes'] = arguments.attributes;
		return this;
	}

	/**
	 * Returns the LDAP attributes
	 *
	 * @return the LDAP attributes, map can be null
	 */
	public struct function getAttributes() {
		return _attributes;
	}

	/**
	 * Returns the DN for this LDAP authority
	 *
	 * @return
	 */
	public string function getDn() {
		return _dn;
	}

	/**
	 * Returns the values for a specific attribute
	 *
	 * @param name the attribute name
	 * @return a String array, never null but may be zero length
	 */
	public string function getAttributeValues(required string name) {
		var result = "";
		if (structKeyExists(_attributes, arguments.name)) {
			result = _attributes[arguments.name];
		}
		return result;
	}

	/**
	 * Returns the first attribute value for a specified attribute
	 *
	 * @param name
	 * @return the first attribute value for a specified attribute, may be null
	 */
	public string function getFirstAttributeValue(required string name) {
		var result = getAttributeValues(arguments.name);
		if (!len(result)) {
			return;
		} else {
			return listFirst(result);
		}
	}

	/**
	 * {@inheritDoc}
	 */
	public string function getAuthority() {
		return _role;
	}
}
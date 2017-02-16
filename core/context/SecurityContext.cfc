/**
 * Interface defining the minimum security information associated with the
 * current thread of execution.
 *
 * <p>
 * The security context is stored in a {@link SecurityContextHolder}.
 * </p>
 *
 * @author Ben Alex
 * @author Joel Tobey
 */
interface
	displayname="Interface SecurityContext"
{
	/**
	 * Obtains the currently authenticated principal, or an authentication request token.
	 *
	 * @return the <code>Authentication</code> or <code>null</code> if no authentication information is available
	 */
	public any function getAuthentication();

	/**
	 * Changes the currently authenticated principal, or removes the authentication information.
	 *
	 * @param authentication the new <code>Authentication</code> token, or <code>null</code> if no further
	 *        authentication information should be stored
	 */
	public void function setAuthentication(jetsecurity.core.Authentication authentication);
}
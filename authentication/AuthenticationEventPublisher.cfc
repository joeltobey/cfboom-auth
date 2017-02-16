/**
 * @author Luke Taylor
 * @since 3.0
 * @author Joel Tobey
 */
interface
	displayname="Interface AuthenticationEventPublisher"
{
	public void function publishAuthenticationSuccess(jetsecurity.core.Authentication authentication);

	public void function publishAuthenticationFailure(any exception, jetsecurity.core.Authentication authentication);
}
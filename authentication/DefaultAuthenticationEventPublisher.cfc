/**
 * The default strategy for publishing authentication events.
 * <p>
 * Maps well-known <tt>AuthenticationException</tt> types to events and publishes them via the
 * application context. If configured as a bean, it will pick up the <tt>ApplicationEventPublisher</tt> automatically.
 * Otherwise, the constructor which takes the publisher as an argument should be used.
 * <p>
 * The exception-mapping system can be fine-tuned by setting the <tt>additionalExceptionMappings</tt> as a
 * <code>java.util.Properties</code> object. In the properties object, each of the keys represent the fully qualified
 * classname of the exception, and each of the values represent the name of an event class which subclasses
 * {@link org.springframework.security.authentication.event.AbstractAuthenticationFailureEvent}
 * and provides its constructor. The <tt>additionalExceptionMappings</tt> will be merged with the default ones.
 *
 * @author Luke Taylor
 * @since 3.0
 * @author Joel Tobey
 */
component
	implements="jetsecurity.authentication.AuthenticationEventPublisher"
	displayname="Class DefaultAuthenticationEventPublisher"
	output="false"
{
	variables['_instance'] = {};
	_instance['exceptionMappings'] = {};

	/**
	 * Constructor
	 *
	 * @controller.inject coldbox
	 */
	public jetsecurity.authentication.DefaultAuthenticationEventPublisher function init(required coldbox.system.web.Controller controller) {
		var oConfig = arguments.controller.getSetting( "ColdBoxConfig" );
		var configStruct = arguments.controller.getConfigSettings();
		var jetConfig = configStruct.jetsecurity;
		if (jetConfig.publishAuthenticationEvents) {
			_instance['applicationEventPublisher'] = arguments.controller.getInterceptorService();
		}
		variables['logger'] = arguments.controller.getLogBox().getLogger(this);

		addMapping("Authentication.BadCredentials", "onAuthenticationFailureBadCredentialsEvent");
		addMapping("Authentication.UsernameNotFound", "onAuthenticationFailureBadCredentialsEvent");
		addMapping("Authentication.AccountStatus.AccountExpired", "onAuthenticationFailureExpiredEvent");
		addMapping("Authentication.ProviderNotFound", "onAuthenticationFailureProviderNotFoundEvent");
		addMapping("Authentication.AccountStatus.Disabled", "onAuthenticationFailureDisabledEvent");
		addMapping("Authentication.AccountStatus.Locked", "onAuthenticationFailureLockedEvent");
		addMapping("Authentication.Service", "onAuthenticationFailureServiceExceptionEvent");
		addMapping("Authentication.AccountStatus.CredentialsExpired", "onAuthenticationFailureCredentialsExpiredEvent");

		return this;
	}

	public void function publishAuthenticationSuccess(jetsecurity.core.Authentication authentication) {
		if (structKeyExists(_instance, "applicationEventPublisher"))
			_instance.applicationEventPublisher.processState("onAuthenticationSuccessEvent", arguments.authentication);
	}

	public void function publishAuthenticationFailure(any exception, jetsecurity.core.Authentication authentication) {
		if (structKeyExists(_instance, "applicationEventPublisher")) {
			if (structKeyExists(_instance.exceptionMappings, arguments.exception.type)) {
				_instance.applicationEventPublisher.processState(_instance.exceptionMappings[arguments.exception.type], arguments);
			} else {
				if (logger.canDebug()) {
					logger.debug("No event was found for the exception " & arguments.exception.type, arguments.exception);
				}
			}
		}
	}

	public void function setApplicationEventPublisher(any applicationEventPublisher) {
		if (structKeyExists(arguments, "applicationEventPublisher")) {
			_instance['applicationEventPublisher'] = arguments.applicationEventPublisher;
		} else {
			structDelete(_instance, "applicationEventPublisher");
		}
	}

	/**
	 * Sets additional exception to event mappings. These are automatically merged with the default
	 * exception to event mappings that <code>ProviderManager</code> defines.
	 *
	 * @param additionalExceptionMappings where keys are the type of the exception and the
	 * values are the name of the event to fire.
	 */
	public void function setAdditionalExceptionMappings(struct additionalExceptionMappings = {}) {
		structAppend(_instance.exceptionMappings, arguments.additionalExceptionMappings);
	}

	private void function addMapping(required string exceptionType, required string eventName) {
		_instance.exceptionMappings[arguments.exceptionType] = arguments.eventName;
	}
}
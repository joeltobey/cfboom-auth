/**
 * Created by joeltobey on 4/14/17.
 */
component singleton
  extends="coldbox.system.Interceptor"
  displayname="Security Interceptor"
  output="false"
{
  variables['_instance'] = {};

  public void function configure() {
    // configure the interceptor
    _instance['initialized'] = false;

    // Create the internal properties now
    setProperty( 'rules', [] );
    setProperty( 'rulesLoaded', false );
  }

  private void function loadRules() {
    /*lock name="security.loadrules.#controller.getAppHash()#" type="exclusive" timeout="30" throwontimeout="true" {
      var oModel = getModel( getproperty('rulesModel') );

      if (propertyExists('rulesModelArgs') && len(getProperty('rulesModelArgs'))) {
        var qRules = evaluate("oModel.#getproperty('rulesModelMethod')#( #getProperty('rulesModelArgs')# )");
      } else {
        var qRules = evaluate("oModel.#getproperty('rulesModelMethod')#");
      }

      validateRulesQuery(qRules);
      setProperty('rules', queryToArray(qRules));
      setProperty('rulesLoaded', true);
    }*/
  }

  private void function validateRulesQuery() {

  }

  public void function afterConfigurationLoad( event, interceptData, buffer, rc, prc ) {
    loadRules();

    if ( propertyExists('validatorModel') ) {
      try {
        var validator = getInstance( getProperty( 'validatorModel' ) );
        registerValidator( validator );
      } catch(any ex){
        if ( ex.type == "Security.validatorException" )
          rethrow;
        throw("Error creating validatorModel: #getProperty('validatorModel')#", ex.message & ex.detail & ex.tagContext.toString(), "interceptors.Security.validatorCreationException");
      }
    }

    _instance['initialized'] = true;
  }

  public void function preProcess( event, interceptData, buffer, rc, prc ) {

    if (!_instance.initialized)
      afterConfigurationLoad( argumentCollection:arguments );

    // TODO: Create processRules() here that can do majority of security via rules
    // rather than relying on application model to manage everything.
    _instance.validator.processRules( argumentCollection:arguments );
  }

  private void function registerValidator(required any validator) {
    if ( structKeyExists(arguments.validator,"userValidator") ) {
      _instance['validator'] = arguments.validator;
    } else {
      throw(message="Validator object does not have a 'userValidator' method, I can only register objects with this interface method.", type="Security.validatorException");
    }
  }

}

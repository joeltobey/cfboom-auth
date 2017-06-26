/*
 * Copyright 2017 Joel Tobey <joeltobey@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @author Joel Tobey
 */
component {

    // Module Properties
    this.title              = "cfboom security";
    this.author             = "Joel Tobey";
    this.webURL             = "https://github.com/joeltobey/cfboom-security";
    this.description        = "The cfboom-security module provides overall security for your application.";
    this.version            = "1.1.0";
    // If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
    this.viewParentLookup   = true;
    // If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
    this.layoutParentLookup = true;
    // Module Entry Point
    this.entryPoint         = "cfboom/security";
    // Model Namespace
    this.modelNamespace     = "cfboomSecurity";
    // CF Mapping
    this.cfmapping          = "cfboom/security";
    // Auto-map models
    this.autoMapModels      = false;
    // Module Dependencies
    this.dependencies       = [ "cfboom-lang", "cfboom-util" ];

    function configure() {

        // module settings - stored in modules.name.settings
        settings = {
            strength = 10, // the log rounds to use for BCryptPasswordEncoder, between 4 and 31
            loadInterceptor = false,
            whitelist = ""
        };

        // Binder Mappings
        binder.map("BCryptPasswordEncoder@cfboomSecurity").to("cfboom.security.crypto.bcrypt.BCryptPasswordEncoder");
    }

    /**
     * Fired when the module is registered and activated.
     */
    function onLoad() {
        try {
            createObject("java", "org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder");
        } catch (any ex) {
            wirebox.getInstance( "loader@cbjavaloader" ).appendPaths( modulePath & "/lib" );
        }

        if ( settings.loadInterceptor ) {
            controller.getInterceptorService()
                .registerInterceptor(
                interceptorClass		= "cfboom.security.interceptors.Security",
                interceptorProperties	= settings,
                interceptorName			= "cfboomSecurity"
            );
        }
    }

    /**
     * Fired when the module is unregistered and unloaded
     */
    function onUnload() {}

}

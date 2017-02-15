/*
 * Copyright 2002-2015 the original author or authors and Joel Tobey <joeltobey@gmail.com>
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
 * @auther Joel Tobey
 */
component
    extends="coldbox.system.testing.BaseTestCase"
    appMapping="/root"
    displayname="Class BaseOAuth2ProtectedResourceDetailsTest"
    output="false"
{
    // this will run once after initialization and before setUp()
    public void function beforeTests() {
        super.beforeTests();
    }

    // this will run before every single test in this test case
    public void function setUp() {
        super.setup();
    }

    // this will run after every single test in this test case
    public void function reset() {
        super.reset();
    }

    // this will run once after all tests have been run
    public void function afterTests() {
        super.afterTests();
    }

    /**
     * @Test
     */
    public void function basic() {
        var details = new cfboom.security.oauth2.client.resource.BaseOAuth2ProtectedResourceDetails();
        assertEqualsCase("unsupported", details.getGrantType());
        assertEqualsCase("header", details.getClientAuthenticationScheme());
        assertEqualsCase("header", details.getAuthenticationScheme());
        assertEqualsCase("access_token", details.getTokenName());
    }
}
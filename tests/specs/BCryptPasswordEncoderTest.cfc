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
    displayname="Class BCryptPasswordEncoderTest"
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
    public void function matches() {
        var encoder = getInstance( name="BCryptPasswordEncoder@cfboomSecurity", initArguments={"strength":-1} );
        var result = encoder.encode("password");
        assertFalse( result.equals("password") );
        assertTrue( encoder.matches("password", result) );
    }

    /**
     * @Test
     */
    public void function unicode() {
        var encoder = getInstance( name="BCryptPasswordEncoder@cfboomSecurity", initArguments={"strength":-1} );
        var result = encoder.encode("passw\u9292rd");
        assertFalse( encoder.matches("pass\u9292\u9292rd", result) );
        assertTrue( encoder.matches("passw\u9292rd", result) );
    }

    /**
     * @Test
     */
    public void function notMatches() {
        var encoder = getInstance( name="BCryptPasswordEncoder@cfboomSecurity", initArguments={"strength":-1} );
        var result = encoder.encode("password");
        assertFalse( encoder.matches("bogus", result) );
    }

    /**
     * @Test
     */
    public void function customStrength() {
        var encoder = getInstance( name="BCryptPasswordEncoder@cfboomSecurity", initArguments={"strength":8} );
        var result = encoder.encode("password");
        assertTrue(encoder.matches("password", result));
    }

    /**
     * @Test (expected = IllegalArgumentException.class)
     */
    public void function badLowCustomStrength() {
        try {
            var encoder = getInstance( name="BCryptPasswordEncoder@cfboomSecurity", initArguments={"strength":3} );
        } catch (any ex) {
            if (ex.type != "java.lang.IllegalArgumentException") {
            	throw(object=ex);
            }
        }
    }

    /**
     * @Test (expected = IllegalArgumentException.class)
     */
    public void function badHighCustomStrength() {
        try {
            var encoder = getInstance( name="BCryptPasswordEncoder@cfboomSecurity", initArguments={"strength":32} );
        } catch (any ex) {
            if (ex.type != "java.lang.IllegalArgumentException") {
            	throw(object=ex);
            }
        }
    }

    /**
     * @Test
     */
    public void function doesntMatchNullEncodedValue() {
        var encoder = getInstance( name="BCryptPasswordEncoder@cfboomSecurity", initArguments={"strength":-1} );
        assertFalse( encoder.matches("password", javaCast("null", "")) );
    }

    /**
     * @Test
     */
    public void function doesntMatchEmptyEncodedValue() {
        var encoder = getInstance( name="BCryptPasswordEncoder@cfboomSecurity", initArguments={"strength":-1} );
        assertFalse( encoder.matches("password", "") );
    }

    /**
     * @Test
     */
    public void function doesntMatchBogusEncodedValue() {
        var encoder = getInstance( name="BCryptPasswordEncoder@cfboomSecurity", initArguments={"strength":-1} );
        assertFalse( encoder.matches("password", "012345678901234567890123456789") );
    }
}
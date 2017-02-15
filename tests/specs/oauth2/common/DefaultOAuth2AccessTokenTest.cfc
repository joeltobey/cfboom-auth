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
    displayname="Class DefaultOAuth2AccessTokenTest"
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
        var token = new cfboom.security.oauth2.common.DefaultOAuth2AccessToken("access_value");
        var token2 = new cfboom.security.oauth2.common.DefaultOAuth2AccessToken(accessToken = token);
        assertTrue(token.equals(token2), "token should equal token2");
        assertEqualsCase("access_value", token.getValue());
        assertEqualsCase("access_value", token.toString());
        token.setValue("new_value");
        assertEqualsCase("new_value", token.getValue());
        assertEqualsCase("new_value", token.toString());
        assertFalse(token.equals(token2), "token should not equal token2");
        $assert.null( token.getExpiration() );
        assertFalse( token.isExpired() );
        assertEquals(0, token.getExpiresIn());
        token.setExpiresIn(1500);
        assertEquals(1, token.getExpiresIn());
        assertFalse( token.isExpired() );
        sleep(1600);
        assertTrue( token.isExpired() );
        assertEqualsCase("bearer", token.getTokenType());
        token.setTokenType();
        assertEqualsCase("undefined", token.getTokenType());
        token.setTokenType("bearer");
        assertEqualsCase("bearer", token.getTokenType());
        $assert.null( token.getRefreshToken() );
        var refresh = new cfboom.security.oauth2.common.DefaultOAuth2RefreshToken("refresh_value");
        assertEqualsCase("refresh_value", refresh.getValue());
        assertEqualsCase("refresh_value", refresh.toString());
        token.setRefreshToken( refresh );
        assertTrue(isInstanceOf(token.getRefreshToken(), "cfboom.security.oauth2.common.DefaultOAuth2RefreshToken"));
        $assert.null( token.getScope() );
        token.setScope("read,write");
        assertEqualsCase("read,write", token.getScope());
        assertTrue(structIsEmpty(token.getAdditionalInformation()));
        token.setAdditionalInformation({"foo":"bar"});
        assertFalse(structIsEmpty(token.getAdditionalInformation()));
        assertEqualsCase("bar", token.getAdditionalInformation().foo);
    }

    /**
     * @Test
     */
    public void function valueOfBasic() {
    	var DefaultOAuth2AccessToken = createObject("component", "cfboom.security.oauth2.common.DefaultOAuth2AccessToken");
    	var tokenParams = {};
    	tokenParams['access_token'] = "access_value";
    	var token = DefaultOAuth2AccessToken.valueOf( tokenParams );
    	assertEqualsCase("access_value", token.getValue());
    }

    /**
     * @Test
     */
    public void function valueOfExpiresInBadNumber() {
    	var DefaultOAuth2AccessToken = createObject("component", "cfboom.security.oauth2.common.DefaultOAuth2AccessToken");
    	var tokenParams = {};
    	tokenParams['access_token'] = "access_value";
    	tokenParams['expires_in'] = "bad_number";
    	var token = DefaultOAuth2AccessToken.valueOf( tokenParams );
    	assertEqualsCase("access_value", token.getValue());
    	assertEquals(0, token.getExpiresIn());
    }

    /**
     * @Test
     */
    public void function valueOfExpiresIn() {
    	var DefaultOAuth2AccessToken = createObject("component", "cfboom.security.oauth2.common.DefaultOAuth2AccessToken");
    	var tokenParams = {};
    	tokenParams['access_token'] = "access_value";
    	tokenParams['expires_in'] = "3600";
    	var token = DefaultOAuth2AccessToken.valueOf( tokenParams );
    	assertEqualsCase("access_value", token.getValue());
    	assertEquals(3600, token.getExpiresIn());
    }

    /**
     * @Test
     */
    public void function valueOfRefreshToken() {
    	var DefaultOAuth2AccessToken = createObject("component", "cfboom.security.oauth2.common.DefaultOAuth2AccessToken");
    	var tokenParams = {};
    	tokenParams['access_token'] = "access_value";
    	tokenParams['refresh_token'] = "refresh_value";
    	var token = DefaultOAuth2AccessToken.valueOf( tokenParams );
    	assertEqualsCase("refresh_value", token.getRefreshToken().getValue());
    }

    /**
     * @Test
     */
    public void function valueOfMultiScope() {
    	var DefaultOAuth2AccessToken = createObject("component", "cfboom.security.oauth2.common.DefaultOAuth2AccessToken");
    	var tokenParams = {};
    	tokenParams['access_token'] = "access_value";
    	tokenParams['scope'] = "read write";
    	var token = DefaultOAuth2AccessToken.valueOf( tokenParams );
    	assertEquals(2, listLen(token.getScope()));
    	assertEqualsCase("read", listGetAt(token.getScope(), 1));
    	assertEqualsCase("write", listGetAt(token.getScope(), 2));
    }

    /**
     * @Test
     */
    public void function valueOfArrayScope() {
    	var DefaultOAuth2AccessToken = createObject("component", "cfboom.security.oauth2.common.DefaultOAuth2AccessToken");
    	var tokenParams = {};
    	tokenParams['access_token'] = "access_value";
    	tokenParams['scope'] = '["read", "write"]';
    	var token = DefaultOAuth2AccessToken.valueOf( tokenParams );
    	assertEquals(2, listLen(token.getScope()));
    	assertEqualsCase("read", listGetAt(token.getScope(), 1));
    	assertEqualsCase("write", listGetAt(token.getScope(), 2));
    }

    /**
     * @Test
     */
    public void function valueOfSingleScope() {
    	var DefaultOAuth2AccessToken = createObject("component", "cfboom.security.oauth2.common.DefaultOAuth2AccessToken");
    	var tokenParams = {};
    	tokenParams['access_token'] = "access_value";
    	tokenParams['scope'] = "write";
    	var token = DefaultOAuth2AccessToken.valueOf( tokenParams );
    	assertEquals(1, listLen(token.getScope()));
    	assertEqualsCase("write", listGetAt(token.getScope(), 1));
    }

    /**
     * @Test
     */
    public void function valueOfTokenType() {
    	var DefaultOAuth2AccessToken = createObject("component", "cfboom.security.oauth2.common.DefaultOAuth2AccessToken");
    	var tokenParams = {};
    	tokenParams['access_token'] = "access_value";
    	tokenParams['token_type'] = "foo";
    	var token = DefaultOAuth2AccessToken.valueOf( tokenParams );
    	assertEqualsCase("access_value", token.getValue());
    	assertEqualsCase("foo", token.getTokenType());
    }
}
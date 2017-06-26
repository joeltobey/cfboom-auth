/*
 * Copyright 2017 Joel Tobey <joeltobey@gmail.com>.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Implementation of PasswordEncoder that uses the BCrypt strong hashing function. Clients
 * can optionally supply a "strength" (a.k.a. log rounds in BCrypt) and a SecureRandom
 * instance. The larger the strength parameter the more work will have to be done
 * (exponentially) to hash the passwords. The default value is 10.
 *
 * @author Dave Syer
 *
 */
component
    extends="cfboom.lang.Object"
    implements="cfboom.security.crypto.password.PasswordEncoder"
    displayname="Class BCryptPasswordEncoder"
    output="false"
{
	property name="strength" inject="coldbox:setting:strength@cfboom-security";
    property name="wirebox" inject="wirebox";

    _instance['useJavaLoader'] = false;

	public cfboom.security.crypto.bcrypt.BCryptPasswordEncoder function init(numeric strength = -1) {
		_instance['strength'] = javaCast("int", arguments.strength);
		return this;
	}

    public void function onDIComplete() {
        try {
            createObject("java", "com.google.gson.JsonPrimitive");
            _instance['BCryptPasswordEncoder'] = createObject("java", "org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder").init( _instance.strength );
        } catch (any ex) {
            _instance['useJavaLoader'] = true;
            _instance['javaLoader'] = wirebox.getInstance( "loader@cbjavaloader" );
            _instance['BCryptPasswordEncoder'] = _instance.javaLoader.create( "org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder" ).init( _instance.strength );
        }
    }

    public string function encode(required string rawPassword) {
        return _instance.BCryptPasswordEncoder.encode( arguments.rawPassword );
    }

    public boolean function matches(string rawPassword, string encodedPassword) {
        return _instance.BCryptPasswordEncoder.matches( structKeyExists(arguments, "rawPassword") ? arguments.rawPassword : javaCast("null", ""), structKeyExists(arguments, "encodedPassword") ? arguments.encodedPassword : javaCast("null", "") );
    }
}
/*
 * Copyright 2017-2019 Joel Tobey <joeltobey@gmail.com>.
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
  property name="javaLoader" inject="JavaLoader@cfboom-security";

  public cfboom.security.crypto.bcrypt.BCryptPasswordEncoder function init() {
    return this;
  }

  public void function onDIComplete() {
    variables['_BCryptPasswordEncoder'] = variables.javaLoader.create( "org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder" ).init( javaCast( "int", variables.strength ) );
  }

  public string function encode(required string rawPassword) {
    return variables._BCryptPasswordEncoder.encode( arguments.rawPassword );
  }

  public boolean function matches(string rawPassword, string encodedPassword) {
    return variables._BCryptPasswordEncoder.matches( structKeyExists(arguments, "rawPassword") ? arguments.rawPassword : javaCast("null", ""), structKeyExists(arguments, "encodedPassword") ? arguments.encodedPassword : javaCast("null", "") );
  }
}

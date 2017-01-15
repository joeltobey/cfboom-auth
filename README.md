[![Build Status](https://api.travis-ci.org/joeltobey/cfboom-security.svg?branch=development)](https://travis-ci.org/joeltobey/cfboom-security)

# Welcome to the cfboom HTTP Coldbox Module
The cfboom-security module provides overall security for your application. It utilizes Spring Security to provide BCrypt encoding.

## License
Apache License, Version 2.0.

## Important Links
- https://github.com/joeltobey/cfboom-security/wiki

## System Requirements
- Lucee 4.5+
- ColdFusion 9+

# Instructions
Just drop into your **modules** folder or use CommandBox to install

`box install cfboom-security`

## WireBox Mappings
The module registers the BCryptPasswordEncoder: `BCryptPasswordEncoder@cfboomSecurity` that allows you to encode raw passwords and match encoded passwords with the raw password. Check out the API Docs for all the possible functions.

## Settings
There's an optional setting in your `ColdBox.cfc` file under a `cfboomSecurity` struct to override the default `strength`:

```js
moduleSettings = {
	cfboomSecurity = {
		strength = 10 // the log rounds to use for BCryptPasswordEncoder, between 4 and 31
	}
};
```

## BCryptPasswordEncoder Methods

Once you have an instance of the `BCryptPasswordEncoder`, you can call these methods:

```
var encodedPassword = getInstance( "BCryptPasswordEncoder@cfboomSecurity" ).encode( "password" );
```

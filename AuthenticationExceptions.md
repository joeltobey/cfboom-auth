/*
 * Copyright 2002-2015 the original author or authors and Joel Tobey <joel@joeltobey.com>
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

Authentication									jetsecurity.core.AuthenticationException

Authentication.AccountStatus					jetsecurity.authentication.AccountStatusException
Authentication.AccountStatus.AccountExpired		jetsecurity.authentication.AccountExpiredException
Authentication.AccountStatus.CredentialsExpired	jetsecurity.authentication.CredentialsExpiredException
Authentication.AccountStatus.Disabled			jetsecurity.authentication.DisabledException
Authentication.AccountStatus.Locked				jetsecurity.authentication.LockedException

Authentication.BadCredentials					jetsecurity.authentication.BadCredentialsException

Authentication.CredentialsNotFound				jetsecurity.authentication.AuthenticationCredentialsNotFoundException

Authentication.Service							jetsecurity.authentication.AuthenticationServiceException
Authentication.Service.Internal					jetsecurity.authentication.InternalAuthenticationServiceException

Authentication.Insufficient						jetsecurity.authentication.InsufficientAuthenticationException

Authentication.UsernameNotFound					jetsecurity.core.userdetails.UsernameNotFoundException

Authentication.ProviderNotFound					jetsecurity.authentication.ProviderNotFoundException


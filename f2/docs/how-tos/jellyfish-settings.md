Jellyfish Settings
==============

__There are two ways to set your Jellyfish Settings credentials:__

1.  All application settings can be configured using environment variables in the operating system's environment.

2.  Create a `.env` file in the api directory (this should only be used during development). 


#### Application Environment Variables

__Required__:

```
DATABASE_URL                           = postgres://username:@yourapp.com:5432/yourdb
CORS_ALLOW_ORIGIN                      = yourapp.com:5000
DEFAULT_URL                            = http://yourapp.com:3000
SECRET_KEY_BASE                        = change_me_to_a_bunch_of_gibberish
DEVISE_SECRET_KEY                      = keep_me_secret
```
**_Optional_**:

```
PUMA_WORKERS                           = 3
MIN_THREADS                            = 8
MAX_THREADS                            = 16
PORT                                   = 3000
RAILS_ENV                              = test
RACK_ENV                               = development
```

---
#### Gems

__Manage IQ Environment Variables__

<a href="https://github.com/projectjellyfish/jellyfish-manageiq" target="_blank">Jellyfish Manage IQ</a>

Required:
```
MIQ_URL                                = https://miq-url.com
MIQ_REFERER                            = http://yourapp.com
MIQ_USERNAME                           = username
MIQ_PASSWORD                           = password
MIQ_USER_EMAIL                         = miq@pyourapp.com
MIQ_USER_TOKEN                         = jellyfish
```
_Optional_:
```
MIQ_SSL                                  = OpenSSL::SSL::VERIFY_PEER
```

---

__Jellyfish Audit__

<a href="https://github.com/projectjellyfish/jellyfish-audit/search?utf8=%E2%9C%93&q=env" target="_blank">Jellyfish Audit</a>.

_Optional_:
```
LOG_TO_FILE                              = true # Any value other than true sets this to false
```

---
__Jellyfish SAML Auth Environment Variables__

* <a href="https://github.com/onelogin/ruby-saml" target="_blank">Ruby SAML</a>
* <a href="https://github.com/PracticallyGreen/omniauth-saml" target="_blank">OmniAuth SAML</a>
* <a href="https://github.com/projectjellyfish/jellyfish-samlauth" target="_blank">Jellyfish SAML</a>

Required:

* SP Settings
```
# Defaults to http(s)://<hostname>/<path_prefix>/:provider/metadata.xml if not entered
SAML_ISSUER                              = http://www.example.com/saml/metadata.xml
SAML_CERTIFICATE                         = "-----BEGIN CERTIFICATE-----\nMIIDbzCCAtigAwIBAgIJALLyD62/xQ5WMA0GCSqGSIb3DQEBBQUAMIGCMQswCQYD\nVQQGEwJVUzEOMAwGA1UECBMFVGV4YXMxITAfBgNVBAoTGEludGVybmV0IFdpZGdp\ndHMgUHR5IEx0ZDEYMBYGA1UEAxMPSmVyaW1pYWggTWlsdG9uMSYwJAYJKoZIhvcN\nAQkBFhdtaWx0b25famVyaW1pYWhAYmFoLmNvbTAeFw0xNTA0MDkyMDI3MzlaFw0x\nODA0MDgyMDI3MzlaMIGCMQswCQYDVQQGEwJVUzEOMAwGA1UECBMFVGV4YXMxITAf\nBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDEYMBYGA1UEAxMPSmVyaW1p\nYWggTWlsdG9uMSYwJAYJKoZIhvcNAQkBFhdtaWx0b25famVyaW1pYWhAYmFoLmNv\nbTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAlG570+tDpHHkVJASVhaUIYwN\nwN4zePFDBUkwmtGSho5NF8glIunZDNjnJ1mG5TG15Eg3UvJUk6+xsN9VXCdBS4Y8\nLpUhT2bhbiZWWvDKcbDOPOq8pDTlhBC2YBEvFtuPkCx2tA7H8m0o+JRH+GokaDSY\nI8WhH9mii1PpgEvBzKkCAwEAAaOB6jCB5zAdBgNVHQ4EFgQUHa3b8vUm18bOsMuE\nXf9JLxyiVJgwgbcGA1UdIwSBrzCBrIAUHa3b8vUm18bOsMuEXf9JLxyiVJihgYik\ngYUwgYIxCzAJBgNVBAYTAlVTMQ4wDAYDVQQIEwVUZXhhczEhMB8GA1UEChMYSW50\nZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMRgwFgYDVQQDEw9KZXJpbWlhaCBNaWx0b24x\nJjAkBgkqhkiG9w0BCQEWF21pbHRvbl9qZXJpbWlhaEBiYWguY29tggkAsvIPrb/F\nDlYwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQUFAAOBgQAKu7O244ykwkD3GoMJ\nrX9D+Wnb40yKaf+nw2HOzFJoBUfw8ZAg8bCpylKfgtDeNHF8maS2GYNgV6DSVpvN\nZO010V1TQElu+KjiA7tmO/+Q7f+rK4cs9rxdadlxViqKQRNMCfkHE9/zLR55BhF1\nEsfmBbBdnRLMj4mjPc9gk+wh8w==\n-----END CERTIFICATE-----"
# Defaults to http(s)://<hostname>/<path_prefix>/:provider/callback?<query_string> if not entered
SAML_ASSERTION_CONSUMER_SERVICE_URL      = http://yourapp.com/auth/saml/callback
# Defaults to urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST if not entered
SAML_ASSERTION_CONSUMER_SERVICE__BINDING = urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST
SAML_COMPRESS_REQUEST                    = true # Defaults to true
SAML_COMPRESS_RESPONSE                   = true # Defaults to true
SAML_DOUBLE_QUOTE_XML_ATTRIBUTE_VALUES   = false # Defaults to false
SAML_PASSIVE                             = false # Defaults to false
# ------------------------------------------------------------------------------
## Security Settings
# ------------------------------------------------------------------------------
# Defaults to false if not entered
SAML_AUTHN_REQUESTS_SIGNED               = false # Defaults to false
SAML_LOGOUT_REQUESTS_SIGNED              = false # Defaults to false
SAML_LOGOUT_RESPONSES_SIGNED             = false # Defaults to false
SAML_EMBED_SIGNED                        = false # Defaults to false
# Defaults to XMLSecurity::Document::SHA1 if not entered
SAML_DIGEST_METHOD                       = XMLSecurity::Document::SHA1
# Defaults to XMLSecurity::Document::SHA1 if not entered
SAML_SIGNATURE_METHOD                    = XMLSecurity::Document::SHA1
## Attribute Service Settings
SAML_ATTRIBUTES_INDEX                    = nil # Defaults to nil
SAML_SERVICE_NAME                        = nil # Defaults to nil
SAML_SERVICE_INDEX                       = nil # Defaults to nil
# For each attribute create an environment variable with the number of the attribute as a suffix
#### Example:
SAML_ATTRIBUTE_1="name: 'Name', name_format: 'Name Format', friendly_name: 'Friendly Name'"
SAML_ATTRIBUTE_2="name: 'Another Attibute', name_format: 'Name Format', friendly_name: 'Friendly Name', attribute_value: 'Attribute Value'"
```

Required:

* IdP Settings
```
# Required unless SAML_IDP_METADATA_URL is set
SAML_IDP_SSO_TARGET_URL                  = nil # Defaults to nil
# Either idp_cert, idp_cert_fingerprint or idp_cert_fingerprint_validator must be present
SAML_IDP_CERT                            = nil # Defaults to nil
SAML_IDP_CERT_FINGERPRINT                = nil # Defaults to nil
# Defaults to -> (fingerprint) { fingerprint } if not entered
SAML_IDP_CERT_FINGERPRINT_VALIDATOR      = "-> (fingerprint) { fingerprint }"
```
_Optional_:
```
SAML_IDP_SLO_TARGET_URL                  = nil # Defaults to nil
# Defaults to { original_request_param: :mapped_idp_param } if not entered
SAML_IDP_SSO_TARGET_URL_RUNTIME_PARAMS   = "{ original_request_param: :mapped_idp_param }"
SAML_IDP_ENTITY_ID                       = nil # Defaults to nil
# Defaults to -> { XMLSecurity::Document::SHA1 } if not entered
SAML_IDP_CERT_FINGERPRINT_ALGORITHM      = "-> { XMLSecurity::Document::SHA1 }"
SAML_SINGLE_LOGOUT_SERVICE_URL           = nil # Defaults to nil
SAML_LOGOUT_SERVICE_BINDING              = nil # Defaults to nil
# ------------------------------------------------------------------------------
# Required for devise scope, defaults to /api/v1/staff/auth if not entered
SAML_PATH_PREFIX                         = /api/v1/staff/auth
```

---
__Jellyfish LDAP Auth Environment Variables__

<a href="https://github.com/intridea/omniauth-ldap" target="_blank">OmniAuth LDAP</a>
<a href="https://github.com/projectjellyfish/jellyfish-ldapauth" target="_blank">Jellyfish LDAP</a>

Required:
```
LDAP_HOST                                = ldap.company.com
LDAP_BASE                                = ou=Users,o=organization_id,dc=company,dc=com
LDAP_BIND_DN                             = uid=username,ou=Admins,o=organization_id,dc=company,dc=com
LDAP_PASSWORD                            = password
```
_Optional_:
```
LDAP_TILE                                = "LDAP Authentication"
LDAP_PORT                                = 389
# Can be :plain, :ssl or :tls
LDAP_METHOD                              = :plain
LDAP_UID                                 = sAMAccountName
# Can use name proc or filter, both are optional
LDAP_NAME_PROC                           = "Proc.new {|name| name.gsub(/@.*$/,'')}" # Defaults to "Proc.new {|n| n}"
LDAP_FILTER                              = "(&(uid=%{username})(memberOf=cn=myapp-users,ou=groups,dc=example,dc=com))" # Defaults to nil
```

---
__Fog AWS Environment Variables__

<a href="https://github.com/projectjellyfish/jellyfish_fog_aws" target="_blank">Jellyfish Fog AWS</a>

Required:
```
AWS_ACCESS_KEY                           = Th1sK3Yd0eSn0tW0rK
AWS_SECRET_KEY                           = N31tH3rD03sTh1sK3y
```
_Optional_:
```
MOCK_FOG                                 = true # If this variable is present, it's evaluated as true
```

---
__Jellyfish Azure Environment Variables__

<a href="https://github.com/projectjellyfish/jellyfish-azure" target="_blank">Jellyfish Azure</a>

Required:
```
JF_AZURE_SUB_ID                          = YOUR_AZURE_SUBSCRIPTION_ID
JF_AZURE_PEM_PATH                        = YOUR_AZURE_PEM_PATH
JF_AZURE_API_URL                         = https://management.core.windows.net
```

---
__Jellyfish GitHub Environment Variables__

<a href="https://github.com/projectjellyfish/jellyfish-github" target="_blank">Jellyfish GitHub</a>

Required:
```
GIT_HUB_TOKEN                            = API_TOKEN
GIT_HUB_ORG                              = YOUR_ORGANIZATION # Currently not being used
GIT_HUB_TEAM_ID                          = YOUR_GITHUB_TEAM_ID
```

---

__Jellyfish Notice Environment Variables__

<a href="https://github.com/projectjellyfish/jellyfish-notice" target="_blank">Jellyfish Notice</a>

Required
```
PJ_PERFORM_DELIVERIES                    = true
PJ_DELIVERY_METHOD                       = smtp
PJ_SMTP_ADDRESS                          = localhost
PJ_SMTP_PORT                             = 25
PJ_SMTP_USER_NAME                        = API-KEY
PJ_SMTP_PASSWORD                         = API-KEY
PJ_SMTP_AUTHENTICATION                   = plain
PJ_SMTP_ENABLE_STARTTLS_AUTO             = true
PJ_SMTP_DEFAULT_RECIPIENT                = someonesname@somedomain.com
PJ_SMTP_DEFAULT_SENDER                   = yourname@yourapp.com
```
---

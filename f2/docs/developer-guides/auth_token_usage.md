Authorization Token Usage
============

#### Sign-In

* Sign-in at POST `api/v1/staff/sign_in.json` with the following payload
````
{ staff: {email: "...", password: "..."} }
````
* Grab and keep the api_token from the response
* Add an 'Authorization' header with the value of Jellyfish {api_token} or add a url parameter of access_token={api_token}
* If your cookie is deleted it will be recreated as long as the next request includes a valid token. You are not required to keep the cookie or to even accept them when using tokens (but if you can it is recommended).

#### Sign-out

* Sign-out at DELETE `api/v1/staff/sign_out`
* The token will be invalidated along with the session.

# ORCID Integration [![Build Status](https://travis-ci.org/jeremyf/orcid_integration.png?branch=master)]

## You'll Need a (Self Signed) Certificate

* http://www.railway.at/2013/02/12/using-ssl-in-your-local-rails-environment/
* https://gist.github.com/trcarden/3295935

## You'll need to run under SSL

```bash
$ thin start -p 3000 --ssl --ssl-verify --ssl-key-file server.key --ssl-cert-file server.crt
```
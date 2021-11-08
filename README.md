# Pronto runner for Flay

[![Code Climate](https://codeclimate.com/github/prontolabs/pronto-flay.png)](https://codeclimate.com/github/prontolabs/pronto-flay)
[![Build Status](https://travis-ci.org/prontolabs/pronto-flay.png)](https://travis-ci.org/prontolabs/pronto-flay)
[![Gem Version](https://badge.fury.io/rb/pronto-flay.png)](http://badge.fury.io/rb/pronto-flay)
[![Dependency Status](https://gemnasium.com/prontolabs/pronto-flay.png)](https://gemnasium.com/prontolabs/pronto-flay)

Pronto runner for [Flay](https://github.com/seattlerb/flay), structural similarities analyzer. [What is Pronto?](https://github.com/prontolabs/pronto)

# Configuration

Configuring excludes Using [.flayignore](https://github.com/seattlerb/flay/blob/92039b66a479f3b8a8a1204c5733e35463e66995/README.txt#L28) will work just fine with pronto-flay.

You can overwrite the default, very low mass threshold for Flay with the PRONTO_FLAY_MASS_THRESHOLD environment variable for a more sensible approach.

Severity levels for identical and similar code issues can be configured inside `.pronto.yml`:
```yaml
flay:
  severity_levels:
    identical: 'warning'
    similar: 'warning'
```

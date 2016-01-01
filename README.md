rack-secure_headers [![Build Status](https://travis-ci.org/frodsan/rack-secure_headers.svg)](https://travis-ci.org/frodsan/rack-secure_headers)
-------------------

Security related HTTP headers for Rack applications.

Description
-----------

Implements OWASP's [List of useful HTTP headers][owasp].

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem "rack-secure_headers"
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install rack-secure_headers
```

Usage
-----

```ruby
# config.ru
require "rack/secure_headers"

use(Rack::SecureHeaders, options)
```

Options
-------

This is a list of the supported options included by default.
To disable any default, pass `nil` (e.g. `option: nil`).

| Option                             | Header                            | Default                                             |
| ---------------------------------- | --------------------------------- | --------------------------------------------------- |
| :hsts                              | Strict-Transport-Security         | `{ max_age: "31536000", include_subdomains: true }` |
| :x_content_type_options            | X-Content-Type-Options            | `"nosniff"`                                         |
| :x_frame_options                   | X-Frame-Options                   | `"SAMEORIGIN"`                                      |
| :x_permited_cross_domain           | X-Permitted-Cross-Domain-Policies | `"none"`                                            |
| :x_xss_protection                  | X-XSS-Protection                  | `"1; mode=block"`                                   |

Headers
-------

This is a list of the supported HTTP headers:

* **Strict-Transport-Security:**

  Ensures the browser never visits the http version of a website.
  This reduces impact of bugs in web applications leaking session
  data through cookies and external links and defends against
  Man-in-the-middle attacks. Supported options:

  * `:max_age`: The time, in seconds, that the browser should remember that
    the site is only to be accessed using HTTPS. Defaults to 1 year.
  * `:includeSubdomains`: If this is `true`, this rule is applied to all
    of the site's subdomains as well. Defaults to `true`.
  * `:preload`: A limitation of HSTS is that the initial request remains
    unprotected if it uses HTTP. The same applies to the first request
    after the activity period specified by `max-age`. Chrome, Firefox and
    IE11+ implements a "STS preloaded list", which contains known sites
    supporting HSTS. If you would like your domain to be included in the
    preloaded list, set this options to `true` and submit your domain to
    this [form][hsts-form].

* **X-Content-Type-Options:**

  Prevents IE and Chrome from [content type sniffing][mime-sniffing].

* **X-Frame-Options (XFO):**

  Provides [Clickjacking][clickjacking] protection. Supported values:

  * `DENY` - Prevents any domain from framing the content.
  * `SAMEORIGIN` - Only allows current site to frame the content.
  * `ALLOW-FROM URI` - Allows the specified `URI` to frame the content
    (only IE8+ and Firefox).

  Check the [X-Frame-Options draft][x-frame-options] for more information.

* **X-Permitted-Cross-Domain-Policies:**

  Restrict Adobe Flash Player's access to data. Check this [article][pcdp]
  for more information.

* **X-XSS-Protection:**

  Enables the [XSS][xss] protection filter built into IE, Chrome and Safari.
  Supported values are `0`, which disables the protection, `1` which enables
  it and `1; mode=block` (default) which tells the browser to block the
  response if it detects an attack. This filter is usually enabled by default,
  the use of this header is to re-enable it if it was disabled by the user.

Use <https://securityheaders.io> to asses the security related HTTP
headers used by your site.

TODO
----

- [ ] HTTP Public Key Pinning (HPKP).
- [ ] Content Security Policy (CSP).

Contributing
------------

Fork the project with:

```
$ git clone git@github.com:frodsan/rack-secure_headers.git
```

To install dependencies, use:

```
$ bundle install
```

To run the test suite, do:

```
$ rake test
```

For bug reports and pull requests use [GitHub][issues].

License
-------

This gem is released under the [MIT License][mit].

[clickjacking]: https://www.owasp.org/index.php/Clickjacking
[hsts-form]: https://hstspreload.appspot.com/
[issues]: https://github.com/frodsan/rack-secure_headers/issues
[mime-sniffing]: https://msdn.microsoft.com/library/gg622941(v=vs.85).aspx
[mit]: http://www.opensource.org/licenses/MIT
[owasp]: https://www.owasp.org/index.php/List_of_useful_HTTP_headers
[pcdp]: https://www.adobe.com/devnet/adobe-media-server/articles/cross-domain-xml-for-streaming.html
[xss]: https://www.owasp.org/index.php/Cross-site_Scripting_(XSS)
[x-frame-options]: https://tools.ietf.org/html/draft-ietf-websec-x-frame-options-02

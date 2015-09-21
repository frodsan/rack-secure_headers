require "rack"

module Rack
  class SecureHeaders
    DEFAULTS = {
      hsts: { max_age: "31536000", include_subdomains: true },
      x_content_type_options: "nosniff",
      x_frame_options: "SAMEORIGIN",
      x_permitted_cross_domain_policies: "none",
      x_xss_protection: "1; mode=block"
    }

    def initialize(app, options = {})
      @app = app
      @options = DEFAULTS.merge(options)
    end

    def call(env)
      status, headers, body = @app.call(env)

      add_base_headers(headers, @options)

      add_hsts_header(headers, @options[:hsts]) if @options[:hsts]

      return [status, headers, body]
    end

    private

    BASE_HEADERS = {
      x_content_type_options: "X-Content-Type-Options",
      x_frame_options: "X-Frame-Options",
      x_permitted_cross_domain_policies: "X-Permitted-Cross-Domain-Policies",
      x_xss_protection: "X-XSS-Protection"
    }

    def add_base_headers(headers, options)
      BASE_HEADERS.each do |key, header|
        headers[header] = options[key] if options[key]
      end
    end

    HSTS_HEADER = "Strict-Transport-Security".freeze
    HSTS_MAX_AGE = "max-age=%s".freeze
    HSTS_INCLUDE_SUBDOMAINS = "; includeSubdomains".freeze
    HSTS_PRELOAD = "; preload".freeze

    def add_hsts_header(headers, opts)
      header = sprintf(HSTS_MAX_AGE, opts.fetch(:max_age))
      header << HSTS_INCLUDE_SUBDOMAINS if opts[:include_subdomains]
      header << HSTS_PRELOAD if opts[:preload]

      headers[HSTS_HEADER] = header
    end
  end
end

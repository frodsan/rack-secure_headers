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

    DEFAULT_HEADERS = {
      x_content_type_options: "X-Content-Type-Options",
      x_frame_options: "X-Frame-Options",
      x_permitted_cross_domain_policies: "X-Permitted-Cross-Domain-Policies",
      x_xss_protection: "X-XSS-Protection"
    }

    HSTS_HEADER = "Strict-Transport-Security".freeze

    def initialize(app, options = {})
      @app = app
      @options = DEFAULTS.merge(options)
    end

    def call(env)
      status, headers, body = @app.call(env)

      DEFAULT_HEADERS.each do |key, header|
        headers[header] = @options[key] if @options[key]
      end

      if @options[:hsts]
        headers[HSTS_HEADER] = Utils.hsts(@options[:hsts])
      end

      return [status, headers, body]
    end

    module Utils
      HSTS_MAX_AGE = "max-age=%s".freeze
      HSTS_INCLUDE_SUBDOMAINS = "; includeSubdomains".freeze
      HSTS_PRELOAD = "; preload".freeze

      def self.hsts(opts)
        header = sprintf(HSTS_MAX_AGE, opts.fetch(:max_age))
        header << HSTS_INCLUDE_SUBDOMAINS if opts[:include_subdomains]
        header << HSTS_PRELOAD if opts[:preload]

        return header
      end
    end
  end
end

# frozen_string_literal: true

require_relative "helper"

class App
  def call(_)
    [200, {}, [""]]
  end
end

class SecureHeadersTest < Minitest::Test
  setup do
    @app = App.new
  end

  test "defaults" do
    middleware = Rack::SecureHeaders.new(@app)
    headers = middleware.call({})[1]

    expected = {
      "X-Content-Type-Options" => "nosniff",
      "X-Frame-Options" => "SAMEORIGIN",
      "X-Permitted-Cross-Domain-Policies" => "none",
      "X-XSS-Protection" => "1; mode=block",
      "Strict-Transport-Security" => "max-age=31536000; includeSubdomains"
    }

    assert_equal expected, headers
  end

  test "nil" do
    headers = Rack::SecureHeaders::DEFAULTS.keys
    options = headers.map { |h| [h, nil] }.to_h

    middleware = Rack::SecureHeaders.new(@app, options)
    headers = middleware.call({})[1]

    assert headers.empty?
  end

  test "hsts options" do
    middleware = Rack::SecureHeaders.new(@app, hsts: {max_age: 1})
    headers = middleware.call({})[1]

    assert_equal "max-age=1", headers["Strict-Transport-Security"]

    options = {max_age: 1, include_subdomains: true, preload: true}
    middleware = Rack::SecureHeaders.new(@app, hsts: options)
    headers = middleware.call({})[1]

    expected = "max-age=1; includeSubdomains; preload"

    assert_equal expected, headers["Strict-Transport-Security"]
  end
end

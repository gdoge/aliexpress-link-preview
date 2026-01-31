# frozen_string_literal: true

module AliExpressRedirect
  class Middleware
    ALIEXPRESS_REGEX = %r{\Ahttps?://(www\.)?aliexpress\.com(/.*)?}i

    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      # Nur normale Seitenaufrufe
      return @app.call(env) unless request.get?

      # Nur AliExpress
      return @app.call(env) unless request.url.match?(ALIEXPRESS_REGEX)

      # Aktuellen User ermitteln
      current_user = env["current_user"]

      return @app.call(env) unless current_user
      return @app.call(env) if staff?(current_user)

      # Ziel-URL bauen
      redirected_url = build_redirect_url(request.url)

      return [
        302,
        { "Location" => redirected_url },
        ["Redirecting..."]
      ]
    end

    private

    def staff?(user)
      user.admin? || user.moderator?
    end

    def build_redirect_url(original_url)
      original_url.sub(/aliexpress\.com/i, "myshop")
    end
  end
end

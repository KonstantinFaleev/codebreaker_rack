module Codebreaker
  module Utils
    private

    def expand_score_class
      Score.instance_eval do
        attr_accessor :token, :ip
      end

      Score.class_eval do
        def update
          yield self if block_given?
        end
      end
    end

    def define_session_accessors
      %i[game token ip scores last_guess marker hint].each do |method|
        self.class.class_eval do
          define_method(method.to_s) do
            request.session[method]
          end

          define_method("#{method}=") do |value|
            request.session[method] = value
          end
        end
      end
    end

    def create_game_instance
      self.game ||= Game.new do |config|
        create_config(config)
      end
    end

    # rubocop:disable Metrics/AbcSize
    def create_config(config)
      config.player_name = request.params['player_name']
      config.max_attempts = Web::ATTEMPTS[request.params['level'].to_sym]
      config.max_hints = Web::HINTS[request.params['level'].to_sym]
      config.level = request.params['level'].to_sym
      config.lang = locale.lang
    end
    # rubocop:enable Metrics/AbcSize

    def generate_token
      self.token ||= SecureRandom.uuid
    end

    def set_client_ip
      self.ip = request.ip
    end

    def save_extended_user_data
      scores.last.update do |score|
        score.token = token
        score.ip = ip
      end
    end

    def first_attempt?
      game.attempts == game.configuration.max_attempts
    end

    def load_scores
      self.scores = load_game_data
    end

    def game_over?
      game.won? || game.attempts.zero?
    end

    def hints_allowed?
      !game_over? && game.hints.positive?
    end

    def save_game_data
      save_user_score
      save_extended_user_data
      save_to_yml
    end

    def render(template)
      path = File.expand_path("../views/#{template}.html.haml", __FILE__)
      Haml::Engine.new(File.read(path)).render(binding)
    end

    def template(erb_name)
      Rack::Response.new(render(erb_name))
    end

    def error_template(erb_name, status, &err_msg)
      Rack::Response.new(render(erb_name) { err_msg.call }, status)
    end

    def go_to(url)
      Rack::Response.new do |response|
        response.redirect(url)
      end
    end

    def referer
      if request.referer && request.referer[%r{/\A.+/{2}.+(/.+)\z/}, 1]
        request.referer[%r{/\A.+/{2}.+(/.+)\z/}, 1]
      else
        Web::ROOT_URL
      end
    end
  end
end

require 'codebreaker'
require 'erb'

localization_dir = File.expand_path('./lib/locale/.', File.dirname(__FILE__))

use Rack::Reloader, 0
use Rack::Session::Pool,
      secret: SecureRandom.alphanumeric,
      locale: Codebreaker::Localization.new(:web, localization_dir)
use Codebreaker::ErrorLogger
use Codebreaker::ActionsInspector

run Rack::Cascade.new([Rack::File.new('public'), Codebreaker::Web])

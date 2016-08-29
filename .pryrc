Pry.config.editor = "atom"

# Load Rails Console helpers like reload
require 'rails/console/app'
extend Rails::ConsoleMethods

Pry.config.prompt = proc do |obj, level, _|
  prompt = "\e[1;30m"
  prompt << "#{RUBY_VERSION}"
  prompt << " - #{Rails.version}" if defined?(Rails.version)
  "#{prompt} (#{obj})>\e[0m "
end

Pry.config.exception_handler = proc do |output, exception, _|
  output.puts "\e[31m#{exception.class}: #{exception.message}"
  output.puts "from #{exception.backtrace.first}\e[0m"
end

begin
  require "awesome_print"
  Pry.config.print = proc { |output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output) }
rescue LoadError
  puts "=> Unable to load awesome_print"
end

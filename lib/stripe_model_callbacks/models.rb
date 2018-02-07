dir = "#{File.dirname(__FILE__)}/models"
Dir.foreach(dir) do |file|
  next unless file =~ /\A(.+)\.rb\Z/
  require_relative "models/#{file}"
end

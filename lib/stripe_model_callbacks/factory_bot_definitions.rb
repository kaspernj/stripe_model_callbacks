factories_path = File.realpath("#{File.dirname(__FILE__)}/../../spec/factories")

Dir.foreach(factories_path) do |file|
  next unless file =~ /\A(.+)\.rb\Z/
  require "#{factories_path}/#{file}"
end

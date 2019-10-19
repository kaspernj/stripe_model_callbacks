factories_path = File.realpath("#{File.dirname(__FILE__)}/../../spec/factories")

Dir.foreach(factories_path) do |file|
  next unless /\A(.+)\.rb\Z/.match?(file)

  require "#{factories_path}/#{file}"
end

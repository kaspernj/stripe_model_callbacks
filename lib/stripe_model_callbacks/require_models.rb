dir = "#{File.dirname(__FILE__)}/models"
Dir.foreach(dir) do |file|
  match = file.match(/\A(.+)\.rb\Z/)
  next unless match

  require "#{dir}/#{file}"
end

dir = "#{File.dirname(__FILE__)}/models"
Dir.foreach(dir) do |file|
  match = file.match(/\A(.+)\.rb\Z/)
  next unless match

  constant_name = match[1].camelize
  Object.autoload(constant_name, "#{dir}/#{file}")
end

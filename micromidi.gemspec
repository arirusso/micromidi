# Rakefile

require 'rubygems/package_task'

spec = Gem::Specification.new do |s|
  s.name        = 'micromidi'
  s.version     = '0.2.1'
  s.authors     = ['Ari Russo']
  s.email       = 'your_email@example.com'
  s.summary     = 'Brief summary of your gem'
  s.description = 'Detailed description of your gem'
  s.homepage    = 'https://github.com/DoubleJarvis/micromidi'
  s.license     = 'Apache License 2.0'

  s.files       = Dir['lib/**/*.rb']
  s.require_paths = ['lib']
end

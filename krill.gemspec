Gem::Specification.new do |s|
  s.name        = 'krill'
  s.version     = '0.0.0'
  s.date        = '2015-10-06'
  s.summary     = 'A micro framework for built on top of Prawn'
  s.description = 'A component architecture built on top of Prawn, used to emulate a floating box model'
  s.authors     = ['Dean Nasseri']
  s.email       = 'dean@vts.com'
  s.files       = ['lib/krill.rb', 'lib/krill/main_component.rb', 'lib/krill/base_component.rb']
  s.homepage    = 'http://rubygems.org/gems/hola'
  s.license     = 'MIT'
  s.add_dependency 'prawn', '~> 2.0'
end
